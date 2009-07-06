Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbZGFIZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbZGFIZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZGFIYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:24:52 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57423 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbZGFIYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:24:50 -0400
Subject: Re: [PATCH] kmemtrace: rename some functions
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A51B288.70505@cn.fujitsu.com>
References: <4A51B288.70505@cn.fujitsu.com>
Date: Mon, 06 Jul 2009 11:24:52 +0300
Message-Id: <1246868692.4957.12.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 16:15 +0800, Li Zefan wrote:
> So we have:
> - kmemtrace_print_alloc/free() for kmemtrace default output
> - kmemtrace_print_alloc/free_user() for binary output used
>   by kmemtrace-user.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I think this is what you suggested Eduard?

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
> 
> forgot to CC LKML...again..
> 
> ---
>  kernel/trace/kmemtrace.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
> index 74903b6..256827b 100644
> --- a/kernel/trace/kmemtrace.c
> +++ b/kernel/trace/kmemtrace.c
> @@ -239,7 +239,7 @@ struct kmemtrace_user_event_alloc {
>  };
>  
>  static enum print_line_t
> -kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
> +kmemtrace_print_alloc(struct trace_iterator *iter, int flags)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	struct kmemtrace_alloc_entry *entry;
> @@ -259,7 +259,7 @@ kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
>  }
>  
>  static enum print_line_t
> -kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
> +kmemtrace_print_free(struct trace_iterator *iter, int flags)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	struct kmemtrace_free_entry *entry;
> @@ -277,7 +277,7 @@ kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
>  }
>  
>  static enum print_line_t
> -kmemtrace_print_alloc_user_bin(struct trace_iterator *iter, int flags)
> +kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	struct kmemtrace_alloc_entry *entry;
> @@ -311,7 +311,7 @@ kmemtrace_print_alloc_user_bin(struct trace_iterator *iter, int flags)
>  }
>  
>  static enum print_line_t
> -kmemtrace_print_free_user_bin(struct trace_iterator *iter, int flags)
> +kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	struct kmemtrace_free_entry *entry;
> @@ -482,14 +482,14 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
>  
>  static struct trace_event kmem_trace_alloc = {
>  	.type			= TRACE_KMEM_ALLOC,
> -	.trace			= kmemtrace_print_alloc_user,
> -	.binary			= kmemtrace_print_alloc_user_bin,
> +	.trace			= kmemtrace_print_alloc,
> +	.binary			= kmemtrace_print_alloc_user,
>  };
>  
>  static struct trace_event kmem_trace_free = {
>  	.type			= TRACE_KMEM_FREE,
> -	.trace			= kmemtrace_print_free_user,
> -	.binary			= kmemtrace_print_free_user_bin,
> +	.trace			= kmemtrace_print_free,
> +	.binary			= kmemtrace_print_free_user,
>  };
>  
>  static struct tracer kmem_tracer __read_mostly = {

