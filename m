Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbYF3R5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbYF3R5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYF3R5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:57:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16881 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYF3R5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:57:06 -0400
Date: Mon, 30 Jun 2008 10:54:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] fork and exit: need to include iocontext.h
Message-Id: <20080630105458.7c95e195.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fork and exit build errors: they need to include iocontext.h:

linux-next-20080630/kernel/fork.c: In function 'copy_process':
linux-next-20080630/kernel/fork.c:1237: error: implicit declaration of function 'put_io_context'
linux-next-20080630/kernel/exit.c: In function 'do_exit':
linux-next-20080630/kernel/exit.c:992: error: implicit declaration of function 'exit_io_context'


Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/exit.c |    1 +
 kernel/fork.c |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20080630.orig/kernel/fork.c
+++ linux-next-20080630/kernel/fork.c
@@ -23,6 +23,7 @@
 #include <linux/sem.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/iocontext.h>
 #include <linux/key.h>
 #include <linux/binfmts.h>
 #include <linux/mman.h>
--- linux-next-20080630.orig/kernel/exit.c
+++ linux-next-20080630/kernel/exit.c
@@ -13,6 +13,7 @@
 #include <linux/personality.h>
 #include <linux/tty.h>
 #include <linux/mnt_namespace.h>
+#include <linux/iocontext.h>
 #include <linux/key.h>
 #include <linux/security.h>
 #include <linux/cpu.h>


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
