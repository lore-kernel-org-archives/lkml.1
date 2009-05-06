Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZEFCl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZEFCl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZEFClU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:41:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZEFClT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:41:19 -0400
Date: Tue, 5 May 2009 22:41:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] tracing/events: don't say hi when loading the trace
 event sample
In-Reply-To: <4A00F6AD.2070008@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905052240570.3239@gandalf.stny.rr.com>
References: <4A00F6AD.2070008@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 6 May 2009, Li Zefan wrote:

> The sample is useful for testing, and I'm using it. But after
> loading the module, it keeps saying hi every 10 seconds, this may
> be disturbing.
> 
> Also Steven said commenting out the "hi" helped in causing races. :)
> 
> [ Impact: make testing a bit easier ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  samples/trace_events/trace-events-sample.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
> index f33b3ba..aabc4e9 100644
> --- a/samples/trace_events/trace-events-sample.c
> +++ b/samples/trace_events/trace-events-sample.c
> @@ -16,10 +16,6 @@ static void simple_thread_func(int cnt)
>  	set_current_state(TASK_INTERRUPTIBLE);
>  	schedule_timeout(HZ);
>  	trace_foo_bar("hello", cnt);
> -
> -	if (!(cnt % 10))
> -		/* It is really important that I say "hi!" */

I guess it is not so important to say hi after all.

-- Steve

> -		printk(KERN_EMERG "hi!\n");
>  }
>  
>  static int simple_thread(void *arg)
> -- 
> 1.5.4.rc3
> 
> 
> 
