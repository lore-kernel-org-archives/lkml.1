Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZJFHP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZJFHP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZJFHP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:15:56 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:42432 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZJFHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=P/fsr8PH2jQoHMIoAwcaivf+QzVmE793oZ8lGdgHGFdGJWn/IIu3CTSauGoVtNagW4
         84DjiL4sNbKBgNRgLiuSCmMBRiB9ueJRMJkfcBqBnVQY00NHnLu6I8evG1b0AMcYpF9Z
         pm63wvU679yx7thhllmNMDKZLFPSr7NwdZUpQ=
MIME-Version: 1.0
In-Reply-To: <1254808849-7829-4-git-send-email-tzanussi@gmail.com>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
	 <1254808849-7829-4-git-send-email-tzanussi@gmail.com>
Date: Tue, 6 Oct 2009 09:15:17 +0200
Message-ID: <c62985530910060015t74d8c116i8593839e6d8a3af5@mail.gmail.com>
Subject: Re: [PATCH 3/3] tracing/syscalls: Use long for syscall ret format and 
	field definitions
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/6, Tom Zanussi <tzanussi@gmail.com>:
> The syscall event definitions use long for the syscall exit ret value,
> but unsigned long for the same thing in the format and field
> definitions.  Change them all to long.


Thanks.

We may perhaps also want to change struct syscall_trace_exit
according to that?
That won't change the code behaviour, just the logic while
reviewing.

It's just a neat, this patch itself is fine.


>
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> ---
>  kernel/trace/trace_syscalls.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 9fbce6c..527e17e 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -166,7 +166,7 @@ int syscall_exit_format(struct ftrace_event_call *call,
> struct trace_seq *s)
>  			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
>  			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
>  			       SYSCALL_FIELD(int, nr),
> -			       SYSCALL_FIELD(unsigned long, ret));
> +			       SYSCALL_FIELD(long, ret));
>  	if (!ret)
>  		return 0;
>
> @@ -212,7 +212,7 @@ int syscall_exit_define_fields(struct ftrace_event_call
> *call)
>  	if (ret)
>  		return ret;
>
> -	ret = trace_define_field(call, SYSCALL_FIELD(unsigned long, ret), 0,
> +	ret = trace_define_field(call, SYSCALL_FIELD(long, ret), 0,
>  				 FILTER_OTHER);
>
>  	return ret;
> --
> 1.6.4.GIT
>
>
