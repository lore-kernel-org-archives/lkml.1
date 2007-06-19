Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbXFSKeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbXFSKeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbXFSKeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:34:44 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45238 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbXFSKen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:34:43 -0400
Date: Tue, 19 Jun 2007 16:13:14 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au, clameter@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070619104314.GF17865@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070613185522.GA27335@elte.hu> <20070613233910.GJ8125@linux.vnet.ibm.com> <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com> <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com> <20070619090430.GA7471@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619090430.GA7471@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 11:04:30AM +0200, Ingo Molnar wrote:
> I'm wondering, why did this trigger under CFS and not on mainline? 

I thought Paul had seen the same problem with 2.6.21.5. I will try a
more recent mainline (2.6.22-rc5 maybe) after I get hold of the problem
machine and report later today.

If there is any difference, it should be because of the reported topology
by low-level platform code. In the problem case, each CPU was being reported
to be a separate node (CONFIG_NUMA enabled) which caused idle_balance()
to stop load-balance lookups at cpu/node level itself. 

> Mainline seems to have a similar problem in idle_balance() too, or am i 
> misreading it?

-- 
Regards,
vatsa
