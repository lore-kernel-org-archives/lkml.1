Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbZAPBl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbZAPBl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZAPBlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:41:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbZAPBlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:41:16 -0500
Date: Thu, 15 Jan 2009 17:40:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: fix trace_output
Message-Id: <20090115174008.935e0391.akpm@linux-foundation.org>
In-Reply-To: <20090116004121.039250781@goodmis.org>
References: <20090116004050.273665842@goodmis.org>
	<20090116004121.039250781@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 19:40:51 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Impact: fix bug for handling partial line
> 
> trace_seq_printf(), seq_print_userip_objs(), ... return
> 0          -- partial line was written
> other(>0)  -- success
> 
> duplicate output is also removed in trace_print_raw().
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace_output.c |   65 ++++++++++++++++++++----------------------
>  kernel/trace/trace_output.h |    4 +-
>  2 files changed, 33 insertions(+), 36 deletions(-)
> 
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index df0c25c..4e3ad36 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -440,9 +440,9 @@ trace_fn_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
>  
>  	trace_assign_type(field, entry);
>  
> -	if (trace_seq_printf(s, "%x %x\n",
> -			     field->ip,
> -			     field->parent_ip))
> +	if (!trace_seq_printf(s, "%x %x\n",

"%lx %lx", surely?

If trace_seq_printf() had the attribute(printf) thing, it would have warned.


