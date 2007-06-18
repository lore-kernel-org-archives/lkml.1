Return-Path: <linux-kernel-owner+w=401wt.eu-S1761058AbXFRQy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058AbXFRQy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXFRQyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:54:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49195 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752539AbXFRQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:54:20 -0400
Date: Mon, 18 Jun 2007 09:54:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
In-Reply-To: <20070618151215.GA9750@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com>
References: <20070613180451.GA16628@elte.hu> <20070613184741.GC8125@linux.vnet.ibm.com>
 <20070613185522.GA27335@elte.hu> <20070613233910.GJ8125@linux.vnet.ibm.com>
 <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com>
 <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com>
 <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com>
 <20070618151215.GA9750@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Srivatsa Vaddagiri wrote:

> This particular machine, elm3b6, is a 4-cpu, (gasp, yes!) 4-node box i.e 
> each CPU is a node by itself. If you don't have CONFIG_NUMA enabled,
> then we won't have cross-node (i.e cross-cpu) load balancing.
> Fortunately in your case you had CONFIG_NUMA enabled, but still were
> hitting the (gross) load imbalance.
> 
> The problem seems to be with idle_balance(). This particular routine,
> invoked by schedule() on a idle cpu, walks up sched-domain hierarchy and
> tries to balance in each domain that has SD_BALANCE_NEWIDLE flag set.
> The nodes-level domain (SD_NODE_INIT) however doesn't set this flag,
> which means idle cpu looks for (im)balance within its own node at most and

The nodes-level domain looks for internode balances between up to 16 
nodes. It is not restricted to a single node. The balancing on the
phys_domain level does balance within a node.
