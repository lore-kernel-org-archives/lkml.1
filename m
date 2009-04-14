Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbZDNFBc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 14 Apr 2009 01:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZDNFBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 01:01:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37704 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZDNFBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 01:01:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: anton@samba.org, mingo@elte.hu, akpm@linux-foundation.org,
   dipankar@in.ibm.com, manfred@colorfullife.com, cl@linux-foundation.org,
   josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com,
   ego@in.ibm.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
   peterz@infradead.org, penberg@cs.helsinki.fi, andi@firstfloor.org,
   tglx@linutronix.de, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/3] v2 Make hierarchical RCU less IPI-happy and add more tracing
Date: Mon, 13 Apr 2009 21:31:15 -0700
Message-Id: <1239683478419-git-send-email->
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This three-patch set fixes a hierarchical-RCU performance bug located
by Anton Blanchard.  This bug affects certain high-end floating-point
computation-heavy workloads with closely spaced barrier-synchronized
iterations, where an interruption of any one CPU's processing during a
given iteration slows the system as a whole.  This bug manifests itself
as excessive resched IPIs, and is strictly a performance regression.
It does not affect correctness.

The first patch provides the fix for the problem, the second patch
adds the tracing, and the third patch adds the documentation for the
tracing.

Located-by: Anton Blanchard <anton@au1.ibm.com>
Tested-by: Anton Blanchard <anton@au1.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
