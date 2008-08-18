Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYHRX5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYHRX5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 19:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYHRX50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 19:57:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:30228 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYHRX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 19:57:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qcizBgarKMcuM+OtchaHNB5lTHfaFLGhGhjy9DuUBl7IO8Iv+viF6pq2Ii/WM2NcOA
         a++pUoCxPkZ5koZOKMXBtohhVmelJEGuN4XaKBu4mfW3MKFnMd+iP0BGZuN/bk6GoWJ/
         p6UKD3qWs8cHXeIs628GpqshSJk0o6rn337vA=
Subject: [PATCH] x86: early_printk.c trivial sparse fixes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 16:56:29 -0700
Message-Id: <1219103789.17033.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/early_printk.c:404:13: warning: incorrect type in assignment (different base types)
arch/x86/kernel/early_printk.c:404:13:    expected restricted __le16 [assigned] [usertype] wValue
arch/x86/kernel/early_printk.c:404:13:    got int [signed] value
arch/x86/kernel/early_printk.c:405:13: warning: incorrect type in assignment (different base types)
arch/x86/kernel/early_printk.c:405:13:    expected restricted __le16 [assigned] [usertype] wIndex
arch/x86/kernel/early_printk.c:405:13:    got int [signed] index
arch/x86/kernel/early_printk.c:406:14: warning: incorrect type in assignment (different base types)
arch/x86/kernel/early_printk.c:406:14:    expected restricted __le16 [assigned] [usertype] wLength
arch/x86/kernel/early_printk.c:406:14:    got int [signed] size
arch/x86/kernel/early_printk.c:845:16: warning: Using plain integer as NULL pointer
arch/x86/kernel/early_printk.c:992:13: warning: symbol 'enable_debug_console' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
On top of next-20080818

 arch/x86/kernel/early_printk.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 28155ac..825e913 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -401,9 +401,9 @@ static int dbgp_control_msg(unsigned devnum, int requesttype, int request,
 	/* Compute the control message */
 	req.bRequestType = requesttype;
 	req.bRequest = request;
-	req.wValue = value;
-	req.wIndex = index;
-	req.wLength = size;
+	req.wValue = cpu_to_le16(value);
+	req.wIndex = cpu_to_le16(index);
+	req.wLength = cpu_to_le16(size);
 
 	pids = DBGP_PID_SET(USB_PID_DATA0, USB_PID_SETUP);
 	addr = DBGP_EPADDR(devnum, 0);
@@ -842,7 +842,7 @@ static int __init early_dbgp_init(char *s)
 	ret = ehci_setup();
 	if (ret < 0) {
 		dbgp_printk("ehci_setup failed\n");
-		ehci_debug = 0;
+		ehci_debug = NULL;
 
 		return -1;
 	}
@@ -989,7 +989,7 @@ static int __init setup_early_printk(char *buf)
 	return 0;
 }
 
-void __init enable_debug_console(char *buf)
+static void __init enable_debug_console(char *buf)
 {
 #ifdef DBGP_DEBUG
 	struct console *old_early_console = NULL;
-- 
1.6.0.274.g8aacc



