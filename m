Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab0BTAEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:53 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33964 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab0BTAEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hEE7pmxfoa6uy8CpmQUv5Ls51IqZSTVimyp98KvyVFJAY3aVekfPkg0f3MHUlURBar
         oyVfQwp2pBcdgzV3bp/znlVsfnO8t8MmyTaTnbM1EoyqBkAVOsuCbzo/CCDa0NWmhk/t
         g61PwXmSgeAJB7aMTTogNjTpCDD6rAK5uWSWw=
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
Subject: [PATCH 15/24] Rename .text.lock to .text..lock.
Date: Sat, 20 Feb 2010 01:03:48 +0100
Message-Id: <1266624237-22372-16-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 Documentation/mutex-design.txt      |    4 ++--
 arch/ia64/kernel/vmlinux.lds.S      |    4 ++--
 arch/m68knommu/kernel/vmlinux.lds.S |    2 +-
 include/linux/spinlock.h            |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/mutex-design.txt b/Documentation/mutex-design.txt
index aa60d1f..c91ccc0 100644
--- a/Documentation/mutex-design.txt
+++ b/Documentation/mutex-design.txt
@@ -66,14 +66,14 @@ of advantages of mutexes:
 
     c0377ccb <mutex_lock>:
     c0377ccb:       f0 ff 08                lock decl (%eax)
-    c0377cce:       78 0e                   js     c0377cde <.text.lock.mutex>
+    c0377cce:       78 0e                   js     c0377cde <.text..lock.mutex>
     c0377cd0:       c3                      ret
 
    the unlocking fastpath is equally tight:
 
     c0377cd1 <mutex_unlock>:
     c0377cd1:       f0 ff 00                lock incl (%eax)
-    c0377cd4:       7e 0f                   jle    c0377ce5 <.text.lock.mutex+0x7>
+    c0377cd4:       7e 0f                   jle    c0377ce5 <.text..lock.mutex+0x7>
     c0377cd6:       c3                      ret
 
  - 'struct mutex' semantics are well-defined and are enforced if
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 5c01d3c..e07218a 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -54,8 +54,8 @@ SECTIONS
   .text2 : AT(ADDR(.text2) - LOAD_OFFSET)
 	{ *(.text2) }
 #ifdef CONFIG_SMP
-  .text.lock : AT(ADDR(.text.lock) - LOAD_OFFSET)
-	{ *(.text.lock) }
+  .text..lock : AT(ADDR(.text..lock) - LOAD_OFFSET)
+	{ *(.text..lock) }
 #endif
   _etext = .;
 
diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 9f1784f..fd3df56 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -68,7 +68,7 @@ SECTIONS {
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
-        	*(.text.lock)
+		*(.text..lock)
 
 		. = ALIGN(16);          /* Exception table              */
 		__start___ex_table = .;
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 8608821..dd57af4 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -60,7 +60,7 @@
 /*
  * Must define these before including other files, inline functions need them
  */
-#define LOCK_SECTION_NAME ".text.lock."KBUILD_BASENAME
+#define LOCK_SECTION_NAME ".text..lock."KBUILD_BASENAME
 
 #define LOCK_SECTION_START(extra)               \
         ".subsection 1\n\t"                     \
-- 
1.6.2.4

