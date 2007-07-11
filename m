Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbXGKTcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbXGKTcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760126AbXGKTUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:20:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763838AbXGKTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:44 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 30/33] Linker script for the new x86 setup code
Date: Wed, 11 Jul 2007 12:18:55 -0700
Message-Id: <11841815433079-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184181543792-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
 <1184181539416-git-send-email-hpa@zytor.com>
 <118418153972-git-send-email-hpa@zytor.com>
 <11841815391923-git-send-email-hpa@zytor.com>
 <11841815403678-git-send-email-hpa@zytor.com>
 <11841815403041-git-send-email-hpa@zytor.com>
 <11841815402349-git-send-email-hpa@zytor.com>
 <11841815401013-git-send-email-hpa@zytor.com>
 <1184181540369-git-send-email-hpa@zytor.com>
 <11841815401476-git-send-email-hpa@zytor.com>
 <11841815411443-git-send-email-hpa@zytor.com>
 <1184181541746-git-send-email-hpa@zytor.com>
 <11841815411436-git-send-email-hpa@zytor.com>
 <11841815412873-git-send-email-hpa@zytor.com>
 <11841815412175-git-send-email-hpa@zytor.com>
 <1184181541492-git-send-email-hpa@zytor.com>
 <11841815421028-git-send-email-hpa@zytor.com>
 <118418154292-git-send-email-hpa@zytor.com>
 <11841815421819-git-send-email-hpa@zytor.com>
 <11841815423652-git-send-email-hpa@zytor.com>
 <11841815422973-git-send-email-hpa@zytor.com>
 <11841815423976-git-send-email-hpa@zytor.com>
 <1184181543569-git-send-email-hpa@zytor.com>
 <11841815433948-git-send-email-hpa@zytor.com>
 <1184181543792-git-send-email-hpa@zytor.com>
Message-Id: <5024dde46d1d0a742fcdcfcbff6a1112cb6c4729.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Linker script to define the layout of the new x86 setup code.
Includes assert for size overflow and a misaligned setup header.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/setup.ld |   54 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/setup.ld

diff --git a/arch/i386/boot/setup.ld b/arch/i386/boot/setup.ld
new file mode 100644
index 0000000..df9234b
--- /dev/null
+++ b/arch/i386/boot/setup.ld
@@ -0,0 +1,54 @@
+/*
+ * setup.ld
+ *
+ * Linker script for the i386 setup code
+ */
+OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
+OUTPUT_ARCH(i386)
+ENTRY(_start)
+
+SECTIONS
+{
+	. = 0;
+	.bstext		: { *(.bstext) }
+	.bsdata		: { *(.bsdata) }
+
+	. = 497;
+	.header		: { *(.header) }
+	.inittext	: { *(.inittext) }
+	.initdata	: { *(.initdata) }
+	.text		: { *(.text*) }
+
+	. = ALIGN(16);
+	.rodata		: { *(.rodata*) }
+
+	.videocards	: {
+		video_cards = .;
+		*(.videocards)
+		video_cards_end = .;
+	}
+
+	. = ALIGN(16);
+	.data		: { *(.data*) }
+
+	.signature	: {
+		setup_sig = .;
+		LONG(0x5a5aaa55)
+	}
+
+
+	. = ALIGN(16);
+	.bss		:
+	{
+		__bss_start = .;
+		*(.bss)
+		__bss_end = .;
+	}
+	. = ALIGN(16);
+	_end = .;
+
+	/DISCARD/ : { *(.note*) }
+
+	. = ASSERT(_end <= 0x8000, "Setup too big!");
+	. = ASSERT(hdr == 0x1f1, "The setup header has the wrong offset!");
+}
-- 
1.5.2.2

