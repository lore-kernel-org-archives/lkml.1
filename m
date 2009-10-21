Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbZJUQUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbZJUQUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZJUQUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:20:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58894 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZJUQUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:20:31 -0400
Subject: Re: [PATCH 2/4] tracing: fix trace_seq_printf return value
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1256135801-1849-3-git-send-email-jolsa@redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
	 <1256135801-1849-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 12:20:35 -0400
Message-Id: <1256142035.18347.3133.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 16:36 +0200, Jiri Olsa wrote:
> I believe we want to return the number of written characters,
> instead of the available buffer length.
> 
> wbr,
> jirka
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace_output.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index ed17565..e871125 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -95,7 +95,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
>  
>  	s->len += ret;
>  
> -	return len;
> +	return ret;

Actually the return value here is ambiguous. Returning len is actually
safer. It probably should only return 0 (buffer not big enough to write
to) or 1 (buffer is big enough).

Because this should actually return non zero:

  trace_seq_printf(s, "");

-- Steve

>  }
>  EXPORT_SYMBOL_GPL(trace_seq_printf);
>  

