Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYDHLUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYDHLUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYDHLTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:20 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:17009 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbYDHLTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:18 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 17/29] arm: use non-racy method for /proc/davinci_clocks creation
Date: Tue,  8 Apr 2008 15:19:24 +0400
Message-Id: <1207653576-12640-17-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE
to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Russell King <rmk@arm.linux.org.uk>
---
 arch/arm/mach-davinci/clock.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-davinci/clock.c b/arch/arm/mach-davinci/clock.c
index 4143828..c6b94f6 100644
--- a/arch/arm/mach-davinci/clock.c
+++ b/arch/arm/mach-davinci/clock.c
@@ -311,11 +311,7 @@ static const struct file_operations proc_davinci_ck_operations = {
 
 static int __init davinci_ck_proc_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("davinci_clocks", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_davinci_ck_operations;
+	proc_create("davinci_clocks", 0, NULL, &proc_davinci_ck_operations);
 	return 0;
 
 }
-- 
1.5.3.rc5

