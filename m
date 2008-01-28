Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbYA1IrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbYA1IrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYA1Iq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:46:27 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:6974 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755471AbYA1IqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:46:17 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2008 08:45:43 +0000
Message-Id: <1201509949-3285-4-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201509949-3285-3-git-send-email-ijc@hellion.org.uk>
References: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-3-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv2 3/9] x86_64: Switch to .rodata.compressed in arch/x86/boot/compressed/vmlinux_??.scr
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmlinux_64 and vmlinux_32.scr are now identical

size shows an expected movement from .text to .rodata and 4 extra bytes
of padding.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/vmlinux_32.lds |    4 ++--
 arch/x86/boot/compressed/vmlinux_32.scr |    2 +-
 arch/x86/boot/compressed/vmlinux_64.lds |    8 ++++++--
 arch/x86/boot/compressed/vmlinux_64.scr |    2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/vmlinux_32.lds b/arch/x86/boot/compressed/vmlinux_32.lds
index d98ab69..bb3c483 100644
--- a/arch/x86/boot/compressed/vmlinux_32.lds
+++ b/arch/x86/boot/compressed/vmlinux_32.lds
@@ -12,8 +12,8 @@ SECTIONS
 		*(.text.head)
 		_ehead = . ;
 	}
-	.data.compressed : {
-		*(.data.compressed)
+	.rodata.compressed : {
+		*(.rodata.compressed)
 	}
 	.text :	{
 		_text = .; 	/* Text */
diff --git a/arch/x86/boot/compressed/vmlinux_32.scr b/arch/x86/boot/compressed/vmlinux_32.scr
index a549526..f02382a 100644
--- a/arch/x86/boot/compressed/vmlinux_32.scr
+++ b/arch/x86/boot/compressed/vmlinux_32.scr
@@ -1,6 +1,6 @@
 SECTIONS
 {
-  .data.compressed : {
+  .rodata.compressed : {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
index 8d63b3a..f6e5b44 100644
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ b/arch/x86/boot/compressed/vmlinux_64.lds
@@ -7,11 +7,15 @@ SECTIONS
 	 * address 0.
 	 */
 	. = 0;
-	.text :	{
+	.text.head : {
 		_head = . ;
 		*(.text.head)
 		_ehead = . ;
-		*(.text.compressed)
+	}
+	.rodata.compressed : {
+		*(.rodata.compressed)
+	}
+	.text :	{
 		_text = .; 	/* Text */
 		*(.text)
 		*(.text.*)
diff --git a/arch/x86/boot/compressed/vmlinux_64.scr b/arch/x86/boot/compressed/vmlinux_64.scr
index bd1429c..f02382a 100644
--- a/arch/x86/boot/compressed/vmlinux_64.scr
+++ b/arch/x86/boot/compressed/vmlinux_64.scr
@@ -1,6 +1,6 @@
 SECTIONS
 {
-  .text.compressed : {
+  .rodata.compressed : {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
-- 
1.5.3.8

