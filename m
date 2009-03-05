Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZCEQ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZCEQ1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZCEQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:27:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60840 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbZCEQ1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:27:02 -0500
Date: Thu, 5 Mar 2009 17:23:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 4/4] timers: logic to enable timer migration.
Message-ID: <20090305162329.GA5294@redhat.com>
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121937.GE9855@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304121937.GE9855@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Arun R Bharadwaj wrote:
>
> +++ linux.trees.git/kernel/sched.c
> @@ -4009,6 +4009,11 @@ static struct {
>  	.load_balancer = ATOMIC_INIT(-1),
>  };
>
> +inline int get_nohz_load_balancer(void)

inline?

> +{
> +	return atomic_read(&nohz.load_balancer);
> +}

Shouldn't we reset .load_balancer when this CPU is CPU_DOWN'ed ?
Otherwise the timer can migrate to the dead CPU.

Oleg.

