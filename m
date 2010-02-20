Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab0BTAEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:20 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46309 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0BTAEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JeE1AcCLhqEMTWExyjo+evTo66teaZNwNFSX4+riBVij9AO7DmiRm0SnO8XJRpLZpG
         zaDUfAUKlNBhqNCfEfDP2VX3t0kJbj+CkOnGWBffQI7kVDA3Gv5QsXkuSVNQ00eUIprF
         LgdB19JJ7K6kqbfUOw4d+s/VD4fMXP1DdOBv4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 02/24] Rename .data.init_task to .data..init_task.
Date: Sat, 20 Feb 2010 01:03:35 +0100
Message-Id: <1266624237-22372-3-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@ksplice.com>

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/ia64/kernel/init_task.c      |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S |    4 +---
 include/asm-generic/vmlinux.lds.h |    4 ++--
 include/linux/init_task.h         |    2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/kernel/init_task.c b/arch/ia64/kernel/init_task.c
index e253ab8..f9efe97 100644
--- a/arch/ia64/kernel/init_task.c
+++ b/arch/ia64/kernel/init_task.c
@@ -23,7 +23,7 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
  * Initial task structure.
  *
  * We need to make sure that this is properly aligned due to the way process stacks are
- * handled. This is done by having a special ".data.init_task" section...
+ * handled. This is done by having a special ".data..init_task" section...
  */
 #define init_thread_info	init_task_mem.s.thread_info
 
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 3229c06..136dcf3 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -223,9 +223,7 @@ SECTIONS
 #endif
 
 	/* The initial task and kernel stack */
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		INIT_TASK_DATA(THREAD_SIZE)
-	}
+	INIT_TASK_DATA_SECTION(THREAD_SIZE)
 
 	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
 		PAGE_ALIGNED_DATA(PAGE_SIZE)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 78450aa..9cb9a90 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -193,7 +193,7 @@
 
 #define INIT_TASK_DATA(align)						\
 	. = ALIGN(align);						\
-	*(.data.init_task)
+	*(.data..init_task)
 
 /*
  * Read only Data
@@ -435,7 +435,7 @@
  */
 #define INIT_TASK_DATA_SECTION(align)					\
 	. = ALIGN(align);						\
-	.data.init_task : {						\
+	.data..init_task : {						\
 		INIT_TASK_DATA(align)					\
 	}
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index abec69b..f00253b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -191,7 +191,7 @@ extern struct cred init_cred;
 }
 
 /* Attach to the init_task data structure for proper alignment */
-#define __init_task_data __attribute__((__section__(".data.init_task")))
+#define __init_task_data __attribute__((__section__(".data..init_task")))
 
 
 #endif
-- 
1.6.2.4

