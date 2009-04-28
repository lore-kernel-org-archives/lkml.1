Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZD1Vxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZD1Vxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbZD1Vxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:53:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:32722 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbZD1Vxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w7EhSdnxiAKWxkdndxE9fQEJo3TbzSqIea2da0aKBqW3Ly1ZRi9Ak8vNeFnCXNxbPt
         kImRGXwuvDU3Glx2RLZBZ6kAqmu9uDcudSfjtls3QFfIuvT7usgbXMRyqYObud/Wqwuv
         2iLJRLgVlmu/2uFD+c1S9/CKO4Uqf4qYS2VeU=
Date: Tue, 28 Apr 2009 23:53:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] workqueue_trace: Add max execution time mesurement
	for per worklet
Message-ID: <20090428215335.GF7337@nowhere>
References: <49F6DFB5.2040901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F6DFB5.2040901@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 06:51:33PM +0800, Zhaolei wrote:
> Hi,
> 
> This patch add max execution time mesurement for per worklet.
> It is useful for driver-developer and system administrator to
> know which worklet runs how many time.
> 
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
>  ...
> 
> Thanks
> Zhaolei
> 

Thanks Zhaolei,

I've applied this series and the previous one to
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
 tracing/workqueue

