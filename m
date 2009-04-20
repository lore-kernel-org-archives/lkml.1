Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZDTHXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZDTHXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZDTHXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:23:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47871 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZDTHXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QGbSyPZrrsMKvizN/VQZC+zc+8BtMvjGS0++yu5LPJfN702f9F6TJAGlo6nzx8CwYs
         /1PSlIwF/81YjvzWjrEUjuzDsE8H/tTg7seugWZYSMVQn8NTBFwTM5sYPlUedHzXx+mI
         6iP5kDXnqbSjr34GgvDjRtYNR11b5NPtd2U9c=
Date: Mon, 20 Apr 2009 09:23:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] ftrace, workqueuetrace: Add worklet informationame
Message-ID: <20090420072317.GA6081@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49EC1943.8080606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC1943.8080606@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 02:42:11PM +0800, Zhaolei wrote:
> Hello,
> 
> To make workqueuetrace support per-worklet's time mesurement(max execution,
> latecy), workqueue trace need to support per-worklet's stat information first.
> This patchset add them.
> 
> Before patch:
> # cat [debugfs]/tracing/trace_stat/workqueues
> # CPU  INSERTED  EXECUTED   NAME
> # |      |         |          |
> 
>   0    589        589       events/0
>   0      0          0       cpuset
>   0    656        656       khelper
>   0      0          0       netns
>   0    809        809       kblockd/0
>   0      0          0       kacpid
>   0      0          0       kacpi_notify
>   0      0          0       ata/0
>   0      0          0       ata_aux
>   0      0          0       ksuspend_usbd
>   0      0          0       aio/0
>   0      0          0       nfsiod
>   0      0          0       crypto/0
>   0      0          0       kpsmoused
>   0      0          0       kstriped
>   0      0          0       kondemand/0
>   0      0          0       usbhid_resumer
>   0     21         21       rpciod/0
> 
> After patch:
> # cat [debugfs]/tracing/trace_stat/workqueues
> # CPU  INSERTED  EXECUTED   TASKNAME:PID
> # |      |         |        `-WORKFUNC
> # |      |         |          |
>   0    273        273       events/0:5
>   0      1          1        |-reg_todo+0x0/0x648
>   0      4          4        |-check_corruption+0x0/0x2c
>   0      1          1        |-power_supply_changed_work+0x0/0x3c
>   0      6          6        |-console_callback+0x0/0x145
>   0    229        229        |-vmstat_update+0x0/0x33
>   0     12         12        |-do_cache_clean+0x0/0x6a
>   0      1          1        |-wq_barrier_func+0x0/0x12
>   0     15         15        |-mce_work_fn+0x0/0x31
>   0      3          3        |-rt_worker_func+0x0/0x2de
>   0      1          1        `-grace_ender+0x0/0x14
>   0      0          0       cpuset:6
>   0    659        659       khelper:7
>   0    659        659        `-__call_usermodehelper+0x0/0xa0
>   0      0          0       netns:11
>   0   1818       1818       kblockd/0:13
>   0   1115       1115        |-blk_unplug_work+0x0/0x1e
>   0    703        703        `-cfq_kick_queue+0x0/0x2f
>   0      0          0       kacpid:412
>   0      0          0       kacpi_notify:415
>   0      0          0       ata/0:463
>   0      0          0       ata_aux:509
>   0      0          0       ksuspend_usbd:515
>   0      0          0       aio/0:717
>   0      0          0       nfsiod:764
>   0      0          0       crypto/0:785
>   0      0          0       kpsmoused:1141
>   0      0          0       kstriped:1248
>   0      0          0       kondemand/0:1259
>   0      0          0       usbhid_resumer:1264
>   0     20         20       rpciod/0:1333
>   0      1          1        |-xs_tcp_connect_worker4+0x0/0x1b
>   0     19         19        `-xs_udp_connect_worker4+0x0/0x130



Oh, Nice!
This is an interesting view of worklets percentage/frequency of execution.
We could also have a file per workqueue, but anyway it seems to me a very good
first step!


> 
> After this step, we'll begin to add worklet time mesurement support to
> workqueuetrace.


Great!
Thanks.


> Thanks
> Zhaolei
> 

