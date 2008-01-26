Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbYAZL4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbYAZL4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 06:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYAZLzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 06:55:36 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:5346 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701AbYAZLzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 06:55:33 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2008 11:54:07 +0000
Message-Id: <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <6a16d4a8c094a684aa76e898adf1d3e127daeedf.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
 <6a16d4a8c094a684aa76e898adf1d3e127daeedf.1201348185.git.ijc@hellion.org.uk>
In-Reply-To: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH 3/9] x86_64: Switch to .data.compressed in arch/x86/boot/compressed/vmlinux_64.scr
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the file identical to vmlinux_32.scr.

size shows an expected movement from .text to .data and 4 extra bytes
of padding.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/vmlinux_64.lds |    8 ++++++--
 arch/x86/boot/compressed/vmlinux_64.scr |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
index 8d63b3a..fe1baf5 100644
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
+	.data.compressed : {
+		*(.data.compressed)
+	}
+	.text :	{
 		_text = .; 	/* Text */
 		*(.text)
 		*(.text.*)
diff --git a/arch/x86/boot/compressed/vmlinux_64.scr b/arch/x86/boot/compressed/vmlinux_64.scr
index bd1429c..a549526 100644
--- a/arch/x86/boot/compressed/vmlinux_64.scr
+++ b/arch/x86/boot/compressed/vmlinux_64.scr
@@ -1,6 +1,6 @@
 SECTIONS
 {
-  .text.compressed : {
+  .data.compressed : {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
-- 
1.5.3.8

