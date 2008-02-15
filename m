Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbYBOXR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbYBOXR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYBOXRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:17:49 -0500
Received: from waste.org ([66.93.16.53]:60438 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYBOXRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:17:48 -0500
Subject: Re: arch/x86/mm/ioremap unification grew by 10x
From: Matt Mackall <mpm@selenic.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>
In-Reply-To: <1203110488.12383.231.camel@cinder.waste.org>
References: <1203107155.12383.230.camel@cinder.waste.org>
	 <20080215203228.GA4295@uranus.ravnborg.org>
	 <1203110488.12383.231.camel@cinder.waste.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 17:17:05 -0600
Message-Id: <1203117425.12383.238.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 15:21 -0600, Matt Mackall wrote:
> On Fri, 2008-02-15 at 21:32 +0100, Sam Ravnborg wrote:
> > On Fri, Feb 15, 2008 at 02:25:54PM -0600, Matt Mackall wrote:
> > > In 2.6.24 defconfig, my build stats show ioremap_32.o was 1.8k. In
> > > 2.6.25-rc1, the unified ioremap.o is 20.8k.
> > 
> > Just an observation - 17 commits touches said file after
> > the unification (at least in latest -linus).
> 
> Correction: those numbers should be halved. So we're going from .9k to
> 10.4k.

And here's most of the cause:

000002b8 00000124 T early_ioremap
00001000 00001000 t bm_pte
00002000 00000004 T early_ioremap_debug

static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
				__attribute__((aligned(PAGE_SIZE)));

Double ouch. First, this isn't in BSS. Second, even though it's
initdata, the alignment slop won't get recovered.

Don't we have a special section for page-aligned crap so it doesn't
waste most of two pages?

-- 
Mathematics is the supreme nostalgia of our time.

