Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZD2HMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZD2HMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZD2HMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:12:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbZD2HMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:12:35 -0400
Date: Wed, 29 Apr 2009 00:06:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] workqueue_trace: Add max execution time mesurement
 for per worklet
Message-Id: <20090429000616.f7e72b73.akpm@linux-foundation.org>
In-Reply-To: <49F6DFB5.2040901@cn.fujitsu.com>
References: <49F6DFB5.2040901@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 18:51:33 +0800 Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> Hi,
> 
> This patch add max execution time mesurement for per worklet.
> It is useful for driver-developer and system administrator to
> know which worklet runs how many time.

This seems more useful than the previous feature.

> It need applied on top of patchset of:
> workqueue_tracepoint: Add worklet tracepoints for worklet lifecycle tracing
> 
> Output is like:
>  # CPU INSERTED EXECUTED M_EXECus TASKNAME:PID
>  #  |     |        |        |      `-WORKFUNC
>  #  |     |        |        |        |
>      0      905      973          events/0:5
>      0        1        1       37  |-reg_todo+0x0/0x41f
>      0       13       12     2033  |-rt_worker_func+0x0/0x219
>      0       49       48     3157  |-mce_work_fn+0x0/0x31
>      0       14       13      939  |-check_corruption+0x0/0x2a
>      0      707      706     3826  |-vmstat_update+0x0/0x33
>      0        1        1     1846  |-power_supply_changed_work+0x0/0x3c
>      0       11       11     2879  |-console_callback+0x0/0xe1
>      0       30       29     1579  |-do_cache_clean+0x0/0x37
>      0       74       74     2841  |-test_work+0x0/0x53
>      0        3        2      252  |-rekey_seq_generator+0x0/0x5a
>      0        1        1       21  |-grace_ender+0x0/0x14
>      0        1        1     3701  `-flush_to_ldisc+0x0/0x15d
>      0        0        0          cpuset:6
>      0      658      658          khelper:7
>      0      658      658     5735  `-__call_usermodehelper+0x0/0x77
>      0        0        0          netns:11

What is the meaning of M_EXECus?  Mean execution time in microseconds,
I assume?  I wonder if that is sufficiently high resolution nowadays.

You'll note that all the functions are reported as "foo+0x0/0xN". 
There is a way of suppressing the unneeded and unuseful "+0x0/0xN",
but I forget what it is and the comments over lib/vsprintf.c:pointer()
didn't help.  I think it's %pS.

The patchset adds no user documentation for the feature and should not
(IMO) be merged in such a state.  Please.

