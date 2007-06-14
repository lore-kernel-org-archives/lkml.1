Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXFNOiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXFNOiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbXFNOh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:37:56 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:57467 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXFNOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:37:56 -0400
Date: Thu, 14 Jun 2007 10:37:23 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] sched: fix SysRq-N (normalize RT tasks)
In-reply-to: <20070614135106.GA8325@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Message-id: <200706141037.23903.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070614094830.GA494@elte.hu>
 <200706140948.48005.gene.heskett@gmail.com> <20070614135106.GA8325@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> Ingo: I appended this patch to the cfs-v16 patch for 2.6.22-rc4, and
>> got this while applying it:
>>
>> patching file kernel/sched.c
>> Hunk #1 FAILED at 7071.
>> Hunk #2 FAILED at 7095.
>> 2 out of 2 hunks FAILED -- saving rejects to file kernel/sched.c.rej
>
>yep, this fix is already included in CFS. (in fact in CFS i also changed
>this function to renormalizing negative-nice tasks to nice-0 - but this
>is not something upstream has to pick up for .22.)
>
>	Ingo

I built it without it, but I saw something else that's been mentioned before 
here:

  MODPOST vmlinux
WARNING: arch/i386/kernel/built-in.o(.text+0x844d): Section mismatch: 
reference to .init.text:amd_init_mtrr (between 'mtrr_bp_init' 
and 'mtrr_save_state')
WARNING: arch/i386/kernel/built-in.o(.text+0x8452): Section mismatch: 
reference to .init.text:cyrix_init_mtrr (between 'mtrr_bp_init' 
and 'mtrr_save_state')
WARNING: arch/i386/kernel/built-in.o(.text+0x8457): Section mismatch: 
reference to .init.text:centaur_init_mtrr (between 'mtrr_bp_init' 
and 'mtrr_save_state')
WARNING: arch/i386/kernel/built-in.o(.text+0x9274): Section mismatch: 
reference to .init.text: (between 'get_mtrr_state' and 'generic_get_mtrr')
WARNING: arch/i386/kernel/built-in.o(.text+0x9288): Section mismatch: 
reference to .init.text: (between 'get_mtrr_state' and 'generic_get_mtrr')
WARNING: arch/i386/kernel/built-in.o(.text+0x92ac): Section mismatch: 
reference to .init.text: (between 'get_mtrr_state' and 'generic_get_mtrr')

Which looks a little worrisome.  Its done, so I'll see if it will boot.

It did.  I had several items that failed on the shutdown, NDI why, but 
everything seemed to restart ok.  Now to live with it for a day or so.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Netscape is not a newsreader, and probably never shall be.
	-- Tom Christiansen
