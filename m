Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZFGOas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZFGOas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZFGOal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:30:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:64759 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZFGOak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=axyURUrxJ5YZYLsrM3k53VO1tao/XF/KMZXsKiGzDgN9BR44lwpks/+oTZUdxpbEJv
         n4AKEo5HvONVgF6RPROEqaREJ5WLO8NdscXgWGcyLWe38Ys251ZKgbqVINVbxHx2k/iS
         FvcieDMhq7HxelBT8kKGuTDZmuIwTwPCFMIxs=
Subject: [PATCH v2]X86:microcode: fix vfree()
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090607142118.GB21340@elte.hu>
References: <1244351929.3355.13.camel@myhost>
	 <20090607140113.GI12088@elte.hu> <1244384315.3402.5.camel@myhost>
	 <20090607142118.GB21340@elte.hu>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 22:30:36 +0800
Message-Id: <1244385036.3402.11.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfree() does its own 'NULL' check, so no need for check before
calling it.

In v2, remove the stray newline.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---  
arch/x86/kernel/microcode_amd.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..06fce9d 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -257,10 +257,8 @@ static int install_equiv_cpu_table(const u8 *buf)
 
 static void free_equiv_cpu_table(void)
 {
-	if (equiv_cpu_table) {
-		vfree(equiv_cpu_table);
-		equiv_cpu_table = NULL;
-	}
+	vfree(equiv_cpu_table);
+	equiv_cpu_table = NULL;
 }
 
 static int generic_load_microcode(int cpu, const u8 *data, size_t size)
@@ -293,8 +291,7 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 		mc_header = (struct microcode_header_amd *)mc;
 		if (get_matching_microcode(cpu, mc, new_rev)) {
-			if (new_mc)
-				vfree(new_mc);
+			vfree(new_mc);
 			new_rev = mc_header->patch_id;
 			new_mc  = mc;
 		} else
@@ -306,8 +303,7 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 	if (new_mc) {
 		if (!leftover) {
-			if (uci->mc)
-				vfree(uci->mc);
+			vfree(uci->mc);
 			uci->mc = new_mc;
 			pr_debug("microcode: CPU%d found a matching microcode "
 				 "update with version 0x%x (current=0x%x)\n",


