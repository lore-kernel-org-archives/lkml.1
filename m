Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXLJPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXLJPmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXLJPmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:42:10 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:24650
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbXLJPmJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:42:09 -0500
Message-Id: <475D6C91.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Dec 2007 15:42:57 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@redhat.com>
Cc: <olaf@aepfle.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: also define AT_VECTOR_SIZE_ARCH
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch introducing this left out x86-64, despite it also having
extra entries.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Olaf Hering <olaf@aepfle.de>

 include/asm-x86/system_64.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.24-rc4/include/asm-x86/system_64.h	2007-12-10 16:11:42.000000000 +0100
+++ 2.6.24-rc4-x86_64-at-vector-size/include/asm-x86/system_64.h	2007-12-04 16:09:33.000000000 +0100
@@ -7,6 +7,12 @@
 
 #ifdef __KERNEL__
 
+#ifdef CONFIG_IA32_EMULATION
+#define AT_VECTOR_SIZE_ARCH 2
+#else
+#define AT_VECTOR_SIZE_ARCH 1
+#endif
+
 #define __SAVE(reg,offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
 #define __RESTORE(reg,offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
 



