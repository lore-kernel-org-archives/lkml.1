Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbYIEDNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbYIEDNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYIEDJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:52408 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbYIEDJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vr0cy67ab7OBz1Tg6ydWnw4O2bdz7eYaHR/4r1bdBrQdoIlPNPIfOA420AleKoRsyX
         SiiauZujKlnzfTCAA7kQKOIBAc9nSENTIN6I5WCVZIesMAg6gT34/Z2zvZ+mCg1et0hY
         SbwnFhCE6rgw0/xHYeaxPlHfNEKJ84Nzd2coo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 13/16] x86: cpu common merge print_cpu_info
Date: Thu,  4 Sep 2008 20:09:11 -0700
Message-Id: <1220584154-32497-13-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common_64.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 6475548..68b06a3 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -730,8 +730,20 @@ __setup("noclflush", setup_noclflush);
 
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
+	char *vendor = NULL;
+
+	if (c->x86_vendor < X86_VENDOR_NUM)
+		vendor = this_cpu->c_vendor;
+	else if (c->cpuid_level >= 0)
+		vendor = c->x86_vendor_id;
+
+	if (vendor && strncmp(c->x86_model_id, vendor, strlen(vendor)))
+		printk(KERN_CONT "%s ", vendor);
+
 	if (c->x86_model_id[0])
 		printk(KERN_CONT "%s", c->x86_model_id);
+	else
+		printk(KERN_CONT "%d86", c->x86);
 
 	if (c->x86_mask || c->cpuid_level >= 0)
 		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
-- 
1.5.4.5

