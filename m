Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0BVRWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:22:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45233 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab0BVRWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:22:03 -0500
Date: Mon, 22 Feb 2010 18:21:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, sliakh.lkml@gmail.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
       jiang@cs.ncsu.edu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
Message-ID: <20100222172153.GA28638@elte.hu>
References: <817ecb6f1001311527w7914ab20sf15b800dcaa37df7@mail.gmail.com>
 <tip-01ab31371da90a795b774d87edf2c21bb3a64dda@git.kernel.org>
 <20100222105457.GA31148@elte.hu>
 <20100222110106.GA7206@elte.hu>
 <4B82BCB0.9060903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B82BCB0.9060903@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 02/22/2010 03:01 AM, Ingo Molnar wrote:
> >>
> >>> Commit-ID:  01ab31371da90a795b774d87edf2c21bb3a64dda
> >>> Gitweb:     http://git.kernel.org/tip/01ab31371da90a795b774d87edf2c21bb3a64dda
> >>> Author:     Siarhei Liakh <sliakh.lkml@gmail.com>
> >>> AuthorDate: Sun, 31 Jan 2010 18:27:55 -0500
> >>> Committer:  H. Peter Anvin <hpa@zytor.com>
> >>> CommitDate: Wed, 17 Feb 2010 10:11:24 -0800
> >>>
> >>> x86, mm: NX protection for kernel data
> >>>
> >>> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
> >>> (static) kernel data area as NX.
> >>
> >> -tip testing is seeing boot hangs along the lines of:
> >>
> >> [   15.568108] EXT3-fs (sda1): recovery complete
> >> [   15.573064] EXT3-fs (sda1): mounted filesystem with ordered data mode
> >> [   15.580313] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
> >> [   15.584021] async_waiting @ 1
> >> [   15.588008] async_continuing @ 1 after 0 usec
> >> [   15.592163] Freeing unused kernel memory: 540k freed
> >> [   15.600126] NX-protecting the kernel data: c15ab000, 2919 pages
> >>
> >> which i suspect could be due to the commit above.
> > 
> > Yep, that's confirmed now, applying these 3 reverts makes it boot fine:
> > 
> > 833e0ca: Revert "x86, mm: NX protection for kernel data"
> > ce4b6b4: Revert "x86: RO/NX protection for loadable kernel modules"
> > e357312: Revert "module: fix () used as prototype in include/linux/module.h"
> > 
> 
> Given that e357312 is a () -> (void) prototype fix, is hardly seems
> likely to be at fault.  The RO/NX stuff, on the other hand, make a lot
> of sense.

Yes, i reverted e357312 because it was a dependent change.

Thanks,

	Ingo
