Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYKEN7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYKEN7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYKEN66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:58:58 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:22063 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599AbYKEN64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:58:56 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] Inline double_unlock_balance()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sripathi Kodi <sripathik@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200811051857.14944.sripathik@in.ibm.com>
References: <200811051857.14944.sripathik@in.ibm.com>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 14:59:36 +0100
Message-Id: <1225893576.7803.3021.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 18:57 +0530, Sripathi Kodi wrote:
> Hi,
> 
> We have a test case which measures the variation in the amount of time 
> needed to perform a fixed amount of work on the preempt_rt kernel. We 
> started seeing deterioration in it's performance recently. The test 
> should never take more than 10 microseconds, but we started 5-10% 
> failure rate. Using elimination method, we traced the problem to commit 
> 1b12bbc747560ea68bcc132c3d05699e52271da0 (lockdep: re-annotate 
> scheduler runqueues). When LOCKDEP is disabled, this patch only adds an 
> additional function call to double_unlock_balance(). Hence I inlined 
> double_unlock_balance() and the problem went away. Here is a patch to 
> make this change.
> 
> Thanks,
> Sripathi.
> 
> lockdep: Inline double_unlock_balance()
> 
> Additional function call for double_unlock_balance() causes latency 
> problems for some test cases on the preempt_rt kernel.
> 
> Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

Acked-by; Peter Zijlstra <a.p.zijlstra@chello.nl>

> Index: linux-2.6.27.4/kernel/sched.c
> ===================================================================
> --- linux-2.6.27.4.orig/kernel/sched.c	2008-11-05 05:01:01.000000000 -0800
> +++ linux-2.6.27.4/kernel/sched.c	2008-11-05 05:01:20.000000000 -0800
> @@ -2812,7 +2812,7 @@
>  	return ret;
>  }
>  
> -static void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
> +static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
>  	__releases(busiest->lock)
>  {
>  	spin_unlock(&busiest->lock);

