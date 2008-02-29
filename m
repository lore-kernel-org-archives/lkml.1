Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYB2MZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYB2MZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbYB2MZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:25:39 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:6775 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbYB2MZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:25:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=tFRIGtg7nawoH3J+jev+7vLOIBSotC8g3BbxowdtIVtv2HWkyp9Rs+Ze9v0U5MH91YjYM7WLb+Z+4SnGMdvvNrlHXicBi4Q7Ccc5cKhuzPLsP/HXbYh002AzLpyJJSipItnoqQuFfaCEZ2Og4DdRCzG5kco7YL78SPQ/igyUI8w=
Date: Fri, 29 Feb 2008 13:25:30 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86: coding style fixes to
 arch/x86/kernel/early_printk.c
Message-ID: <20080229132530.40dfaa27@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 17 errors, 3 warnings, 254 lines checked

After:
total: 2 errors, 3 warnings, 254 lines checked

paolo@paolo-desktop:/tmp/b$ md5sum *
da32f5cd8f248970e4809e1005393e95  early_printk.o.after
da32f5cd8f248970e4809e1005393e95  early_printk.o.before

paolo@paolo-desktop:/tmp/b$ size *
   text    data     bss     dec     hex filename
   1172     280      12    1464     5b8 early_printk.o.after
   1172     280      12    1464     5b8 early_printk.o.befor

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/early_printk.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index cff84cd..a8f965d 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -108,12 +108,12 @@ static __init void early_serial_init(char *s)
 
 	if (*s) {
 		unsigned port;
-		if (!strncmp(s,"0x",2)) {
+		if (!strncmp(s, "0x", 2)) {
 			early_serial_base = simple_strtoul(s, &e, 16);
 		} else {
 			static int bases[] = { 0x3f8, 0x2f8 };
 
-			if (!strncmp(s,"ttyS",4))
+			if (!strncmp(s, "ttyS", 4))
 				s += 4;
 			port = simple_strtoul(s, &e, 10);
 			if (port > 1 || s == e)
@@ -202,9 +202,9 @@ void early_printk(const char *fmt, ...)
 	int n;
 	va_list ap;
 
-	va_start(ap,fmt);
-	n = vscnprintf(buf,512,fmt,ap);
-	early_console->write(early_console,buf,n);
+	va_start(ap, fmt);
+	n = vscnprintf(buf, 512, fmt, ap);
+	early_console->write(early_console, buf, n);
 	va_end(ap);
 }
 
@@ -229,15 +229,15 @@ static int __init setup_early_printk(char *buf)
 		early_serial_init(buf);
 		early_console = &early_serial_console;
 	} else if (!strncmp(buf, "vga", 3)
-	           && boot_params.screen_info.orig_video_isVGA == 1) {
+		&& boot_params.screen_info.orig_video_isVGA == 1) {
 		max_xpos = boot_params.screen_info.orig_video_cols;
 		max_ypos = boot_params.screen_info.orig_video_lines;
 		current_ypos = boot_params.screen_info.orig_y;
 		early_console = &early_vga_console;
- 	} else if (!strncmp(buf, "simnow", 6)) {
- 		simnow_init(buf + 6);
- 		early_console = &simnow_console;
- 		keep_early = 1;
+	} else if (!strncmp(buf, "simnow", 6)) {
+		simnow_init(buf + 6);
+		early_console = &simnow_console;
+		keep_early = 1;
 #ifdef CONFIG_HVC_XEN
 	} else if (!strncmp(buf, "xen", 3)) {
 		early_console = &xenboot_console;
-- 
1.5.4.2.316.gf7a7

