Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbZIPTeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbZIPTeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZIPTdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:33:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZIPTdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:33:54 -0400
Subject: Re: [PATCH v2 1/2] ftrace: add tracepoint for xtime
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <4AB0774C.5050706@cn.fujitsu.com>
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com>
	 <4A89213C.5090109@cn.fujitsu.com>
	 <20090818215620.A63C.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>
	 <4A939CDF.2000407@cn.fujitsu.com> <4AB076DE.10604@cn.fujitsu.com>
	 <4AB0774C.5050706@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 16 Sep 2009 15:33:56 -0400
Message-Id: <1253129636.20020.213.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 13:27 +0800, Zhaolei wrote:
> From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> This patch can trace current xtime and wall_to_monotonic. Then user can
> use ctime() to convert them to wall time which is easier to be understood,
> especially for flight-recorder which need to get trace event from a kernel
> dump file.
> 
> Example of ftrace output:
>           <idle>-0     [000] 20118.489849: gtod_update_xtime: xtime=1243265589.999999824 wall_to_monotonic=3051713268.744158739
>            <...>-4020  [001] 20118.489855: sys_open(filename: bf9e66e0, flags: 98800, mode: bf9e66e0)
>            <...>-4020  [001] 20118.489873: sys_open -> 0xffffffec
> 
> ctime(1243265590) = date:Mon May 25 11:33:10 2009
> So we can realize the task with pid 4020 open a file at
> Mon May 25 11:33:10 2009
> 
> Changelog:
> v1->v2: Rebased by Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  include/trace/events/xtime.h |   38 ++++++++++++++++++++++++++++++++++++++
>  kernel/time/ntp.c            |    4 ++++
>  kernel/time/timekeeping.c    |    6 ++++++

This patch will need an ACK from Thomas Gleixner and/or John Stultz.

-- Steve


