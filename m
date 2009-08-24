Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZHXQKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZHXQKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZHXQKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:10:09 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:32931 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZHXQKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:10:08 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH v4 2/5] sched: Record the current active power savings
 level
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20090331105022.16414.4304.stgit@sofia.in.ibm.com>
References: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
	 <20090331105022.16414.4304.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 18:09:25 +0200
Message-Id: <1251130165.7538.311.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 16:20 +0530, Gautham R Shenoy wrote:
> The existing load balancer code is dependent on the sched_mc_power_savings
> variable. However, on multi-core + multi-threaded machines, these decisions
> need to be dependent on the values of both sched_mc_power_savings and
> sched_smt_power_savings.
> 
> Create a new variable named active_power_savings_level which is the
> maximum of the sched_mc_power_savings and sched_smt_power_savings.
> 
> Record this value in a read mostly global variable at the time when the user
> changes the value of sched_mc/smt_power_savings tunable, and use it for
> load-balancing decisions instead of computing it everytime.

OK, so why keep these variables separate at all?

