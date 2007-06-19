Return-Path: <linux-kernel-owner+w=401wt.eu-S1764898AbXFSCSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764898AbXFSCSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbXFSCR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:17:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:15035 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242AbXFSCRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:17:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,436,1175497200"; 
   d="scan'208";a="97849005"
Date: Mon, 18 Jun 2007 19:13:43 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070619021342.GC7160@linux-os.sc.intel.com>
References: <20070615151452.GC9301@linux.vnet.ibm.com> <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com> <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com> <20070618173558.GA17865@linux.vnet.ibm.com> <Pine.LNX.4.64.0706181054530.6596@schroedinger.engr.sgi.com> <20070619015232.GE17865@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619015232.GE17865@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 07:22:32AM +0530, Srivatsa Vaddagiri wrote:
> On Mon, Jun 18, 2007 at 10:59:21AM -0700, Christoph Lameter wrote:
> > I think the check in idle_balance needs to be modified.
> > 
> > If the domain *does not* have SD_BALANCE_NEWIDLE set then
> > next_balance must still be set right. Does this patch fix it?
> 
> Is the ->next_balance calculation in idle_balance() necessary at all?
> rebalance_domains() would have programmed ->next_balance anyway, based
> on the nearest next_balance point of all (load-balance'able) domains.
> By repeating that calculation in idle_balance, are we covering any corner case?

rebalance_domains() have programmed ->next_balance based on 'busy' state.
And now, as it is going to 'idle', this routine is recalculating
the next_balance based on 'idle' state.

thanks,
suresh
