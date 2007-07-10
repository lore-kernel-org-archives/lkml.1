Return-Path: <linux-kernel-owner+w=401wt.eu-S1762420AbXGJDNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762420AbXGJDNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbXGJDNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:13:10 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbXGJDNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:13:08 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 08/33] Define zero-page offset 0x1e4 as a scratch field, and use it
Date: Mon,  9 Jul 2007 19:51:47 -0700
Message-Id: <11840367741994-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840366692770-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
Message-Id: <a8e9d4bffc9fa216d32c930606475fd8d1df9405.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

The relocatable kernel code needs a scratch field for the decompressor
to determine its own location.  It was using a location inside
struct screen_info; reserve a free location and document it as scratch
instead.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/i386/zero-page.txt   |    1 +
 arch/i386/boot/compressed/head.S   |    6 +++---
 arch/x86_64/boot/compressed/head.S |    6 +++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/i386/zero-page.txt b/Documentation/i386/zero-page.txt
index c04a421..75b3680 100644
--- a/Documentation/i386/zero-page.txt
+++ b/Documentation/i386/zero-page.txt
@@ -37,6 +37,7 @@ Offset	Type		Description
 0x1d0	unsigned long	EFI memory descriptor map pointer
 0x1d4	unsigned long	EFI memory descriptor map size
 0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
+0x1e4	unsigned long	Scratch field for the kernel setup code
 0x1e8	char		number of entries in E820MAP (below)
 0x1e9	unsigned char	number of entries in EDDBUF (below)
 0x1ea	unsigned char	number of entries in EDD_MBR_SIG_BUFFER (below)
diff --git a/arch/i386/boot/compressed/head.S b/arch/i386/boot/compressed/head.S
index 3517a32..f35ea22 100644
--- a/arch/i386/boot/compressed/head.S
+++ b/arch/i386/boot/compressed/head.S
@@ -45,10 +45,10 @@ startup_32:
  * at and where we were actually loaded at.  This can only be done
  * with a short local call on x86.  Nothing  else will tell us what
  * address we are running at.  The reserved chunk of the real-mode
- * data at 0x34-0x3f are used as the stack for this calculation.
- * Only 4 bytes are needed.
+ * data at 0x1e4 (defined as a scratch field) are used as the stack
+ * for this calculation. Only 4 bytes are needed.
  */
-	leal 0x40(%esi), %esp
+	leal (0x1e4+4)(%esi), %esp
 	call 1f
 1:	popl %ebp
 	subl $1b, %ebp
diff --git a/arch/x86_64/boot/compressed/head.S b/arch/x86_64/boot/compressed/head.S
index f9d5692..1312bfa 100644
--- a/arch/x86_64/boot/compressed/head.S
+++ b/arch/x86_64/boot/compressed/head.S
@@ -46,10 +46,10 @@ startup_32:
  * at and where we were actually loaded at.  This can only be done
  * with a short local call on x86.  Nothing  else will tell us what
  * address we are running at.  The reserved chunk of the real-mode
- * data at 0x34-0x3f are used as the stack for this calculation.
- * Only 4 bytes are needed.
+ * data at 0x1e4 (defined as a scratch field) are used as the stack
+ * for this calculation. Only 4 bytes are needed.
  */
-	leal	0x40(%esi), %esp
+	leal	(0x1e4+4)(%esi), %esp
 	call	1f
 1:	popl	%ebp
 	subl	$1b, %ebp
-- 
1.5.2.2

