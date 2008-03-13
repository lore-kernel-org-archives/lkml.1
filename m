Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYCMOyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYCMOyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYCMOyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:54:46 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5787 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbYCMOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:54:45 -0400
Message-ID: <47D94035.6080301@hp.com>
Date: Thu, 13 Mar 2008 10:54:45 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [PATCH 0/7] IO CPU affinity testing series
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Your suggestion worked Jens, will do some benchmarking, and try to figure out why on the side...

Subject: [PATCH] IA64 boots with direct call of generic init single data

Need to figure out why it needs to be done earlier on ia64.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 arch/ia64/kernel/setup.c |    2 ++
 arch/ia64/kernel/smp.c   |    7 -------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 4aa9eae..36a0fe5 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -518,6 +518,8 @@ setup_arch (char **cmdline_p)
 	acpi_boot_init();
 #endif
 
+	generic_init_call_single_data();
+
 #ifdef CONFIG_VT
 	if (!conswitchp) {
 # if defined(CONFIG_DUMMY_CONSOLE)
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index d8ee005..04ba9f8 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -113,13 +113,6 @@ stop_this_cpu (void)
 
 DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 
-int __cpuinit init_smp_call(void)
-{
-	generic_init_call_single_data();
-	return 0;
-}
-core_initcall(init_smp_call);
-
 void
 cpu_die(void)
 {
-- 
1.5.2.5

