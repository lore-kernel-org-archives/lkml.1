Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYFSPCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYFSPCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbYFSPCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:02:17 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45491 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750837AbYFSPCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:02:16 -0400
Date: Thu, 19 Jun 2008 10:02:09 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] - Increase MAX_APICS for very large x86_64 configs
Message-ID: <20080619150209.GA9295@sgi.com>
References: <20080616170910.GA24930@sgi.com> <20080619101030.GF15228@elte.hu> <20080619103242.GA13213@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619103242.GA13213@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 12:32:42PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > The patch has no effect on any 32-bit kernel. It adds ~4k to the 
> > > size of 64-bit kernels but only if NR_CPUS > 255.
> > > 
> > > This is a repost of an earlier patch (4/16) that was implicated in a 
> > > random-qa failure. I have not been able to reproduce the failure 
> > > using the same boot args & config.  Best guess is that some other 
> > > patch caused random data corruption & this patch was a victim.
> > 
> > i have just re-tested the previously failing config on tip/master:
> > 
> >   http://redhat.com/~mingo/misc/config-Thu_Apr_17_10_17_14_CEST_2008.bad
> >   http://people.redhat.com/mingo/tip.git/README
> > 
> > and the good news is that it does not crash on bootup anymore. Perhaps 
> > one of Mike's fixes/improvements did the trick?
> 
> unfortunately it didnt last long, -tip randconfig auto-testing found 
> that your patch causes a bootup crash:
> 

I built a "git-checkout -b tip-latest tip/auto-latest" tree but get compile errors.
Is this the right tree??


Have you seen this before:



In file included from arch/x86/mm/srat_64.c:13:
include/linux/acpi.h:97:1: warning: "NR_NODE_MEMBLKS" redefined
In file included from include/acpi/platform/aclinux.h:59,
                 from include/acpi/platform/acenv.h:140,
                 from include/acpi/acpi.h:54,
                 from include/linux/acpi.h:39,
                 from arch/x86/mm/srat_64.c:13:
include/asm/acpi.h:165:1: warning: this is the location of the previous definition
arch/x86/mm/srat_64.c:101: error: expected identifier or '(' before 'do'
arch/x86/mm/srat_64.c:101: error: expected identifier or '(' before 'while'
arch/x86/mm/srat_64.c:108: error: expected identifier or '(' before 'do'
arch/x86/mm/srat_64.c:108: error: expected identifier or '(' before 'while'
arch/x86/mm/srat_64.c:211: error: expected identifier or '(' before 'do'
arch/x86/mm/srat_64.c:211: error: expected identifier or '(' before 'while'

...


--- jack

