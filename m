Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbYLAITJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbYLAITJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYLAISy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:18:54 -0500
Received: from ozlabs.org ([203.10.76.45]:58993 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYLAISx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:18:53 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 18:48:49 +1030
Subject: [PATCH 6/6] cpumask: Use find_last_bit()
Cc: Ingo Molnar <mingo@redhat.com>, Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011848.50126.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

There's one obvious place to use it: to find the highest possible cpu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 init/main.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -r 911f0f14f90b init/main.c
--- a/init/main.c	Fri Nov 07 16:28:47 2008 +1100
+++ b/init/main.c	Fri Nov 07 16:29:00 2008 +1100
@@ -379,12 +379,7 @@ EXPORT_SYMBOL(nr_cpu_ids);
 /* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
 static void __init setup_nr_cpu_ids(void)
 {
-	int cpu, highest_cpu = 0;
-
-	for_each_possible_cpu(cpu)
-		highest_cpu = cpu;
-
-	nr_cpu_ids = highest_cpu + 1;
+	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA


