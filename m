Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbZHSBJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbZHSBJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZHSBJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:09:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:23193 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZHSBJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:09:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Rq7I6jVHZkeXFkPuu6vUa3POYgSjBbnibrOeOP1BUZXpi72K0KIkh2Gmqa5hALq4EX
         +adllEQbJ0jszHQnNF2PXmathpktywW3CatTGTlii/OQozs3O3I92mKp5lFSjh9QLYqp
         y4TxwXeNrzm5lG+lvH5L2DZAZ0dZHJ/aWf1Ko=
Date: Wed, 19 Aug 2009 03:09:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip v14 07/12] tracing: Introduce TRACE_FIELD_ZERO()
	macro
Message-ID: <20090819010903.GI5231@nowhere>
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <20090813203501.31965.30172.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090813203501.31965.30172.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 04:35:01PM -0400, Masami Hiramatsu wrote:
> Use TRACE_FIELD_ZERO(type, item) instead of TRACE_FIELD_ZERO_CHAR(item).
> This also includes a fix of TRACE_ZERO_CHAR() macro.


I can't find what the fix is about (see below)



> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: K.Prasad <prasad@linux.vnet.ibm.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
> Cc: Roland McGrath <roland@redhat.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> ---
> 
>  kernel/trace/trace_event_types.h |    4 ++--
>  kernel/trace/trace_export.c      |   16 ++++++++--------
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
> index 6db005e..e74f090 100644
> --- a/kernel/trace/trace_event_types.h
> +++ b/kernel/trace/trace_event_types.h
> @@ -109,7 +109,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
>  	TRACE_STRUCT(
>  		TRACE_FIELD(unsigned long, ip, ip)
>  		TRACE_FIELD(char *, fmt, fmt)
> -		TRACE_FIELD_ZERO_CHAR(buf)
> +		TRACE_FIELD_ZERO(char, buf)
>  	),
>  	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
>  );
> @@ -117,7 +117,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
>  TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
>  	TRACE_STRUCT(
>  		TRACE_FIELD(unsigned long, ip, ip)
> -		TRACE_FIELD_ZERO_CHAR(buf)
> +		TRACE_FIELD_ZERO(char, buf)
>  	),
>  	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
>  );
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index 71c8d7f..b0ac92c 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -42,9 +42,9 @@ extern void __bad_type_size(void);
>  	if (!ret)							\
>  		return 0;
>  
> -#undef TRACE_FIELD_ZERO_CHAR
> -#define TRACE_FIELD_ZERO_CHAR(item)					\
> -	ret = trace_seq_printf(s, "\tfield:char " #item ";\t"		\
> +#undef TRACE_FIELD_ZERO
> +#define TRACE_FIELD_ZERO(type, item)					\
> +	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
>  			       "offset:%u;\tsize:0;\n",			\
>  			       (unsigned int)offsetof(typeof(field), item)); \
>  	if (!ret)							\
> @@ -92,9 +92,6 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
>  
>  #include "trace_event_types.h"
>  
> -#undef TRACE_ZERO_CHAR
> -#define TRACE_ZERO_CHAR(arg)
> -
>  #undef TRACE_FIELD
>  #define TRACE_FIELD(type, item, assign)\
>  	entry->item = assign;
> @@ -107,6 +104,9 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
>  #define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
>  	TRACE_FIELD(type, item, assign)
>  
> +#undef TRACE_FIELD_ZERO
> +#define TRACE_FIELD_ZERO(type, item)
> +



Is it about the above moving?
If so, could you just tell so that I can add something about
it in the changelog.

Thanks.
Frederic.




>  #undef TP_CMD
>  #define TP_CMD(cmd...)	cmd
>  
> @@ -178,8 +178,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	if (ret)							\
>  		return ret;
>  
> -#undef TRACE_FIELD_ZERO_CHAR
> -#define TRACE_FIELD_ZERO_CHAR(item)
> +#undef TRACE_FIELD_ZERO
> +#define TRACE_FIELD_ZERO(type, item)
>  
>  #undef TRACE_EVENT_FORMAT
>  #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com

