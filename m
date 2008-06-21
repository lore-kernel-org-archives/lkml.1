Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYFUJ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYFUJ4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 05:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYFUJz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 05:55:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49657 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbYFUJzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 05:55:55 -0400
Message-ID: <485CCFB9.9050208@cn.fujitsu.com>
Date: Sat, 21 Jun 2008 17:54:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-arch@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH]rcu,alpha: avoid smp_read_barrier_depends in rcu_dereference
 when pointer==NULL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul and Alpha hackers

memory barrier is expensive, I think it's worth that adding an if-statement
to avoid it when pointer == NULL.

This patch change nothing in UP or in other architectures for compiler's
optimization.

			Thanks, Lai Jiangshan


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d42dbec..8979f29 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -143,7 +143,8 @@ struct rcu_head {
 
 #define rcu_dereference(p)     ({ \
 				typeof(p) _________p1 = ACCESS_ONCE(p); \
-				smp_read_barrier_depends(); \
+				if (_________p1) \
+					smp_read_barrier_depends(); \
 				(_________p1); \
 				})
 



