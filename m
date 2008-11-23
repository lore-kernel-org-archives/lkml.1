Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbYKWTub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbYKWTub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYKWTtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:49:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2614 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYKWTty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:49:54 -0500
Message-ID: <154e089b0811231149qcb31d00r5b28d55f81b8e6d0@mail.gmail.com>
Date: Sun, 23 Nov 2008 20:49:52 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: microcode: fix sparse warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make global variables and a function static

Fix following sparse warnings:

arch/x86/kernel/microcode_core.c:102:22: warning: symbol
'microcode_ops' was not declared. Should it be static?
arch/x86/kernel/microcode_core.c:206:24: warning: symbol
'microcode_pdev' was not declared. Should it be static?
arch/x86/kernel/microcode_core.c:322:6: warning: symbol
'microcode_update_cpu' was not declared. Should it be static?
arch/x86/kernel/microcode_intel.c:468:22: warning: symbol
'microcode_intel_ops' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
Last patch for tonight ;-)

Best
Hannes

 arch/x86/kernel/microcode_core.c  |    6 +++---
 arch/x86/kernel/microcode_intel.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 82fb280..5b711a5 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -99,7 +99,7 @@ MODULE_LICENSE("GPL");

 #define MICROCODE_VERSION 	"2.00"

-struct microcode_ops *microcode_ops;
+static struct microcode_ops *microcode_ops;

 /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
 static DEFINE_MUTEX(microcode_mutex);
@@ -203,7 +203,7 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 #endif

 /* fake device for request_firmware */
-struct platform_device *microcode_pdev;
+static struct platform_device *microcode_pdev;

 static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
@@ -319,7 +319,7 @@ static int microcode_resume_cpu(int cpu)
 	return 0;
 }

-void microcode_update_cpu(int cpu)
+static void microcode_update_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	int err = 0;
diff --git a/arch/x86/kernel/microcode_intel.c
b/arch/x86/kernel/microcode_intel.c
index 622dc4a..c34c820 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -465,7 +465,7 @@ static void microcode_fini_cpu(int cpu)
 	uci->mc = NULL;
 }

-struct microcode_ops microcode_intel_ops = {
+static struct microcode_ops microcode_intel_ops = {
 	.request_microcode_user		  = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info,
