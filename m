Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZCLMkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZCLMkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZCLMkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:40:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37548 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZCLMkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:40:45 -0400
Message-Id: <49B91103.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 12:41:23 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: properly __init-annotate recent early_printk
	 additions
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Don't keep code resident that's only needed during startup.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/early_printk.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- linux-2.6.29-rc7/arch/x86/kernel/early_printk.c	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-x86-earlyprintk-init/arch/x86/kernel/early_printk.c	2009-03-06 10:24:22.000000000 +0100
@@ -250,7 +250,7 @@ static int dbgp_wait_until_complete(void
 	return (ctrl & DBGP_ERROR) ? -DBGP_ERRCODE(ctrl) : DBGP_LEN(ctrl);
 }
 
-static void dbgp_mdelay(int ms)
+static void __init dbgp_mdelay(int ms)
 {
 	int i;
 
@@ -311,7 +311,7 @@ static void dbgp_set_data(const void *bu
 	writel(hi, &ehci_debug->data47);
 }
 
-static void dbgp_get_data(void *buf, int size)
+static void __init dbgp_get_data(void *buf, int size)
 {
 	unsigned char *bytes = buf;
 	u32 lo, hi;
@@ -355,7 +355,7 @@ static int dbgp_bulk_write(unsigned devn
 	return ret;
 }
 
-static int dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
+static int __init dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
 				 int size)
 {
 	u32 pids, addr, ctrl;
@@ -386,8 +386,8 @@ static int dbgp_bulk_read(unsigned devnu
 	return ret;
 }
 
-static int dbgp_control_msg(unsigned devnum, int requesttype, int request,
-	int value, int index, void *data, int size)
+static int __init dbgp_control_msg(unsigned devnum, int requesttype,
+	int request, int value, int index, void *data, int size)
 {
 	u32 pids, addr, ctrl;
 	struct usb_ctrlrequest req;
@@ -489,7 +489,7 @@ static u32 __init find_dbgp(int ehci_num
 	return 0;
 }
 
-static int ehci_reset_port(int port)
+static int __init ehci_reset_port(int port)
 {
 	u32 portsc;
 	u32 delay_time, delay;
@@ -532,7 +532,7 @@ static int ehci_reset_port(int port)
 	return -EBUSY;
 }
 
-static int ehci_wait_for_port(int port)
+static int __init ehci_wait_for_port(int port)
 {
 	u32 status;
 	int ret, reps;
@@ -557,13 +557,13 @@ static inline void dbgp_printk(const cha
 
 typedef void (*set_debug_port_t)(int port);
 
-static void default_set_debug_port(int port)
+static void __init default_set_debug_port(int port)
 {
 }
 
-static set_debug_port_t set_debug_port = default_set_debug_port;
+static set_debug_port_t __initdata set_debug_port = default_set_debug_port;
 
-static void nvidia_set_debug_port(int port)
+static void __init nvidia_set_debug_port(int port)
 {
 	u32 dword;
 	dword = read_pci_config(ehci_dev.bus, ehci_dev.slot, ehci_dev.func,



