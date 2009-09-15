Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZIOKLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZIOKLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZIOKLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:11:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:53429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZIOKLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:11:37 -0400
Subject: Re: [PATCH 2/2] tracing: Export ftrace API for kernel modules
From: Peter Zijlstra <peterz@infradead.org>
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>, paulus@samba.org,
       systemtap@sources.redhat.com
In-Reply-To: <4AAF6728.6010807@bk.jp.nec.com>
References: <4AAF6728.6010807@bk.jp.nec.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 12:11:19 +0200
Message-Id: <1253009479.5506.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 19:06 +0900, Atsushi Tsuji wrote:
> Export register_ and unresgister_ftrace_function_probe to modules. This can
> be used by SystemTap.

Its unusual to export bits without an in-kernel user.

> Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
> ---
>  kernel/trace/ftrace.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5ef8f59..9c32291 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2042,6 +2042,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  
>  	return count;
>  }
> +EXPORT_SYMBOL_GPL(register_ftrace_function_probe);
>  
>  enum {
>  	PROBE_TEST_FUNC		= 1,
> @@ -2108,6 +2109,7 @@ unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  	__unregister_ftrace_function_probe(glob, ops, data,
>  					  PROBE_TEST_FUNC | PROBE_TEST_DATA);
>  }
> +EXPORT_SYMBOL_GPL(unregister_ftrace_function_probe);
>  
>  void
>  unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops)

