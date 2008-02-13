Return-Path: <linux-kernel-owner+w=401wt.eu-S935419AbYBMWA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935419AbYBMWA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933873AbYBMVkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:40:11 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:26071 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932789AbYBMVkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:40:08 -0500
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [stable 2.6.24] WARNING: at kernel/time/clockevents.c
Date: Wed, 13 Feb 2008 22:40:03 +0100
User-Agent: KMail/1.9.7
References: <200802101440.22118.elendil@planet.nl> <200802130947.10781.elendil@planet.nl> <alpine.LFD.1.00.0802131004460.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802131004460.12988@apollo.tec.linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132240.04357.elendil@planet.nl>
X-OriginalArrivalTime: 13 Feb 2008 21:40:04.0751 (UTC) FILETIME=[FEAE69F0:01C86E88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Thomas Gleixner wrote:
> can you please apply the following patch ? I really should have
> thought about that, when I fixed the above one.

I still get the bug with this patch. At least I'm now certain it happens 
during glibc compilation and that I can reproduce it.

I applied your patch on top of 2.6.24.2 (applied with only minor offsets) 
because I also saw the issue with that kernel and I don't yet completely 
trust 2.6.25.

Here's the error from this run:
WARNING: at kernel/time/clockevents.c:82 clockevents_program_event()
Pid: 27638, comm: ld-linux.so.2 Not tainted 2.6.24.2-test1 #39

Call Trace:
 [<ffffffff8024afaf>] ktime_get+0xc/0x41
 [<ffffffff8024ea59>] clockevents_program_event+0x3b/0x94
 [<ffffffff8024f8c8>] tick_program_event+0x31/0x4d
 [<ffffffff8024a2fd>] hrtimer_reprogram+0x3b/0x51
 [<ffffffff8024a478>] enqueue_hrtimer+0x66/0x102
 [<ffffffff8024ad38>] hrtimer_start+0x102/0x125
 [<ffffffff8819f403>] :ext3:__ext3_journal_stop+0x1f/0x3d
 [<ffffffff803f8dcc>] rt_mutex_slowlock+0x90/0x53a
 [<ffffffff802667e8>] find_lock_page+0x29/0x8d
 [<ffffffff80277a78>] find_extend_vma+0x16/0x59
 [<ffffffff802509b2>] get_futex_key+0x82/0x14e
 [<ffffffff80251ac5>] futex_lock_pi+0x60f/0x90d
 [<ffffffff8024a70d>] hrtimer_wakeup+0x0/0x21
 [<ffffffff803f8dcc>] rt_mutex_slowlock+0x90/0x53a
 [<ffffffff802527cb>] do_futex+0xa08/0xa3d
 [<ffffffff803f9c59>] error_exit+0x0/0x51
 [<ffffffff80252d48>] compat_sys_futex+0xf0/0x10e
 [<ffffffff8020a6f1>] __switch_to+0x10e/0x27e
 [<ffffffff80231889>] schedule_tail+0x23/0x60
 [<ffffffff80223972>] ia32_sysret+0x0/0xa

Cheers,
FJP
