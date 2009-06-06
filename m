Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZFFOmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZFFOmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 10:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZFFOma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 10:42:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47310 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbZFFOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 10:42:29 -0400
Date: Sat, 6 Jun 2009 10:42:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing/branch-tracer: PROFILE_BRANCHES_PER_CPU must
 depend on SMP
In-Reply-To: <1244299043-7613-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0906061041150.9522@gandalf.stny.rr.com>
References: <20090606073128.GA7321@elte.hu> <1244299043-7613-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 6 Jun 2009, Frederic Weisbecker wrote:
> 
> [ Impact: fix a build failure with the branch tracer ]
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 309a264..0efbcc5 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -285,7 +285,7 @@ endchoice
>  
>  config PROFILE_BRANCHES_PER_CPU
>  	bool "Profile branches on a per cpu basis"
> -	depends on PROFILE_ALL_BRANCHES
> +	depends on PROFILE_ALL_BRANCHES && SMP

You just wasted two minutes of my time!

I was just about to send out the same patch, but you beat me to it. ;-)

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


>  	help
>  	  When profiling all branches, the system can take a big cache line
>  	  bouncing hit. On boxes with lots of CPUs, this can slow the system
> -- 
> 1.6.2.3
> 
> 
