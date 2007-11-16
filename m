Return-Path: <linux-kernel-owner+w=401wt.eu-S934565AbXKPCfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbXKPCfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934345AbXKPCey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:34:54 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35284 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934275AbXKPCex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:34:53 -0500
Message-Id: <473D016A.7010107@mxs.nes.nec.co.jp>
Date: Fri, 16 Nov 2007 11:33:14 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH 3/5] Add "VMCOREINFO_" to all the call for vmcoreinfo_append_str()
References: <473CFE14.3010400@mxs.nes.nec.co.jp>
In-Reply-To: <473CFE14.3010400@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


For readability, all the calls to vmcoreinfo_append_str() are changed to macros
having a prefix "VMCOREINFO_".

This discussion is the following:
http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0584.html

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
---
diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
--- a/include/linux/kexec.h	2007-11-12 11:04:09.000000000 +0900
+++ b/include/linux/kexec.h	2007-11-12 11:04:22.000000000 +0900
@@ -127,6 +127,10 @@ void vmcoreinfo_append_str(const char *f
 	__attribute__ ((format (printf, 1, 2)));
 unsigned long paddr_vmcoreinfo_note(void);
 
+#define VMCOREINFO_OSRELEASE(name) \
+	vmcoreinfo_append_str("OSRELEASE=%s\n", #name)
+#define VMCOREINFO_PAGESIZE(value) \
+	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
 #define VMCOREINFO_SYMBOL(name) \
 	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
 #define VMCOREINFO_SIZE(name) \
diff -rpuN a/kernel/kexec.c b/kernel/kexec.c
--- a/kernel/kexec.c	2007-11-12 11:04:11.000000000 +0900
+++ b/kernel/kexec.c	2007-11-12 11:04:22.000000000 +0900
@@ -1361,8 +1361,8 @@ unsigned long __attribute__ ((weak)) pad
 
 static int __init crash_save_vmcoreinfo_init(void)
 {
-	vmcoreinfo_append_str("OSRELEASE=%s\n", init_uts_ns.name.release);
-	vmcoreinfo_append_str("PAGESIZE=%ld\n", PAGE_SIZE);
+	VMCOREINFO_OSRELEASE(init_uts_ns.name.release);
+	VMCOREINFO_PAGESIZE(PAGE_SIZE);
 
 	VMCOREINFO_SYMBOL(init_uts_ns);
 	VMCOREINFO_SYMBOL(node_online_map);
_


