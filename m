Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYHHKs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYHHKs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYHHKsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:48:21 -0400
Received: from saeurebad.de ([85.214.36.134]:57877 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYHHKsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:48:20 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: printk formatting infrastructure fix 2
References: <200808062133.m76LXpGk016460@imap1.linux-foundation.org>
	<87zlnpueo9.fsf@skyscraper.fehenstaub.lan>
Date: Fri, 08 Aug 2008 12:47:52 +0200
In-Reply-To: <87zlnpueo9.fsf@skyscraper.fehenstaub.lan> (Johannes Weiner's
	message of "Thu, 07 Aug 2008 15:40:06 +0200")
Message-ID: <87fxpf4wbr.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

[sorry, screwed up the recpt list before....]

Johannes Weiner <hannes@saeurebad.de> writes:

> Hi,
>
> akpm@linux-foundation.org writes:
>
>> ftrace-new-continue-entry-separate-out-from-trace_entry.patch
>> ftrace-printk-formatting-infrastructure.patch
>
> ---
> The attribute on the function definition breaks compilation.  Instead of
> removing it, we could use a declaration and add the attribute there, but
> then, when someone adds new ftrace_printk()s, she will probably compile
> with CONFIG_TRACING and the callsite is garuanteed to be verified during
> development.
>
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
>  include/linux/ftrace.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -165,7 +165,7 @@ __ftrace_printk(unsigned long ip, const 
>  static inline void
>  ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
>  static inline int
> -ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)))
> +ftrace_printk(const char *fmt, ...)
>  {
>  	return 0;
>  }

Still needed, get this with mmotm-2008-08-08-00-56 and !CONFIG_TRACING:

In file included from kernel/sched.c:74:
include/linux/ftrace.h:169: error: expected ‘,’ or ‘;’ before ‘{’ token
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

	Hannes
