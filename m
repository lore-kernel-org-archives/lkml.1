Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYFYHSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYFYHSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYFYHRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:17:54 -0400
Received: from www.tglx.de ([62.245.132.106]:34599 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbYFYHRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:17:54 -0400
Date: Wed, 25 Jun 2008 09:09:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: When did High-Resolution Timers hit mainline?
In-Reply-To: <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806250900240.3297@apollo.tec.linutronix.de>
References: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com> <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008, Michael Kerrisk wrote:
>    High-Resolution Timers
>        Before  Linux  2.6.16,  the  accuracy of timer and sleep system
>        calls (see below) was also limited by the size of the jiffy.
> 
>        Since  Linux  2.6.16,  Linux  supports  high-resolution  timers
>        (HRTs),  optionally  configurable  since kernel 2.6.21 via CON-
>        FIG_HIGH_RES_TIMERS.  On a system that supports HRTs, the accu-
>        racy  of  sleep and timer system calls is no longer constrained
>        by the jiffy, but instead can be as accurate  as  the  hardware
>        allows (microsecond accuracy is typical of modern hardware).

Hmm, that's a bit backwards. We changed the internal handling of those
interfaces to hrtimers in 2.6.16, but the accuracy is still jiffies
unless you have CONFIG_HIGH_RES_TIMERS enabled (which is only possible
as of 2.6.21) and your system provides the necessary hardware.
 
>        HRTs are not supported on all hardware architectures.  (Support
>        is provided on x86, arm, and powerpc, among others.)

Also you might point out that you can check whether high resolution
timers are active via clock_getres() or by checking the resolution
entry in /proc/timer_list.

Thanks,

	tglx

