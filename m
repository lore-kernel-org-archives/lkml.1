Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYDHLXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYDHLXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYDHLT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2694 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbYDHLTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:22 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 18/29] avr32: proc: use non-racy method for /proc/tlb creation
Date: Tue,  8 Apr 2008 15:19:25 +0400
Message-Id: <1207653576-12640-18-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE
to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/mm/tlb.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/avr32/mm/tlb.c b/arch/avr32/mm/tlb.c
index b835257..cd12edb 100644
--- a/arch/avr32/mm/tlb.c
+++ b/arch/avr32/mm/tlb.c
@@ -369,11 +369,7 @@ static const struct file_operations proc_tlb_operations = {
 
 static int __init proctlb_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("tlb", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_tlb_operations;
+	proc_create("tlb", 0, NULL, &proc_tlb_operations);
 	return 0;
 }
 late_initcall(proctlb_init);
-- 
1.5.3.rc5

