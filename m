Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYAANu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYAANu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYAANtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:49:41 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50143 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326AbYAANtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:49:36 -0500
Date: Tue, 1 Jan 2008 15:49:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] OSS msnd: fix array overflows
Message-ID: <20080101134921.GQ2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes array overflows in the OSS msnd driver spotted by the 
Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 27 Oct 2007

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

