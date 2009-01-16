Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbZAPKIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbZAPKIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbZAPKI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:08:28 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35613 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbZAPKI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:08:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QqsTnBuPjm2pCxKneEXh/LRH2AJGn2bqM6GbhI2Iy7Vbnr0+DDgVx3cK6rzcd0PTCs
         5nZw7Qj3Lp19VHFrQMaW1yUn6nS5QNFo84RDwwGdQpubwjSKZznxJ+ZjTRxS0XMhc4qW
         9D3WD8UxBZtKRKKari78sNIKtQYXLhixDiQEc=
Message-ID: <c62985530901160208r4400e438j7c27528019c1a6db@mail.gmail.com>
Date: Fri, 16 Jan 2009 11:08:24 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] ftrace: add stack trace to function tracer
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <20090116004121.302184848@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090116004050.273665842@goodmis.org>
	 <20090116004121.302184848@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

2009/1/16 Steven Rostedt <rostedt@goodmis.org>:
> +static struct tracer_flags func_flags = {
> +       .val = 0, /* By default: all flags disabled */
> +       .opts = func_opts
> +};
> +
> +static int func_set_flag(u32 old_flags, u32 bit, int set)
> +{
> +       if (bit == TRACE_FUNC_OPT_STACK) {
> +               /* do nothing if already set */
> +               if (!!set == !!(func_flags.val & TRACE_FUNC_OPT_STACK))
> +                       return 0;


This is just a small thing but set will always be 1 or 0. And if you want
the current val of your options, you can take old_flags :-)

Would you prefer I send a patch to not call the set_flag callback
when the option set/unset by the user is already set/unset ?


> +               if (set)
> +                       register_ftrace_function(&trace_stack_ops);
> +               else
> +                       unregister_ftrace_function(&trace_stack_ops);
> +
> +               return 0;
> +       }
> +
> +       return -EINVAL;
> +}
> +
>  static struct tracer function_trace __read_mostly =
>  {
>        .name        = "function",
>        .init        = function_trace_init,
>        .reset       = function_trace_reset,
>        .start       = function_trace_start,
> +       .flags          = &func_flags,
> +       .set_flag       = func_set_flag,
>  #ifdef CONFIG_FTRACE_SELFTEST
>        .selftest    = trace_selftest_startup_function,
>  #endif
> --
> 1.5.6.5
>
> --
>
