Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYLAIRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYLAIRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYLAIRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:17:09 -0500
Received: from ozlabs.org ([203.10.76.45]:58544 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYLAIRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:17:06 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 18:47:03 +1030
Subject: [PATCH 2/6] cpumask: Use accessors code: core
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011847.03666.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use new API

Use the accessors rather than frobbing bits directly.  Most of this is
in arch code I haven't even compiled, but it is mostly straightforward.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 init/main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -r 07ebea6b5b50 init/main.c
--- a/init/main.c	Fri Oct 31 11:22:33 2008 +1100
+++ b/init/main.c	Fri Oct 31 11:23:04 2008 +1100
@@ -523,9 +523,9 @@ static void __init boot_cpu_init(void)
 {
 	int cpu = smp_processor_id();
 	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
-	cpu_set(cpu, cpu_online_map);
-	cpu_set(cpu, cpu_present_map);
-	cpu_set(cpu, cpu_possible_map);
+	set_cpu_online(cpu, true);
+	set_cpu_present(cpu, true);
+	set_cpu_possible(cpu, true);
 }
 
 void __init __weak smp_setup_processor_id(void)


