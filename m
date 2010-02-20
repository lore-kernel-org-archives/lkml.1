Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0BTAGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:06:15 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33964 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab0BTAE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ujloUt7BjKZTc2rf6v5j88ejr6ffGWcDf0nOOoNztZTyGvIAqaEJqseQxrrTXaT70y
         fbHEG0z2o6ZUsRX153l/uwwP+DiY/8tOQfJXAw2O/6eoXFuYAUcC0s5T/HOpnZ44wSJt
         wUN8EmYvkeCQ408oS7Rs2uvXYX1PcJfJqk4QE=
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
Subject: [PATCH 19/24] Rename .data.nosave to .data..nosave.
Date: Sat, 20 Feb 2010 01:03:52 +0100
Message-Id: <1266624237-22372-20-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/s390/kernel/swsusp_asm64.S   |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/init.h              |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/swsusp_asm64.S b/arch/s390/kernel/swsusp_asm64.S
index 0c26cc1..e5cd623 100644
--- a/arch/s390/kernel/swsusp_asm64.S
+++ b/arch/s390/kernel/swsusp_asm64.S
@@ -261,7 +261,7 @@ restore_registers:
 	lghi	%r2,0
 	br	%r14
 
-	.section .data.nosave,"aw",@progbits
+	.section .data..nosave,"aw",@progbits
 	.align	8
 .Ldisabled_wait_31:
 	.long  0x000a0000,0x00000000
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 6f6da4f..ea36605 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -175,7 +175,7 @@
 #define NOSAVE_DATA							\
 	. = ALIGN(PAGE_SIZE);						\
 	VMLINUX_SYMBOL(__nosave_begin) = .;				\
-	*(.data.nosave)							\
+	*(.data..nosave)						\
 	. = ALIGN(PAGE_SIZE);						\
 	VMLINUX_SYMBOL(__nosave_end) = .;
 
diff --git a/include/linux/init.h b/include/linux/init.h
index ab1d31f..de99430 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -301,7 +301,7 @@ void __init parse_early_options(char *cmdline);
 #endif
 
 /* Data marked not to be saved by software suspend */
-#define __nosavedata __section(.data.nosave)
+#define __nosavedata __section(.data..nosave)
 
 /* This means "can be init if no module support, otherwise module load
    may call it." */
-- 
1.6.2.4

