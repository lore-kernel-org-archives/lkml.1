Return-Path: <linux-kernel-owner+w=401wt.eu-S965088AbXCSW1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbXCSW1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965138AbXCSW1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:27:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39839 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965088AbXCSW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:27:53 -0400
Date: Mon, 19 Mar 2007 15:26:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: [PATCH] ptrace needs PROC_FS
Message-Id: <20070319152616.d0857587.randy.dunlap@oracle.com>
In-Reply-To: <20070319124007.4ab84e91.randy.dunlap@oracle.com>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
	<20070319124007.4ab84e91.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

CONFIG_PTRACE needs PROC_FS; with CONFIG_PROC_FS=n (x86_64):

  LD      .tmp_vmlinux1
kernel/built-in.o: In function `ptrace_start':
ptrace.c:(.text+0x300f9): undefined reference to `ptrace_may_attach'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21-rc3-mm2.orig/init/Kconfig
+++ linux-2.6.21-rc3-mm2/init/Kconfig
@@ -688,7 +688,7 @@ config UTRACE
 config PTRACE
 	bool "Legacy ptrace system call interface"
 	default y
-	depends on UTRACE
+	depends on UTRACE && PROC_FS
 	help
 	  Enable the ptrace system call.
 	  This is traditionally used by debuggers like GDB,
