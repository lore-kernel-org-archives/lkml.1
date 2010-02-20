Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0BTAHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:07:25 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33964 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab0BTAEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LJjbIJ3jAlxI1lb+9vTRZq6E1s6kaEfHKAnHSg7DoBNKYVLBe+/BQrJ3GSzeSGmT15
         oa0osN6TKmHMgoUFOZCDRKghW5cHnVdElzj+aNUeJPBwuueRtPtWZUgeu6NLncEqYG9d
         dnLaSBBeVv2mSyZ7NClDN9Vgq702noTuHTAx0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 13/24] Rename .rodata.compressed to .rodata..compressed.
Date: Sat, 20 Feb 2010 01:03:46 +0100
Message-Id: <1266624237-22372-14-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/sh/boot/compressed/vmlinux.scr    |    2 +-
 arch/x86/boot/compressed/mkpiggy.c     |    2 +-
 arch/x86/boot/compressed/vmlinux.lds.S |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sh/boot/compressed/vmlinux.scr b/arch/sh/boot/compressed/vmlinux.scr
index f02382a..862d748 100644
--- a/arch/sh/boot/compressed/vmlinux.scr
+++ b/arch/sh/boot/compressed/vmlinux.scr
@@ -1,6 +1,6 @@
 SECTIONS
 {
-  .rodata.compressed : {
+  .rodata..compressed : {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index bcbd36c..5c22812 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -77,7 +77,7 @@ int main(int argc, char *argv[])
 	offs += 32*1024 + 18;	/* Add 32K + 18 bytes slack */
 	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
 
-	printf(".section \".rodata.compressed\",\"a\",@progbits\n");
+	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
 	printf(".globl z_input_len\n");
 	printf("z_input_len = %lu\n", ilen);
 	printf(".globl z_output_len\n");
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index a6f1a59..5ddabce 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -26,8 +26,8 @@ SECTIONS
 		HEAD_TEXT
 		_ehead = . ;
 	}
-	.rodata.compressed : {
-		*(.rodata.compressed)
+	.rodata..compressed : {
+		*(.rodata..compressed)
 	}
 	.text :	{
 		_text = .; 	/* Text */
-- 
1.6.2.4

