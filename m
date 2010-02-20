Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0BTAEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:48 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:53472 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0BTAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dCTKv68tinbf3KNcpdlgjN/BnTkDehhzMW1Teg3ft4pKXALFlOpOXny+UcMj8cdPOq
         wdy3aj9Zkps/C86+OeENue/vFegLbugk9jsOUSycSqt3H4Jraapjky7CVHsJPvoc7w6t
         ziMp8MfYicM+dD9txGlSws97eLQAXxPbHTdS0=
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
Subject: [PATCH 07/24] Rename .data.gate to .data..gate.
Date: Sat, 20 Feb 2010 01:03:40 +0100
Message-Id: <1266624237-22372-8-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/ia64/kernel/Makefile.gate |    2 +-
 arch/ia64/kernel/gate-data.S   |    2 +-
 arch/ia64/kernel/vmlinux.lds.S |    4 ++--
 arch/ia64/xen/gate-data.S      |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/Makefile.gate b/arch/ia64/kernel/Makefile.gate
index ab9b03a..ceeffc5 100644
--- a/arch/ia64/kernel/Makefile.gate
+++ b/arch/ia64/kernel/Makefile.gate
@@ -21,7 +21,7 @@ GATECFLAGS_gate-syms.o = -r
 $(obj)/gate-syms.o: $(obj)/gate.lds $(obj)/gate.o FORCE
 	$(call if_changed,gate)
 
-# gate-data.o contains the gate DSO image as data in section .data.gate.
+# gate-data.o contains the gate DSO image as data in section .data..gate.
 # We must build gate.so before we can assemble it.
 # Note: kbuild does not track this dependency due to usage of .incbin
 $(obj)/gate-data.o: $(obj)/gate.so
diff --git a/arch/ia64/kernel/gate-data.S b/arch/ia64/kernel/gate-data.S
index 258c0a3..b3ef1c7 100644
--- a/arch/ia64/kernel/gate-data.S
+++ b/arch/ia64/kernel/gate-data.S
@@ -1,3 +1,3 @@
-	.section .data.gate, "aw"
+	.section .data..gate, "aw"
 
 	.incbin "arch/ia64/kernel/gate.so"
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 7fb1198..3e33809 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -180,12 +180,12 @@ SECTIONS
 	PAGE_ALIGNED_DATA(PAGE_SIZE)
 	  . = ALIGN(PAGE_SIZE);
 	  __start_gate_section = .;
-	  *(.data.gate)
+	  *(.data..gate)
 	  __stop_gate_section = .;
 #ifdef CONFIG_XEN
 	  . = ALIGN(PAGE_SIZE);
 	  __xen_start_gate_section = .;
-	  *(.data.gate.xen)
+	  *(.data..gate.xen)
 	  __xen_stop_gate_section = .;
 #endif
 	}
diff --git a/arch/ia64/xen/gate-data.S b/arch/ia64/xen/gate-data.S
index 7d4830a..6f95b6b 100644
--- a/arch/ia64/xen/gate-data.S
+++ b/arch/ia64/xen/gate-data.S
@@ -1,3 +1,3 @@
-	.section .data.gate.xen, "aw"
+	.section .data..gate.xen, "aw"
 
 	.incbin "arch/ia64/xen/gate.so"
-- 
1.6.2.4

