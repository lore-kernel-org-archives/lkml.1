Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbYEGTIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbYEGTIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761554AbYEGTHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:07:22 -0400
Received: from www.tglx.de ([62.245.132.106]:39598 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759340AbYEGTHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:07:19 -0400
Date: Wed, 7 May 2008 21:06:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mirco Tischler <mt-ml@gmx.de>
cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG]:WARNING: at arch/x86/kernel/rtc.c:122 in 2.6.26-rc1
In-Reply-To: <1210183536.28099.10.camel@mtlp.tischlernetz>
Message-ID: <alpine.LFD.1.10.0805072102010.3318@apollo.tec.linutronix.de>
References: <1210183536.28099.10.camel@mtlp.tischlernetz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Mirco Tischler wrote:
> Hello
> I've triggered this warning in 2.6.26-rc1-git from 6th of may:
> ...
> [11677.490019] CPU1 is down
> [11677.490149] Extended CMOS year: 2000
> [11677.490149] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> 0x7010600070106
> [11677.490747] Back to C!
> [11677.490952] microcode: CPU0 updated from revision 0x92 to 0x92, date
> = 03132007 
> [11677.491065] ------------[ cut here ]------------
> [11677.491065] WARNING: at arch/x86/kernel/rtc.c:122 mach_get_cmos_time
> +0x9e/0x14e()

> [11677.491065]  [<ffffffff80211cdb>] mach_get_cmos_time+0x9e/0x14e
> [11677.491065]  [<ffffffff80211da6>] read_persistent_clock+0x1b/0x35
> [11677.491065]  [<ffffffff8024c101>] timekeeping_resume+0xb/0x120

Interesting. That's in the resume path.

> I wasn't able to reproduce the warning yet, but because the commit
> message introducing the WARN_ON says:

This is a WARN_ON_ONCE so you only see it once per boot. Resume does
not count :) You might change that WARN_ON_ONCE to WARN_ON to check
whether it happens more than once.

> > [ tglx@linutronix.de: changed to WARN_ON - we want to know that!
> >       If no one reports it we can remove the complete if (RTC_ALWAYS_BCD)
> >       magic, which has RTC_ALWAYS_BCD defined to 1 since Linux 1.0 ... ]
> I'm reporting it anyway now.

Thanks. That's why I put the WARN_ON there. The backtrace attracts
attention and it's also an interesting info that this did not happen
on boot, where we read out the RTC as well.

Can you please provide some details about the system ?

Thanks,
	tglx
