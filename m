Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYKZANT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYKZANT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYKZANI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:13:08 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:38320 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYKZANG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:13:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E1xQEbCQgNrqK84EYwRaPgYd7x1pIS0pEqHCb/lTKJwT4W654gZlkCu41oszbg5P+X
         XUOBGAfeX7emeEDLottccFf1cne4olfouqOr6WVCVTGAq2UkEG+UWjjDHp85GZfiPw4s
         CunKaBpNBFkJnQAVNMx+YwVX4r4+CGgyTyOzo=
Message-ID: <c62985530811251613n4c328b29od6d6cee2bfb9341@mail.gmail.com>
Date: Wed, 26 Nov 2008 01:13:04 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] ftrace: use code patching for ftrace return tracer
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <20081125223457.162461633@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125223421.795046329@goodmis.org>
	 <20081125223457.162461633@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/25 Steven Rostedt <rostedt@goodmis.org>:
> From: Steven Rostedt <rostedt@goodmis.org>
>
> Impact: more efficient code for ftrace return tracer
>
> This patch uses the dynamic patching, when available, to patch
> the function return code into the kernel.
>
> This patch will ease the way for letting both function tracing
> and function return tracing run together.
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/kernel/entry_32.S |    5 ++++
>  arch/x86/kernel/ftrace.c   |   46 +++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/ftrace.h     |    5 ++++
>  kernel/trace/ftrace.c      |   34 ++++++++++++++------------------
>  4 files changed, 70 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 7a934c0..d6f0333 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1185,6 +1185,11 @@ ftrace_call:
>        popl %edx
>        popl %ecx
>        popl %eax
> +#ifdef CONFIG_FUNCTION_RET_TRACER
> +.globl ftrace_return_call
> +ftrace_return_call:
> +       jmp ftrace_stub
> +#endif


And you patch ftrace_stub to ftrace_return_caller.
I see...
Seems a good idea :-)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
