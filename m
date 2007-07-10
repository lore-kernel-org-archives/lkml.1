Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbXGJDvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbXGJDvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbXGJDvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:51:43 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXGJDvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:51:42 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 30/33] Linker script for the new x86 setup code
Date: Mon,  9 Jul 2007 19:52:09 -0700
Message-Id: <1184039088816-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840389834063-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com>
 <11840377211519-git-send-email-hpa@zytor.com>
 <11840378261081-git-send-email-hpa@zytor.com>
 <11840379311574-git-send-email-hpa@zytor.com>
 <11840380363720-git-send-email-hpa@zytor.com>
 <11840381413065-git-send-email-hpa@zytor.com>
 <11840382473923-git-send-email-hpa@zytor.com>
 <11840383522914-git-send-email-hpa@zytor.com>
 <1184038457733-git-send-email-hpa@zytor.com>
 <1184038562864-git-send-email-hpa@zytor.com>
 <11840386682120-git-send-email-hpa@zytor.com>
 <11840387733386-git-send-email-hpa@zytor.com>
 <11840388782627-git-send-email-hpa@zytor.com>
 <11840389834063-git-send-email-hpa@zytor.com>
Message-Id: <fd5cf379a91de82890893de655876e39e78c1dc9.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
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

