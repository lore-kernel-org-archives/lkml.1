Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976Ab0AXQLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0AXQLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949Ab0AXQLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:11:44 -0500
Received: from mail-qy0-f182.google.com ([209.85.221.182]:40828 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0AXQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:11:43 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jan 2010 11:11:42 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VQVSWb4ImtImoUUhtFgF1IxlcemQmgLMwJPLWQL6TDV7wkN8YGl1q2yR8XO14LA5ya
         3cpCeCAO+WV7vj/dNZ9FGbSv+CWgAbVhCo7hHMmGDMZqjjc0IB7ABUtMgTRH52aaghbW
         TVsk/5P8Ds37gqhsMaemGa/15TeT+YRqW8ZUI=
From: Thiago Farina <tfransosi@gmail.com>
To: tfransosi@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] kernel/test_kprobes.c: fix "integer as NULL pointer" warning.
Date: Sun, 24 Jan 2010 11:03:49 -0500
Message-Id: <1264349038-1766-2-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.1.383.g5a9f
In-Reply-To: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/test_kprobes.c:118:19: warning: Using plain integer as NULL pointer
kernel/test_kprobes.c:213:22: warning: Using plain integer as NULL pointer
kernel/test_kprobes.c:326:22: warning: Using plain integer as NULL pointer

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
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
-- 
1.6.6.1.383.g5a9f

