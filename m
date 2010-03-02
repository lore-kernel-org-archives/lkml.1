Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0CBOdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:33:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0CBOds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:33:48 -0500
X-Authority-Analysis: v=1.0 c=1 a=2G6vFbrScLIA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=rKPCixGL3i7CWmDxaKYA:9 a=VJ1U209am30waqlppFuIRM_tXl4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: fix warning in s_next
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B8CE06A.9090207@cn.fujitsu.com>
References: <4B8CE06A.9090207@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 02 Mar 2010 09:33:43 -0500
Message-ID: <1267540423.10871.20.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 17:54 +0800, Lai Jiangshan wrote:
> This warning in s_next() can be triggered by lseek():
>  [<c018b3f7>] ? s_next+0x77/0x80
>  [<c013e3c1>] warn_slowpath_common+0x81/0xa0
>  [<c018b3f7>] ? s_next+0x77/0x80
>  [<c013e3fa>] warn_slowpath_null+0x1a/0x20
>  [<c018b3f7>] s_next+0x77/0x80
>  [<c01efa77>] traverse+0x117/0x200
>  [<c01eff13>] seq_lseek+0xa3/0x120
>  [<c01efe70>] ? seq_lseek+0x0/0x120
>  [<c01d7081>] vfs_llseek+0x41/0x50
>  [<c01d8116>] sys_llseek+0x66/0xa0
>  [<c0102bd0>] sysenter_do_call+0x12/0x26
> 
> It is because s_start() calls s_next() without reset leftover.

Applied, Thanks!

-- Steve

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 032c57c..5edf410 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1703,6 +1703,7 @@ static void *s_start(struct seq_file *m, loff_t *pos)
>  
>  		ftrace_enable_cpu();
>  
> +		iter->leftover = 0;
>  		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
>  			;
>  


