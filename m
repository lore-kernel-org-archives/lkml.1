Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZEHFQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZEHFQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZEHFQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:16:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:43196 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbZEHFQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:16:14 -0400
Date: Fri, 8 May 2009 05:15:38 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, tstarling@wikimedia.org
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       tstarling@wikimedia.org
In-Reply-To: <1241751101.6259.85.camel@yhuang-dev.sh.intel.com>
References: <1241751101.6259.85.camel@yhuang-dev.sh.intel.com>
Subject: [tip:x86/urgent] x86, kexec: fix crashdump panic with CONFIG_KEXEC_JUMP
Message-ID: <tip-6407df5ca54a511054200a1eb23f78f723ca1de4@git.kernel.org>
Git-Commit-ID: 6407df5ca54a511054200a1eb23f78f723ca1de4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 05:15:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6407df5ca54a511054200a1eb23f78f723ca1de4
Gitweb:     http://git.kernel.org/tip/6407df5ca54a511054200a1eb23f78f723ca1de4
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Fri, 8 May 2009 10:51:41 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 May 2009 22:01:05 -0700

x86, kexec: fix crashdump panic with CONFIG_KEXEC_JUMP

Tim Starling reported that crashdump will panic with kernel compiled
with CONFIG_KEXEC_JUMP due to null pointer deference in
machine_kexec_32.c: machine_kexec(), when deferencing
kexec_image. Refering to:

http://bugzilla.kernel.org/show_bug.cgi?id=13265

This patch fixes the BUG via replacing global variable reference:
kexec_image in machine_kexec() with local variable reference: image,
which is more appropriate, and will not be null.

Same BUG is in machine_kexec_64.c too, so fixed too in the same way.

[ Impact: fix crash on kexec ]

Reported-by: Tim Starling <tstarling@wikimedia.org>
Signed-off-by: Huang Ying <ying.huang@intel.com>
LKML-Reference: <1241751101.6259.85.camel@yhuang-dev.sh.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/kernel/machine_kexec_32.c |    4 ++--
 arch/x86/kernel/machine_kexec_64.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index e7368c1..c1c429d 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -194,7 +194,7 @@ void machine_kexec(struct kimage *image)
 				       unsigned int preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		save_processor_state();
 #endif
 
@@ -253,7 +253,7 @@ void machine_kexec(struct kimage *image)
 					   image->preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		restore_processor_state();
 #endif
 
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 89cea4d..84c3bf2 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -274,7 +274,7 @@ void machine_kexec(struct kimage *image)
 	int save_ftrace_enabled;
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		save_processor_state();
 #endif
 
@@ -333,7 +333,7 @@ void machine_kexec(struct kimage *image)
 				       image->preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		restore_processor_state();
 #endif
 
