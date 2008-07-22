Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYGVF2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYGVF2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYGVFWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:43062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827AbYGVFWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 19/79] device create: mips: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:43 -0700
Message-Id: <1216703983-21448-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/mips/kernel/rtlx.c             |    4 ++--
 arch/mips/sibyte/common/sb_tbprof.c |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index b556419..dfd868b 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -522,8 +522,8 @@ static int __init rtlx_module_init(void)
 		atomic_set(&channel_wqs[i].in_open, 0);
 		mutex_init(&channel_wqs[i].mutex);
 
-		dev = device_create(mt_class, NULL, MKDEV(major, i),
-		                    "%s%d", module_name, i);
+		dev = device_create_drvdata(mt_class, NULL, MKDEV(major, i),
+					    NULL, "%s%d", module_name, i);
 		if (IS_ERR(dev)) {
 			err = PTR_ERR(dev);
 			goto out_chrdev;
diff --git a/arch/mips/sibyte/common/sb_tbprof.c b/arch/mips/sibyte/common/sb_tbprof.c
index 28b012a..66e3e3f 100644
--- a/arch/mips/sibyte/common/sb_tbprof.c
+++ b/arch/mips/sibyte/common/sb_tbprof.c
@@ -576,7 +576,8 @@ static int __init sbprof_tb_init(void)
 
 	tb_class = tbc;
 
-	dev = device_create(tbc, NULL, MKDEV(SBPROF_TB_MAJOR, 0), "tb");
+	dev = device_create_drvdata(tbc, NULL, MKDEV(SBPROF_TB_MAJOR, 0),
+				    NULL, "tb");
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_class;
-- 
1.5.6.3

