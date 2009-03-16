Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbZCPWJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbZCPWJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZCPWJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:09:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49622 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbZCPWJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:09:41 -0400
Date: Mon, 16 Mar 2009 18:09:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH] tracing/ftrace: fix the check on nopped sites
In-Reply-To: <1237239660-6342-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0903161808530.5094@gandalf.stny.rr.com>
References: <1237239660-6342-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Mar 2009, Frederic Weisbecker wrote:

> Impact: fix a dynamic tracing failure
> 
> Recently, the function and function graph tracers failed to use dynamic
> tracing after the following commit:
> 
> fa9d13cf135efbd454453a53b6299976bea245a9
> (ftrace: don't try to __ftrace_replace_code on !FTRACE_FL_CONVERTED rec)
> 
> The patch is right except a mistake on the check for the FTRACE_FL_CONVERTED
> flag. The code patching is aborted in case of successfully nopped sites.
> What we want is the opposite: ignore the callsites that haven't been nopped.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 90d5729..7847806 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -537,7 +537,7 @@ static void ftrace_replace_code(int enable)
>  		 */
>  		if (rec->flags & FTRACE_FL_FREE ||
>  		    rec->flags & FTRACE_FL_FAILED ||
> -		    rec->flags & FTRACE_FL_CONVERTED)
> +		    !(rec->flags & FTRACE_FL_CONVERTED))
>  			continue;
>  
>  		/* ignore updates to this record's mcount site */
> -- 

Heh, I just found this bug too, and wrote a patch. But you posted before I 
did, so I'll let you have it ;-)

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

