Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbYIJPZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbYIJPZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYIJPZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:25:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:51782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYIJPZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:25:38 -0400
Date: Wed, 10 Sep 2008 08:25:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, vapier.adi@gmail.com
Subject: [PATCH] fastboot: fix blackfin breakage due to vmlinux.lds change
Message-ID: <20080910082534.12344a1c@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the patch below fixes the fastboot bug as reported by Mike Frysinger;
I've commited this to
git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot.git

Ingo, please also add to -tip


>From 16aeda33acbb711863d8fff78c15b32ad0d4aa89 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 10 Sep 2008 08:22:26 -0700
Subject: [PATCH] fastboot: fix blackfin breakage due to vmlinux.lds change

As reported by Mike Frysinger, the vmlinux.lds changes should
have used VMLINUX_SYMBOL()...

Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/asm-generic/vmlinux.lds.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 020c641..f32418f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -373,11 +373,11 @@
   	*(.initcall5s.init)						\
 	*(.initcallrootfs.init)						\
 	*(.initcall6s.init)						\
-	__async_initcall_start = .;					\
+	VMLINUX_SYMBOL(__async_initcall_start) = .;			\
 	*(.initcall6a.init)						\
-	__async_initcall_end = .;					\
+	VMLINUX_SYMBOL(__async_initcall_end) = .;			\
   	*(.initcall6.init)						\
-	__device_initcall_end = .;					\
+	VMLINUX_SYMBOL(__device_initcall_end) = .;			\
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
-- 
1.5.5.1




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
