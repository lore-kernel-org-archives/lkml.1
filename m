Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbXJ0OWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbXJ0OWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbXJ0OVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:21:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57350 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755533AbXJ0OVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:21:50 -0400
Date: Sat, 27 Oct 2007 16:22:11 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] OSS msnd: fix array overflows
Message-ID: <20071027142211.GZ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes array overflows in the OSS msnd driver spotted by the 
Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
97463a59dfb9ccb915d3b615225c98cb3e310c0a 
diff --git a/sound/oss/msnd.h b/sound/oss/msnd.h
index 05cf786..d0ca582 100644
--- a/sound/oss/msnd.h
+++ b/sound/oss/msnd.h
@@ -233,8 +233,8 @@ typedef struct multisound_dev {
 	spinlock_t lock;
 	int nresets;
 	unsigned long recsrc;
-	int left_levels[16];
-	int right_levels[16];
+	int left_levels[32];
+	int right_levels[32];
 	int mixer_mod_count;
 	int calibrate_signal;
 	int play_sample_size, play_sample_rate, play_channels;

