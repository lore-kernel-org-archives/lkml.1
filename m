Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZF3LgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZF3LgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZF3LgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:36:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:45533 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZF3LgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:36:17 -0400
Message-Id: <4A4A14D40200007800008337@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 12:36:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix num_..._cpus() for non-SMP
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit ae7a47e72e1a0b5e2b46d1596bc2c22942a73023, the type of
num_online_cpus() & Co differs between MP and UP builds, causing e.g.
uses of max()/min() to result in compilation issues.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/linux/cpumask.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.31-rc1/include/linux/cpumask.h	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-num_..._cpus-no-smp/include/linux/cpumask.h	2009-06-23 14:06:50.000000000 +0200
@@ -502,9 +502,9 @@ extern const struct cpumask *const cpu_a
 #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
 #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
 #else
-#define num_online_cpus()	1
-#define num_possible_cpus()	1
-#define num_present_cpus()	1
+#define num_online_cpus()	1U
+#define num_possible_cpus()	1U
+#define num_present_cpus()	1U
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)



