Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbYJaMPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbYJaMPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYJaMPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:15:47 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:47135 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYJaMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bYnP8Nlhr9PIAGFLYKqU2g6ckQqWrfiEpKnfOROb9x/HLDHOH5Ti+L/7s8KWcQsrYj
         bBq6t/bkSCiKEJSjtDRY4SGCPO8FkweunXvhKNptR5lkREkiRgNnVAmAjT0qkIkt/AHV
         XlTlRyQp/iR2AbtZA8/xF5YusxRUnNF5ehYvk=
Message-ID: <c62985530810310515n59cadefx32a78ab7c4395251@mail.gmail.com>
Date: Fri, 31 Oct 2008 13:15:45 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH][RESEND] tracing/ftrace: Remove unused code in sched_switch tracer
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <490AF6A4.7080604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490AF6A4.7080604@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/31 Frederic Weisbecker <fweisbec@gmail.com>:
> When init_sched_switch_trace() is called, it has no reason to start
> the sched tracer if the sched_ref is not zero.
>
> _ If this is non-zero, the tracer is already used, but we can register it
> to the tracing engine. There is already a security which avoid the tracer
> probes not to be resgistered twice.
>
> _ If this is zero, this block will not be used.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_sched_switch.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
> index 59de514..96620c7 100644
> --- a/kernel/trace/trace_sched_switch.c
> +++ b/kernel/trace/trace_sched_switch.c
> @@ -203,14 +203,6 @@ static struct tracer sched_switch_trace __read_mostly =
>
>  __init static int init_sched_switch_trace(void)
>  {
> -       int ret = 0;
> -
> -       if (atomic_read(&sched_ref))
> -               ret = tracing_sched_register();
> -       if (ret) {
> -               pr_info("error registering scheduler trace\n");
> -               return ret;
> -       }
>        return register_tracer(&sched_switch_trace);
>  }
>  device_initcall(init_sched_switch_trace);
>

(depends on tracing/ftrace: Fix a race condition in sched_switch tracer)
