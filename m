Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbYB2M1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbYB2M1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbYB2M1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:27:04 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:51896 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbYB2M1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:27:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=RqztGm5cJtoFhCB1lvRgMx5g5xIOjFXhZ1pHVXmj8/qCtNsgnpdRLRYHqCdpuaIKGY16OudQdPGw/ezUwxU3NTHx+14oztfXfXh38Za8RLW7WJ3kQnepRDzRg4NyN+paWr9RSxVWdxjEa/da/7TJrbQGUawmGCGD2IlAu8i9J90=
Date: Fri, 29 Feb 2008 13:26:56 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86: coding style fixes to x86/kernel/early_printk.c
Message-ID: <20080229132656.3a64f50a@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depends on:
[PATCH 2/3] x86: coding style fixes to arch/x86/kernel/early_printk.c

Remove two:
ERROR: do not initialise statics to 0 or NULL

This patch is changing the binary output:

paolo@paolo-desktop:/tmp/c$ size *
   text    data     bss     dec     hex filename
   1172     280      12    1464     5b8 early_printk.o.after
   1172     280      12    1464     5b8 early_printk.o.before

paolo@paolo-desktop:/tmp/c$ md5sum *
dad9a9a881e0eeda62cc5645bd3d7cad  early_printk.o.after
da32f5cd8f248970e4809e1005393e95  early_printk.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/early_printk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index a8f965d..643fd86 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -13,7 +13,7 @@
 #define VGABASE		(__ISA_IO_base + 0xb8000)
 
 static int max_ypos = 25, max_xpos = 80;
-static int current_ypos = 25, current_xpos = 0;
+static int current_ypos = 25, current_xpos;
 
 static void early_vga_write(struct console *con, const char *str, unsigned n)
 {
@@ -194,7 +194,7 @@ static struct console simnow_console = {
 
 /* Direct interface for emergencies */
 static struct console *early_console = &early_vga_console;
-static int early_console_initialized = 0;
+static int early_console_initialized;
 
 void early_printk(const char *fmt, ...)
 {
-- 
1.5.4.2.316.gf7a7

