Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbYIHMme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbYIHMme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYIHMmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:42:25 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34933 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYIHMmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:42:25 -0400
X-IronPort-AV: E=Sophos;i="4.32,358,1217822400"; 
   d="scan'208";a="18945367"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] Xen: Fix build when !CONFIG_HOTPLUG_CPU
Date: Mon,  8 Sep 2008 13:43:33 +0100
Message-Id: <1220877814-4934-1-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 08 Sep 2008 12:42:23.0329 (UTC) FILETIME=[574C1510:01C911B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/smp.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index be5cbb2..bf51a46 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -332,6 +332,7 @@ static void xen_smp_cpus_done(unsigned int max_cpus)
 {
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 int xen_cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
@@ -368,6 +369,23 @@ void xen_play_dead(void)
 	cpu_bringup();
 }
 
+#else /* !CONFIG_HOTPLUG_CPU */
+int xen_cpu_disable(void)
+{
+	return -ENOSYS;
+}
+
+void xen_cpu_die(unsigned int cpu)
+{
+	BUG();
+}
+
+void xen_play_dead(void)
+{
+	BUG();
+}
+
+#endif
 static void stop_self(void *v)
 {
 	int cpu = smp_processor_id();
-- 
1.5.4.3

