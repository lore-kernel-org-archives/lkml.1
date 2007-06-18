Return-Path: <linux-kernel-owner+w=401wt.eu-S1763437AbXFRR1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763437AbXFRR1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXFRR13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:27:29 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49752 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbXFRR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:27:28 -0400
Date: Mon, 18 Jun 2007 23:05:58 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070618173558.GA17865@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070613185522.GA27335@elte.hu> <20070613233910.GJ8125@linux.vnet.ibm.com> <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com> <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com> <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 09:54:18AM -0700, Christoph Lameter wrote:
> The nodes-level domain looks for internode balances between up to 16 
> nodes. It is not restricted to a single node.

I was mostly speaking with the example system in mind (4-node 4-cpu
box), but yes, node-level domain does look for imbalance across max 16
nodes as you mention.

Both node and all-node domains don't have SD_BALANCE_NEWIDLE set, which
means idle_balance() will stop looking for imbalance beyonds its own
node. Based on the observed balance within its own node, IMO,
idle_balance() should not cause ->next_balance to be reset.

-- 
Regards,
vatsa
