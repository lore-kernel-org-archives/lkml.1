Return-Path: <linux-kernel-owner+w=401wt.eu-S965468AbXAXAjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965468AbXAXAjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965470AbXAXAjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:39:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44740 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965468AbXAXAja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:39:30 -0500
Date: Tue, 23 Jan 2007 16:38:26 -0800
From: Andrew Morton <akpm@osdl.org>
To: dipankar@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [mm PATCH 4/6] RCU: preemptible RCU
Message-Id: <20070123163826.d4ba703a.akpm@osdl.org>
In-Reply-To: <20070115192858.GE32238@in.ibm.com>
References: <20070115191909.GA32238@in.ibm.com>
	<20070115192858.GE32238@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jan 2007 00:58:58 +0530
Dipankar Sarma <dipankar@in.ibm.com> wrote:

> +/*
> + * Wait for CPUs to acknowledge the flip.
> + */
> +static int rcu_try_flip_waitack(int flipctr)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		if (per_cpu(rcu_flip_flag, cpu) != RCU_FLIP_SEEN) 
> +			return 1;
> +
> +	/*
> +	 * Make sure our checks above don't bleed into subsequent
> +	 * waiting for the sum of the counters to reach zero.
> +	 */
> +	smp_mb();
> +	return 0;
> +}

Confused.  If some of the possible cpus aren't online, doesn't the 
state machine get stuck??
