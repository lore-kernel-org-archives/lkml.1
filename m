Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbXEJFmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbXEJFmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXEJFmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:42:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59582 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbXEJFmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:42:43 -0400
Date: Thu, 10 May 2007 14:41:07 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: Section mismatch warnings (was Re: [PATCH] early_pfn_to_nid needs to be __meminit)
Cc: Linas Vepstas <linas@austin.ibm.com>, Gabriel Paubert <paubert@iram.es>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1178740693.3086.81.camel@zod.rchland.ibm.com>
References: <20070509194503.GZ4452@austin.ibm.com> <1178740693.3086.81.camel@zod.rchland.ibm.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070510141827.A967.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add to CC: Sam-san. :-)

> On Wed, 2007-05-09 at 14:45 -0500, Linas Vepstas wrote:
> > On Wed, May 09, 2007 at 06:51:15PM +0200, Gabriel Paubert wrote:
> > > On Thu, May 10, 2007 at 02:25:52AM +1000, Stephen Rothwell wrote:
> > > > This removes a section mismatch warning in those circumstances.
> > > 
> > > Speaking of this, I just tried to compile an official (Linus' git tree) 
> > > kernel for my old PMac G4 and I get a lot of section mismatch warnings at 
> > > the end of the compilation:
> > > 
> > > WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference to .init.text:early_get_page from .text between 'pte_alloc_one_kernel' (at offset 0xf50) and 'v_mapped_by_bats'
> > > 
> > > I find these 50 or so warnings so scary that I've not yet tried 
> > > to boot the kernel. Note that this is a non-modular kernel.
> > 
> > I'm getting oodles of these on an older -mm2 tree. The kernels seem to
> > work fine. Yes, they should be fixed but I'm up to my proverbial eyballs
> > in alligators.
> 
> Yeah, I see all kinds of this too.  Does anyone have an idea why they're
> being spit out?  Or if it's related to a particular binutils version,
> etc?

These warnings are showed by scripts/mod/modposts.c. 
It checks section mismatch stricter than before.

Some of them are not defined as __init even if it's called at just
boottime. This is simple to fix.

Second case is that the functions judge which functions
should call (boottime or normal) by themselves.
pte_alloc_one_kernel() looks its case.
In this case, they must be registered in whitelist of modpost.c

Other possibility is they are just rare called functions.
It should be investigated....

Bye.

-- 
Yasunori Goto 


