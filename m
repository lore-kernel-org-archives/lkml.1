Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbXJXHVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbXJXHVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXJXHVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:21:05 -0400
Received: from ozlabs.org ([203.10.76.45]:39635 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXJXHVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:21:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH 4/5] Remove CPU_DEAD/CPU_UP_CANCELLED handling from workqueue.c
Date: Wed, 24 Oct 2007 17:21:04 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <20071024052931.GA22722@in.ibm.com> <20071024053716.GD27074@in.ibm.com>
In-Reply-To: <20071024053716.GD27074@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241721.05163.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 15:37:16 Gautham R Shenoy wrote:
> @@ -712,7 +712,7 @@ static void start_workqueue_thread(struc
>
>  	if (p != NULL) {
>  		if (cpu >= 0)
> -			kthread_bind(p, cpu);
> +			set_cpus_allowed(p, cpumask_of_cpu(cpu));
>  		wake_up_process(p);
>  	}

Hi Gautham!

	This works, although the change is unnecessary.  If you're going to
do this I'd prefer "if (set_cpus_allowed(p, cpumask_of_cpu(cpu)) != 0) 
BUG();".

Cheers,
Rusty.
