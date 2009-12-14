Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbZLNWVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbZLNWVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbZLNWVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:21:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:34338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbZLNWVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:21:34 -0500
Subject: Re: [patch 2/2] sched: Scale the nohz_tracker logic by making it
 per NUMA node
From: Peter Zijlstra <peterz@infradead.org>
To: venkatesh.pallipadi@intel.com
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20091211013056.450920000@intel.com>
References: <20091211012748.267627000@intel.com>
	 <20091211013056.450920000@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 23:21:23 +0100
Message-ID: <1260829283.8023.124.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 17:27 -0800, venkatesh.pallipadi@intel.com wrote:
> Having one idle CPU doing the rebalancing for all the idle CPUs in
> nohz mode does not scale well with increasing number of cores and
> sockets. Make the nohz_tracker per NUMA node. This results in multiple
> idle load balancing happening at NUMA node level and idle load balancer
> only does the rebalance domain among all the other nohz CPUs in that
> NUMA node.
> 
> This addresses the below problem with the current nohz ilb logic
> * The lone balancer may end up spending a lot of time doing the
> * balancing on
>   behalf of nohz CPUs, especially with increasing number of sockets and
>   cores in the platform.

If the purpose is to keep sockets idle, doing things per node doesn't
seem like a fine plan, since we're having nodes <= socket machines these
days.



