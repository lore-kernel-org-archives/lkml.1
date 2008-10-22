Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbYJVTNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbYJVTNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYJVTNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:13:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbYJVTNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:13:37 -0400
Date: Wed, 22 Oct 2008 12:12:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 06/11] ftrace: add ftrace warn on to disable ftrace
Message-Id: <20081022121257.9a10513e.akpm@linux-foundation.org>
In-Reply-To: <20081022185136.489385614@goodmis.org>
References: <20081022184313.179487464@goodmis.org>
	<20081022185136.489385614@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 14:43:19 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Add ftrace warn on to disable ftrace as well as report a warning.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ftrace.c |   29 ++++++++++++++++++++++-------
>  1 file changed, 22 insertions(+), 7 deletions(-)
> 
> Index: linux-compile.git/kernel/trace/ftrace.c
> ===================================================================
> --- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 13:17:29.000000000 -0400
> +++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 13:20:11.000000000 -0400
> @@ -32,6 +32,24 @@
>  
>  #include "trace.h"
>  
> +#define FTRACE_WARN_ON(cond)			\
> +	do {					\
> +		if (unlikely(cond)) {		\
> +			WARN_ON(1);		\
> +			ftrace_kill();		\
> +		}				\
> +	} while (0)

This could be coded as

	if (WARN_ON(cond))
		ftrace_kill();

> +#define FTRACE_WARN_ON_ONCE(cond)		\
> +	do {					\
> +		static int once;		\
> +		if (unlikely(cond) && !once) {	\
> +			once++;			\
> +			WARN_ON(1);		\
> +			ftrace_kill();		\
> +		}				\
> +	} while (0)


	if (WARN_ON_ONCE(cond))
		ftrace_kill();


