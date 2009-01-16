Return-Path: <linux-kernel-owner+w=401wt.eu-S937361AbZAPTQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937361AbZAPTQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbZAPTP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:15:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZAPTP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:15:58 -0500
Date: Fri, 16 Jan 2009 14:15:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] ftrace interface for blktrace
In-Reply-To: <20090116181611.GE6562@ghostprotocols.net>
Message-ID: <alpine.DEB.1.10.0901161414190.22303@gandalf.stny.rr.com>
References: <20090116181611.GE6562@ghostprotocols.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnaldo,

Cool stuff!

On Fri, 16 Jan 2009, Arnaldo Carvalho de Melo wrote:

> Hi Jens,
> 
> 	The patch below adds a ftrace interface for blktrace, allowing
> people to use it without any required userspace tools, using sysfs to setup the
> act_mask, pid, start_lba, end_lba.
> 
> 	Example usage:
> 
> [root@f10-1 ~]# mount -t debugfs none /sys/kernel/debug/

I think you are the only person that mounts debugfs on the "official"
location ;-)

> [root@f10-1 ~]# ls /sys/block/sda/sda1/trace/
> act_mask  enable  end_lba  pid  start_lba
> [root@f10-1 ~]# cat /sys/kernel/debug/tracing/available_tracers 
> blk function_graph wakeup function sched_switch nop
> [root@f10-1 ~]# echo blk > /sys/kernel/debug/tracing/current_tracer 

You must like to type.

-- Steve

> [root@f10-1 ~]# cat /sys/kernel/debug/tracing/trace
> # tracer: blk
> #
> # DEV   CPU TIMESTAMP     PID ACT FLG
> #  |     |     |           |   |   |
> [root@f10-1 ~]# echo 1 > /sys/block/sda/sda1/trace/enable 
> [root@f10-1 ~]# tail /sys/kernel/debug/tracing/trace
>   8,1    0   143.070085  1208  P  NS [tail]
>   8,1    0   143.070087  1208  I RBS 4154375 + 8 [tail]
>   8,1    0   143.070091  1208  A WBS 4155391 + 16 <- (8,1) 4155328
>   8,1    0   143.070091  1208  Q   R 4155391 + 16 [tail]
>   8,1    0   143.070094  1208  G  RB 4155391 + 16 [tail]
>   8,1    0   143.070094  1208  I RBS 4155391 + 16 [tail]
>   8,1    0   143.070097  1208  U  WS [tail] 2
>   8,1    0   143.070101  1208  D  WB 4154375 + 8 [tail]
>   8,1    0   143.070341  1208  D  WB 4155391 + 16 [tail]
>   8,1    0   143.070635     0  C  RS 4154375 + 8 [0]
> [root@f10-1 ~]#
> 
