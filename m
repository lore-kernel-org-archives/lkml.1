Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZKNDui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZKNDui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 22:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZKNDug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:50:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47650 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319AbZKNDuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:50:35 -0500
Date: Fri, 13 Nov 2009 19:51:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/2] rcu: lastcomp cleanups, fix rcu_pending()
	false positives
Message-ID: <20091114035100.GA9599@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches are yet more from the ongoing cleanup/inspection
session for RCU.

1.	Get the (hopefully) last of the accesses to the ->completed
	fields cleaned up.

2.	Fix a race in __rcu_pending() accesses to ->gpnum and
	->completed fields that could cause needless (but otherwise
	harmless) raising of RCU_SOFTIRQ.
