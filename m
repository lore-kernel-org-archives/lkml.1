Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZFGOnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZFGOnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZFGOnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:43:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:52872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbZFGOnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:43:11 -0400
Date: Sun, 7 Jun 2009 14:42:44 GMT
From: "tip-bot for Figo.zhang" <figo1802@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       figo1802@gmail.com, dmitry.adamushko@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       figo1802@gmail.com, dmitry.adamushko@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1244385036.3402.11.camel@myhost>
References: <1244385036.3402.11.camel@myhost>
Subject: [tip:x86/microcode] x86, microcode: Simplify vfree() use
Message-ID: <tip-aeef50bc0483fa70ce0bddb686ec84a274b7f3d4@git.kernel.org>
Git-Commit-ID: aeef50bc0483fa70ce0bddb686ec84a274b7f3d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 14:42:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aeef50bc0483fa70ce0bddb686ec84a274b7f3d4
Gitweb:     http://git.kernel.org/tip/aeef50bc0483fa70ce0bddb686ec84a274b7f3d4
Author:     Figo.zhang <figo1802@gmail.com>
AuthorDate: Sun, 7 Jun 2009 22:30:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 16:35:11 +0200

x86, microcode: Simplify vfree() use

vfree() does its own 'NULL' check, so no need for check before
calling it.

In v2, remove the stray newline.

[ Impact: cleanup ]

Signed-off-by: Figo.zhang <figo1802@gmail.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
LKML-Reference: <1244385036.3402.11.camel@myhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/microcode_amd.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index c8be20f..366baa1 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -241,10 +241,8 @@ static int install_equiv_cpu_table(const u8 *buf)
 
 static void free_equiv_cpu_table(void)
 {
-	if (equiv_cpu_table) {
-		vfree(equiv_cpu_table);
-		equiv_cpu_table = NULL;
-	}
+	vfree(equiv_cpu_table);
+	equiv_cpu_table = NULL;
 }
 
 static enum ucode_state
@@ -279,8 +277,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 		mc_header = (struct microcode_header_amd *)mc;
 		if (get_matching_microcode(cpu, mc, new_rev)) {
-			if (new_mc)
-				vfree(new_mc);
+			vfree(new_mc);
 			new_rev = mc_header->patch_id;
 			new_mc  = mc;
 		} else
@@ -292,8 +289,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 	if (new_mc) {
 		if (!leftover) {
-			if (uci->mc)
-				vfree(uci->mc);
+			vfree(uci->mc);
 			uci->mc = new_mc;
 			pr_debug("microcode: CPU%d found a matching microcode "
 				 "update with version 0x%x (current=0x%x)\n",
