Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZFJK7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZFJK7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZFJK67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:58:59 -0400
Received: from www.tglx.de ([62.245.132.106]:40386 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbZFJK66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:58:58 -0400
Date: Wed, 10 Jun 2009 12:58:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] ftrace: add tracepoint for timer
In-Reply-To: <4A2F8006.506@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0906101225280.3351@localhost.localdomain>
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com> <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain> <4A1F41C5.7000803@cn.fujitsu.com>
 <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain> <4A25E575.5000601@cn.fujitsu.com> <alpine.LFD.2.00.0906031756590.3419@localhost.localdomain> <4A275DDC.6020507@cn.fujitsu.com> <alpine.LFD.2.00.0906041017220.3419@localhost.localdomain>
 <4A2F8006.506@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao,

On Wed, 10 Jun 2009, Xiao Guangrong wrote:
> Those tracepoints are wanted and useful:
> 1) We can detect a timer's delay if jiffies info is added, like this:
> 
> 	XXX: timer_start: timer=e0b374e0 func=test_timerfuc expires=4294941565
> 	XXX: timer_expire: timer=e0b374e0 func=test_timerfuc jiffies=4294941567
>    We expect the timer expires at 4294941565, actually the timer expires at
>    4294941567, so it is delayed by 2 jiffies.

You can achive the same thing by storing (expires - jiffies) when you
trace the timer start. Then you can calc the delta from the trace
timestamps, but I have no strong opinion about that.

> 2) We can monitor the lifecycle and behaviors of a timer, for
>    example, when monitoring dirty writeback timer, I found reading
>    /proc/sys/vm/dirty_writeback_centisecs will reset the timer:

 
> 3) We are developing "flight-record" using crash. It can read out the ring
>    buffer from the dump file, and let us know what was happening before
>    kernel panic, so we may find the cause of the panic. This requires
>    well-defined tracepoints in different kernel subsystems, especially some
>    core subsystems, timer is surely one of them.

I'm not arguing that tracepoints are not useful, but you can achieve
all the things above by combining them in an unintrusive way to the
existing debug points.

This results in the minimum noise of debug/trace insertions into the
code, which keeps it readable and maintainable. That's all I want.

Thanks,

	tglx
