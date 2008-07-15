Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYGOUp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYGOUp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762367AbYGOUox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:44:53 -0400
Received: from gw.goop.org ([64.81.55.164]:47262 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763433AbYGOUov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:44:51 -0400
Message-ID: <487D0BBA.8010602@goop.org>
Date: Tue, 15 Jul 2008 13:42:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH] xen: report hypervisor version
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various versions of the hypervisor have differences in what ABIs and
features they support.  Print some details into the boot log to help
with remote debugging.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -168,10 +168,14 @@ void xen_vcpu_restore(void)
 
 static void __init xen_banner(void)
 {
+	unsigned version = HYPERVISOR_xen_version(XENVER_version, NULL);
+	struct xen_extraversion extra;
+	HYPERVISOR_xen_version(XENVER_extraversion, &extra);
+
 	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
 	       pv_info.name);
-	printk(KERN_INFO "Hypervisor signature: %s%s\n",
-	       xen_start_info->magic,
+	printk(KERN_INFO "Xen version: %d.%d%s%s\n",
+	       version >> 16, version & 0xffff, extra.extraversion,
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
 }
 



