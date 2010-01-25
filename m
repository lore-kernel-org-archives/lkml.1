Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710Ab0AYIwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0AYIwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 03:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928Ab0AYIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 03:52:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57627 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0AYIwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 03:52:43 -0500
Message-ID: <4B5D5B68.6020806@cn.fujitsu.com>
Date: Mon, 25 Jan 2010 16:50:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH 09/10] tracing: Use the hashlist for graph function
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-10-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1264122982-1553-10-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> When we set a filter to start tracing from a given function in
> the function graph tracer, the filter is stored in a linear array.
> 
> It doesn't scale very well, we even limited the number of such
> functions to 32.
> 
> Now that we have a hashlist of functions, lets put a field inside
> each function node so that we can check if a function is one of
> these filters using the hashlist, not a linear array.

The linear array @ftrace_graph_funcs is still used in this patch.
we still limit the number of such functions to 32?

[...]
>  #define FTRACE_GRAPH_MAX_FUNCS		32
>  extern int ftrace_graph_count;
>  extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
> -
> -static inline int ftrace_graph_addr(unsigned long addr)
> -{
> -	int i;
> -
> -	if (!ftrace_graph_count)
> -		return 1;

Here return 1.

[...]
> +static inline int ftrace_graph_addr(unsigned long addr)
> +{
> +	struct func_node *rec;
> +	struct func_hlist *hlist;
> +
> +	if (!ftrace_graph_count)
> +		return 0;
> +

But in this patch, return 0 here, the behave will be changed.
