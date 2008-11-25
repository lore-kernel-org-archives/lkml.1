Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYKYL0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYKYL0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYKYLZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:25:53 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:62460 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYKYLZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:25:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=axlzHEguToPiJ50xYxD4sfHJTa92dq6eCIKXEzjw3wLeT0jcSp28g1iWXsW58Azwn8
         mjkdkSQlvXwysjqs1zJDYBjaHn8WLW55nAPJircznujCTQASKTEDCaKAMCG7r4HF0AnY
         8gEcE87fP9tmCXf6WdU73qo5fsVzKo8Vrk9n8=
Message-ID: <c62985530811250325h63ba1a08j610eb0be5ed73a45@mail.gmail.com>
Date: Tue, 25 Nov 2008 12:25:51 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] ftrace: Add a C/P state tracer to help power optimization
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org
In-Reply-To: <20081123164958.21fae966@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081123125931.4afe16ca@infradead.org>
	 <c62985530811231312u51650cbcm2cb7b4f5c60d064@mail.gmail.com>
	 <20081123164958.21fae966@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That looks good...

2008/11/24 Arjan van de Ven <arjan@infradead.org>:
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 7854d87..0df2886 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -311,6 +311,35 @@ ftrace_init_module(struct module *mod,
>                   unsigned long *start, unsigned long *end) { }
>  #endif
>
> +enum {
> +       POWER_NONE = 0,
> +       POWER_CSTATE = 1,
> +       POWER_PSTATE = 2,
> +};
> +
> +struct power_trace {
> +#ifdef CONFIG_POWER_TRACER
> +       ktime_t                 stamp;
> +       ktime_t                 end;
> +       int                     type;
> +       int                     state;
> +#endif
> +};
> +
> +#ifdef CONFIG_POWER_TRACER
> +extern void trace_power_start(struct power_trace *it, unsigned int type,
> +                                       unsigned int state);
> +extern void trace_power_mark(struct power_trace *it, unsigned int type,
> +                                       unsigned int state);
> +extern void trace_power_end(struct power_trace *it);
> +#else
> +static inline void trace_power_start(struct power_trace *it, unsigned int type,
> +                                       unsigned int state) { }
> +static inline void trace_power_mark(struct power_trace *it, unsigned int type,
> +                                       unsigned int state) { }
> +static inline void trace_power_end(struct power_trace *it) { }
> +#endif
> +


Sorry I didn't see it on my last mail.
But these headers seem to relate more on "power tracing" rather than "ftrace".
Perhaps these would find a better place on trace/power.h
I guess that could be done on a delta patch as well....


Just for curiosity, do you have an example of trace and/or graph from
this tracer?
