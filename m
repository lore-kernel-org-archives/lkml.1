Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881Ab0AYGn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0AYGn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 01:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566Ab0AYGn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 01:43:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59147 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0AYGn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 01:43:56 -0500
Message-ID: <4B5D3D37.4090107@cn.fujitsu.com>
Date: Mon, 25 Jan 2010 14:41:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH 06/10] ftrace: Release the function hlist if we don't
 need it anymore
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-7-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1264122982-1553-7-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> After we disable the function profiler, the function hashlist
> stays in memory. This is wasteful as nobody needs it anymore,
> until the next use if any.
> 
> Release it when we disable the function profiler instead of
> resetting it in the next use.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/trace/ftrace.c          |    1 +
>  kernel/trace/functions_hlist.c |   61 +++++++++++++++++-----------------------
>  kernel/trace/functions_hlist.h |    1 +
>  3 files changed, 28 insertions(+), 35 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index dfd8f7c..0ded01c 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -509,6 +509,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,

>			/*
>			 * unregister_ftrace_profiler calls stop_machine
>			 * so this acts like an synchronize_sched.
>			 */
>  			unregister_ftrace_profiler();

unluckily, when !CONFIG_DYNAMIC_FTRACE, it does not call stop_machine()
nor synchronize_sched(), bug here?

> +			function_hlist_release();


