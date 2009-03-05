Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbZCETTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbZCETTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbZCETSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:18:38 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:33492 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794AbZCETSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:18:37 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 14/15] NULL noise: kernel/test_kprobes.c
Date: Thu, 05 Mar 2009 20:18:26 +0100
Message-ID: <20090305191822.30062.10652.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  kernel/test_kprobes.c:118:19: warning: Using plain integer as NULL pointer
  kernel/test_kprobes.c:213:22: warning: Using plain integer as NULL pointer
  kernel/test_kprobes.c:326:22: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

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

