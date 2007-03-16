Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbXCPS0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbXCPS0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXCPS0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:26:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45577 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbXCPS0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:26:08 -0400
Subject: Re: [PATCH] Add an offset in the cyc2ns computation to fix
	sched_clock jumps
From: john stultz <johnstul@us.ibm.com>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Andi Kleen <ak@suse.de>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
In-Reply-To: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
References: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 11:26:05 -0700
Message-Id: <1174069565.22201.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 19:14 +0100, Guillaume Chazarain wrote:
> Hello,
> 
> The scheduling problems I reported in the thread:
> http://lkml.org/lkml/2007/3/3/128
> are caused by the set_cyc2ns_scale() function called when the CPU speed changes.
> Changing the scale causes a warp in the value returned by sched_clock().
> 
> The attached patch fixes the problem by adding an offset to the cyc2ns code to
> smooth CPU frequency transitions. It also makes the cyc2ns parameters
> per-CPU as cpufreq seems to support SMP but I don't have the hardware
> to test. If you want
> a version without the per-CPU or irqsave stuff, just ask.

Oh great! This has been a long standing issue I've never managed to get
around to and your approach to fixing it is simpler then what I was
thinking it would take.

Thanks for knocking this off!

> Although it solved all my scheduler issues, it may not be fully satisfactory
> as for example my TSC can run at a frequency as low as 350 MHz when the CPU is
> idle and slowed down to the max at 798 MHz by ondemand. So in this case,
> sched_clock() does not return nanoseconds as it thinks it does. Hopefully this
> is a non-issue as the scheduler is not stressed when the CPU is idle.

Hmm.. It drops to 350MHz on idle, but only ~800Mhz by on-demand? That
sounds more like the C3 idle TSC halt issue.

> For me, this is needed in 2.6.21 if I want to be able to listen to music while
> compiling a kernel using the ondemand governor.
> 
> Thanks.
> 
> Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>

Acked-by: John Stultz <johnstul@us.ibm.com>

