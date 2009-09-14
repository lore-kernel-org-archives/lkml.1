Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZINMLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZINMLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZINMLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:11:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51040 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbZINMLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:11:14 -0400
Subject: Re: [PATCH 3/3] tracing: Remove some unused macros
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AADF6E6.3080606@cn.fujitsu.com>
References: <4AADF60B.5070407@cn.fujitsu.com>
	 <4AADF6E6.3080606@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 14 Sep 2009 08:11:15 -0400
Message-Id: <1252930275.20020.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 15:55 +0800, Li Zefan wrote:
> - remove FTRACE_ENTRY_STRUCT_ONLY()
> - remove TRACE_XXX() macros
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_entries.h |    9 ---------
>  kernel/trace/trace_export.c  |   26 --------------------------
>  2 files changed, 0 insertions(+), 35 deletions(-)
> 
> diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
> index 0c10095..a431748 100644
> --- a/kernel/trace/trace_entries.h
> +++ b/kernel/trace/trace_entries.h
> @@ -116,15 +116,6 @@ FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
>  	__field(	unsigned char,	next_state	)	\
>  	__field(	unsigned int,	next_cpu	)
>  
> -#if 0
> -FTRACE_ENTRY_STRUCT_ONLY(ctx_switch_entry,
> -
> -	F_STRUCT(
> -		FTRACE_CTX_FIELDS
> -	)
> -);
> -#endif

Ug! Where's my paper bag.

Thanks Li! I'll pull them in later today.

-- Steve

> -
>  FTRACE_ENTRY(context_switch, ctx_switch_entry,
>  
>  	TRACE_CTX,
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index 26e52df..1c12979 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -209,32 +209,6 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
>  #undef __dynamic_array
>  #define __dynamic_array(type, item)
>  
> -
> -#undef TRACE_ZERO_CHAR
> -#define TRACE_ZERO_CHAR(arg)
> -
> -#undef TRACE_FIELD
> -#define TRACE_FIELD(type, item, assign)\
> -	entry->item = assign;
> -
> -#undef TRACE_FIELD
> -#define TRACE_FIELD(type, item, assign)\
> -	entry->item = assign;
> -
> -#undef TRACE_FIELD_SIGN
> -#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
> -	TRACE_FIELD(type, item, assign)
> -
> -#undef TP_CMD
> -#define TP_CMD(cmd...)	cmd
> -
> -#undef TRACE_ENTRY
> -#define TRACE_ENTRY	entry
> -
> -#undef TRACE_FIELD_SPECIAL
> -#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)	\
> -	cmd;
> -
>  #undef FTRACE_ENTRY
>  #define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
>  static int ftrace_raw_init_event_##call(void);				\

