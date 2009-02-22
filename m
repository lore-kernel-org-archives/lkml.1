Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZBVALx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZBVALx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZBVALo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:11:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:22805 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbZBVALn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:11:43 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 13/16] kprobes: fix sparse warnings: Using plain integer as
	NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:05:24 +0100
Message-ID: <20090222000521.17557.93357.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  kernel/test_kprobes.c:118:19: warning: Using plain integer as NULL pointer
  kernel/test_kprobes.c:213:22: warning: Using plain integer as NULL pointer
  kernel/test_kprobes.c:326:22: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 kernel/test_kprobes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
index 4f10451..9a43351 100644
--- a/kernel/test_kprobes.c
+++ b/kernel/test_kprobes.c
@@ -115,7 +115,7 @@ static int test_kprobes(void)
 	int ret;
 	struct kprobe *kps[2] = {&kp, &kp2};
 
-	kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	kp.addr = NULL; /* addr should be cleard for reusing kprobe. */
 	ret = register_kprobes(kps, 2);
 	if (ret < 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -210,7 +210,7 @@ static int test_jprobes(void)
 	int ret;
 	struct jprobe *jps[2] = {&jp, &jp2};
 
-	jp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	jp.kp.addr = NULL; /* addr should be cleard for reusing kprobe. */
 	ret = register_jprobes(jps, 2);
 	if (ret < 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -323,7 +323,7 @@ static int test_kretprobes(void)
 	int ret;
 	struct kretprobe *rps[2] = {&rp, &rp2};
 
-	rp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	rp.kp.addr = NULL; /* addr should be cleard for reusing kprobe. */
 	ret = register_kretprobes(rps, 2);
 	if (ret < 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "

