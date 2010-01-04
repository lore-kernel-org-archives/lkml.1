Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909Ab0ADXIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0ADXIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435Ab0ADXIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:08:53 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59962 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab0ADXIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:08:53 -0500
Date: Mon, 4 Jan 2010 15:08:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/11] rcu: suppress GP start to simplify
	force_quiescent_state()
Message-ID: <20100104230850.GA22111@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series makes a sequence of changes that prevent a new RCU
grace period from starting while force_quiescent_state() is the the
process of trying to cause the prior grace period to complete.  This
simplifies the code and eliminates numerous painful race conditions.

							Thanx, Paul

 b/include/linux/rcutiny.h |   12 +++
 b/include/linux/rcutree.h |    3 
 b/kernel/rcutorture.c     |   80 +++++++++++++++++++++++-
 b/kernel/rcutree.c        |   28 +++++---
 b/kernel/rcutree.h        |    3 
 b/kernel/rcutree_plugin.h |   20 +++++-
 kernel/rcutree.c          |  153 +++++++++++++++++++++-------------------------
 kernel/rcutree.h          |   15 ++--
 8 files changed, 211 insertions(+), 103 deletions(-)
