Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbZJMNYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbZJMNYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbZJMNYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:24:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51980 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZJMNYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:24:07 -0400
Subject: Re: [PATCH 2/3] tracing: Rename set_ftrace to set_bootup_ftrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <1255419540-5481-3-git-send-email-fweisbec@gmail.com>
References: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
	 <1255419540-5481-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 09:22:07 -0400
Message-Id: <1255440127.7113.1551.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 09:38 +0200, Frederic Weisbecker wrote:
> Do this rename because set_ftrace is too much generic and not enough
> self-explainable as a name.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4506826..866daf8 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -129,7 +129,7 @@ static int tracing_set_tracer(const char *buf);
>  static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
>  static char *default_bootup_tracer;
>  
> -static int __init set_ftrace(char *str)
> +static int __init set_bootup_ftrace(char *str)
>  {
>  	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
>  	default_bootup_tracer = bootup_tracer_buf;
> @@ -137,7 +137,7 @@ static int __init set_ftrace(char *str)
>  	ring_buffer_expanded = 1;
>  	return 1;
>  }
> -__setup("ftrace=", set_ftrace);
> +__setup("ftrace=", set_bootup_ftrace);

Actually, it probably should be called, set_cmdline_ftrace. Since it
came from the command line, and that is what is matching.

-- Steve

>  
>  static int __init set_ftrace_dump_on_oops(char *str)
>  {

