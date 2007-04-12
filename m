Return-Path: <linux-kernel-owner+w=401wt.eu-S2992572AbXDLP2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992572AbXDLP2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992573AbXDLP2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:28:20 -0400
Received: from smtp-out19.alice.it ([85.33.2.19]:4915 "EHLO
	smtp-out19.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992572AbXDLP2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:28:18 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 11:28:18 EDT
Date: Thu, 12 Apr 2007 17:14:02 +0200
From: Mattia Dongili <malattia@linux.it>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070412151402.GA3216@inferi.kami.home>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc6-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 12 Apr 2007 15:14:03.0618 (UTC) FILETIME=[34C0BC20:01C77D15]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 07:50:11PM -0700, Linus Torvalds wrote:
...
> Maxim Levitsky (1):
>       Add suspend/resume for HPET

This one breaks resume for me (from STR) on a vaio SZ. Reverting this
commit allows resuming again but leaves me with some periodic and unpleasant:

[  155.232000] BUG: soft lockup detected on CPU#1!
[  155.232000]  [<c0104cf2>] show_trace_log_lvl+0x1a/0x2f
[  155.232000]  [<c0105344>] show_trace+0x12/0x14
[  155.232000]  [<c01053c8>] dump_stack+0x16/0x18
[  155.232000]  [<c0147240>] softlockup_tick+0xa7/0xb6
[  155.232000]  [<c01284d3>] run_local_timers+0x12/0x14
[  155.232000]  [<c012887a>] update_process_times+0x3e/0x63
[  155.232000]  [<c0137656>] tick_sched_timer+0x50/0x95
[  155.232000]  [<c01340e0>] hrtimer_interrupt+0x10b/0x18b
[  155.232000]  [<c01137b7>] smp_apic_timer_interrupt+0x6c/0x7e
[  155.232000]  [<c0104840>] apic_timer_interrupt+0x28/0x30
[  155.232000]  [<c0102318>] cpu_idle+0x1b/0xc7
[  155.232000]  [<c011297a>] start_secondary+0x32b/0x333
[  155.232000]  [<00000000>] run_init_process+0x3fefed10/0x19
[  155.232000]  =======================

FWIW: I hit the same BUG() in -rc5.
full boot+suspend+resume log: http://oioio.altervista.org/linux/kern-2.6.21-rc6.log
.config: http://oioio.altervista.org/linux/config-2.6.21-rc6-1

I'm available to test more patches or to provide other info.
-- 
mattia
:wq!
