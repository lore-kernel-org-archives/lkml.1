Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbXGELvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbXGELvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbXGELu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:50:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339AbXGELuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:50:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Be (self-)consistent and use CONFIG_GDB_CONSOLE
	everywhere
To: torvalds@osdl.org, akpm@osdl.org, rpjday@mindspring.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 05 Jul 2007 12:50:48 +0100
Message-ID: <20070705115048.12625.64771.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Be (self-)consistent and use CONFIG_GDB_CONSOLE everywhere rather than using
CONFIG_GDBSTUB_CONSOLE in some places and not others.  This is also then
consistent with other archs.

Also remove the gdbstub condole device() op which doesn't seem to be necessary
now (especially as it doesn't compile).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/gdb-stub.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index 1e7a101..e89cad1 100644
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -647,17 +647,11 @@ void debug_to_serial(const char *p, int n)
 }
 #endif
 
-#ifdef CONFIG_GDBSTUB_CONSOLE
-
-static kdev_t gdbstub_console_dev(struct console *con)
-{
-	return MKDEV(1,3); /* /dev/null */
-}
+#ifdef CONFIG_GDB_CONSOLE
 
 static struct console gdbstub_console = {
 	.name	= "gdb",
 	.write	= gdbstub_console_write,	/* in break.S */
-	.device	= gdbstub_console_dev,
 	.flags	= CON_PRINTBUFFER,
 	.index	= -1,
 };
@@ -2021,7 +2015,7 @@ void __init gdbstub_init(void)
 	ptr = mem2hex(gdbstub_banner, ptr, sizeof(gdbstub_banner) - 1, 0);
 	gdbstub_send_packet(output_buffer);
 #endif
-#if defined(CONFIG_GDBSTUB_CONSOLE) && defined(CONFIG_GDBSTUB_IMMEDIATE)
+#if defined(CONFIG_GDB_CONSOLE) && defined(CONFIG_GDBSTUB_IMMEDIATE)
 	register_console(&gdbstub_console);
 #endif
 
@@ -2031,7 +2025,7 @@ void __init gdbstub_init(void)
 /*
  * register the console at a more appropriate time
  */
-#if defined (CONFIG_GDBSTUB_CONSOLE) && !defined(CONFIG_GDBSTUB_IMMEDIATE)
+#if defined (CONFIG_GDB_CONSOLE) && !defined(CONFIG_GDBSTUB_IMMEDIATE)
 static int __init gdbstub_postinit(void)
 {
 	printk("registering console\n");

