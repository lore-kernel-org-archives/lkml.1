Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYAZLy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYAZLy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 06:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYAZLyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 06:54:46 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:13257 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbYAZLym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 06:54:42 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2008 11:54:08 +0000
Message-Id: <b639de14dbe3cf77f61a9ec0f9e23c50f179c18d.1201348185.git.ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
 <6a16d4a8c094a684aa76e898adf1d3e127daeedf.1201348185.git.ijc@hellion.org.uk>
 <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
In-Reply-To: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH 4/9] x86_64: Unify arch/x86/boot/compressed/vmlinux_??.scr
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The files are now identical so merge them.

size reports no change in arch/x86/boot/compressed/vmlinux.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/Makefile                  |    2 +-
 .../compressed/{vmlinux_32.scr => vmlinux.scr}     |    0 
 arch/x86/boot/compressed/vmlinux_64.scr            |   10 ----------
 3 files changed, 1 insertions(+), 11 deletions(-)
 rename arch/x86/boot/compressed/{vmlinux_32.scr => vmlinux.scr} (100%)
 delete mode 100644 arch/x86/boot/compressed/vmlinux_64.scr

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index d6ae347..baffeaf 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -59,5 +59,5 @@ LDFLAGS_piggy.o := -r --format binary --oformat elf64-x86-64 -T
 endif
 
 
-$(obj)/piggy.o: $(obj)/vmlinux_$(BITS).scr $(obj)/vmlinux.bin.gz FORCE
+$(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.gz FORCE
 	$(call if_changed,ld)
diff --git a/arch/x86/boot/compressed/vmlinux_32.scr b/arch/x86/boot/compressed/vmlinux.scr
similarity index 100%
rename from arch/x86/boot/compressed/vmlinux_32.scr
rename to arch/x86/boot/compressed/vmlinux.scr
diff --git a/arch/x86/boot/compressed/vmlinux_64.scr b/arch/x86/boot/compressed/vmlinux_64.scr
deleted file mode 100644
index a549526..0000000
--- a/arch/x86/boot/compressed/vmlinux_64.scr
+++ /dev/null
@@ -1,10 +0,0 @@
-SECTIONS
-{
-  .data.compressed : {
-	input_len = .;
-	LONG(input_data_end - input_data) input_data = .;
-	*(.data)
-	output_len = . - 4;
-	input_data_end = .;
-	}
-}
-- 
1.5.3.8

