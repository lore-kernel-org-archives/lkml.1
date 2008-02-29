Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbYB2Efc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbYB2Efc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYB2EfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:35:21 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:35289 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbYB2EfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:35:20 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
Date: Fri, 29 Feb 2008 05:34:54 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com>
In-Reply-To: <20071213171658.GE25981@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802290534.57040.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 13. December 2007, Gautham R Shenoy wrote:

> diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> index c64ce9c..06cafcc 100644
> --- a/kernel/Kconfig.preempt
> +++ b/kernel/Kconfig.preempt
> @@ -63,3 +63,41 @@ config PREEMPT_BKL
>  	  Say Y here if you are building a kernel for a desktop system.
>  	  Say N if you are unsure.
>
> +choice
> +	prompt "RCU implementation type:"
> +	default CLASSIC_RCU
> +
> +config CLASSIC_RCU
> +	bool "Classic RCU"
> +	help
> +	  This option selects the classic RCU implementation that is
> +	  designed for best read-side performance on non-realtime
> +	  systems.
> +
> +	  Say Y if you are unsure.
> +
> +config PREEMPT_RCU
> +	bool "Preemptible RCU"
> +	depends on PREEMPT
> +	help
> +	  This option reduces the latency of the kernel by making certain
> +	  RCU sections preemptible. Normally RCU code is non-preemptible, if
> +	  this option is selected then read-only RCU sections become
> +	  preemptible. This helps latency, but may expose bugs due to
> +	  now-naive assumptions about each RCU read-side critical section
> +	  remaining on a given CPU through its execution.
> +
> +	  Say N if you are unsure.
> +
> +endchoice

Why got this moved into init/Kconfig?
Now it's somewhere in the root menu, not really belonging to anything.
Also why is this a choice? Are more RCU types planned?

bye, Roman
