Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab0BTAEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:45 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46309 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab0BTAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BMhJOq+NbkM9fJfLSf6dnxVxeYMWb+6cYn5SoMtYkU7P/BXRiC8PEE1ixnlOM89QJr
         3s9/KX5PCSGVu7tcPolYrN9xx6w5W6lPQo88nit8oYOHfi6vl+CjFanmQTbV4mFeMu2d
         w1urETOsdtmRmv8GRCyPEyeaGXczP8qPdxLcw=
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
Subject: [PATCH 08/24] Rename .data.init_irqstack to .data..init_irqstack.
Date: Sat, 20 Feb 2010 01:03:41 +0100
Message-Id: <1266624237-22372-9-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/um/kernel/dyn.lds.S   |    2 +-
 arch/um/kernel/init_task.c |    2 +-
 arch/um/kernel/uml.lds.S   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 7fcad58..6926801 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -94,7 +94,7 @@ SECTIONS
   .data           : {
     INIT_TASK_DATA(KERNEL_STACK_SIZE)
     . = ALIGN(KERNEL_STACK_SIZE);
-    *(.data.init_irqstack)
+    *(.data..init_irqstack)
     DATA_DATA
     *(.data.* .gnu.linkonce.d.*)
     SORT(CONSTRUCTORS)
diff --git a/arch/um/kernel/init_task.c b/arch/um/kernel/init_task.c
index 8aa77b6..ddc9698 100644
--- a/arch/um/kernel/init_task.c
+++ b/arch/um/kernel/init_task.c
@@ -34,5 +34,5 @@ union thread_union init_thread_union __init_task_data =
 	{ INIT_THREAD_INFO(init_task) };
 
 union thread_union cpu0_irqstack
-	__attribute__((__section__(".data.init_irqstack"))) =
+	__attribute__((__section__(".data..init_irqstack"))) =
 		{ INIT_THREAD_INFO(init_task) };
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index e7a6cca..ec63785 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -50,7 +50,7 @@ SECTIONS
   {
     INIT_TASK_DATA(KERNEL_STACK_SIZE)
     . = ALIGN(KERNEL_STACK_SIZE);
-    *(.data.init_irqstack)
+    *(.data..init_irqstack)
     DATA_DATA
     *(.gnu.linkonce.d*)
     CONSTRUCTORS
-- 
1.6.2.4

