Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZCMCfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZCMCfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZCMCeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:34:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:52467 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757755AbZCMCes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:34:48 -0400
Date: Fri, 13 Mar 2009 02:34:03 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B91103.76E4.0078.0@novell.com>
References: <49B91103.76E4.0078.0@novell.com>
Subject: [tip:x86/mm] x86: properly __init-annotate recent early_printk additions
Message-ID: <tip-9a50156a1c7bfa65315facaffdfbed6513fcfd3b@git.kernel.org>
Git-Commit-ID: 9a50156a1c7bfa65315facaffdfbed6513fcfd3b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:34:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a50156a1c7bfa65315facaffdfbed6513fcfd3b
Gitweb:     http://git.kernel.org/tip/9a50156a1c7bfa65315facaffdfbed6513fcfd3b
Author:     Jan Beulich <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 12:41:23 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:37:18 +0100

x86: properly __init-annotate recent early_printk additions

Impact: cleanup, save memory

Don't keep code resident that's only needed during startup.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B91103.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/early_printk.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 639ad98..335f049 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -250,7 +250,7 @@ static int dbgp_wait_until_complete(void)
 	return (ctrl & DBGP_ERROR) ? -DBGP_ERRCODE(ctrl) : DBGP_LEN(ctrl);
 }
 
-static void dbgp_mdelay(int ms)
+static void __init dbgp_mdelay(int ms)
 {
 	int i;
 
@@ -311,7 +311,7 @@ static void dbgp_set_data(const void *buf, int size)
 	writel(hi, &ehci_debug->data47);
 }
 
-static void dbgp_get_data(void *buf, int size)
+static void __init dbgp_get_data(void *buf, int size)
 {
 	unsigned char *bytes = buf;
 	u32 lo, hi;
@@ -355,7 +355,7 @@ static int dbgp_bulk_write(unsigned devnum, unsigned endpoint,
 	return ret;
 }
 
-static int dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
+static int __init dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
 				 int size)
 {
 	u32 pids, addr, ctrl;
@@ -386,8 +386,8 @@ static int dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
 	return ret;
 }
 
-static int dbgp_control_msg(unsigned devnum, int requesttype, int request,
-	int value, int index, void *data, int size)
+static int __init dbgp_control_msg(unsigned devnum, int requesttype,
+	int request, int value, int index, void *data, int size)
 {
 	u32 pids, addr, ctrl;
 	struct usb_ctrlrequest req;
@@ -489,7 +489,7 @@ static u32 __init find_dbgp(int ehci_num, u32 *rbus, u32 *rslot, u32 *rfunc)
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
@@ -557,13 +557,13 @@ static inline void dbgp_printk(const char *fmt, ...) { }
 
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
