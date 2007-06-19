Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbXFSCU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbXFSCU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763977AbXFSCUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:20:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:24666 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763158AbXFSCUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:20:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,436,1175497200"; 
   d="scan'208";a="97849476"
Date: Mon, 18 Jun 2007 19:15:58 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070619021558.GD7160@linux-os.sc.intel.com>
References: <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com> <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com> <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com> <20070618173558.GA17865@linux.vnet.ibm.com> <Pine.LNX.4.64.0706181054530.6596@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181054530.6596@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:59:21AM -0700, Christoph Lameter wrote:
>  	for_each_domain(this_cpu, sd) {
> -		if (sd->flags & SD_BALANCE_NEWIDLE) {
> +		if (sd->flags & SD_BALANCE_NEWIDLE)
>  			/* If we've pulled tasks over stop searching: */
>  			pulled_task = load_balance_newidle(this_cpu,
>  							this_rq, sd);
> -			if (time_after(next_balance,
> -				  sd->last_balance + sd->balance_interval))
> -				next_balance = sd->last_balance
> -						+ sd->balance_interval;
> -			if (pulled_task)
> -				break;
> -		}
> +		if (time_after(next_balance,
> +			  sd->last_balance + sd->balance_interval))
> +			next_balance = sd->last_balance
> +					+ sd->balance_interval;

don't we have to do, msecs_to_jiffies(sd->balance_interval)?

thanks,
suresh
> +		if (pulled_task)
> +			break;
>  	}
>  	if (!pulled_task)
>  		/*
