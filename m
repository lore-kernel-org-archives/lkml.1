Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbXE3UfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbXE3UfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759077AbXE3Uer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:34:47 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759063AbXE3Ueq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:34:46 -0400
Date: Wed, 30 May 2007 13:34:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-Id: <20070530133407.4f5789a0.akpm@linux-foundation.org>
In-Reply-To: <20070530140229.811672406@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
	<20070530140229.811672406@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 10:00:34 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> @@ -2990,7 +2991,8 @@
>  			print_irqtrace_events(prev);
>  		dump_stack();
>  	}
> -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> +	cond_call(profile_on,
> +		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));
>  

That's looking pretty neat.  Do you have any before-and-after performance
figures for i386 and for a non-optimised architecture?
