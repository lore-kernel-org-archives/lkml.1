Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbXEQCVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbXEQCVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 22:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXEQCV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 22:21:26 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:13069 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbXEQCVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 22:21:25 -0400
Date: Wed, 16 May 2007 19:19:20 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH]x86_64: early_print kernel console should send CRLF not LFCR
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       rmk@arm.linux.org.uk
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai.Lu@Sun.COM
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200705161919.21304.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH]x86_64: early_print kernel console should send CRLF not LFCR

   in 
	commit d358788f3f30113e49882187d794832905e42592
	Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
	Date:   Mon Mar 20 20:00:09 2006 +0000

    Glen Turner reported that writing LFCR rather than the more
    traditional CRLF causes issues with some terminals.

    Since this aflicts many serial drivers, extract the common code
    to a library function (uart_console_write) and arrange for each
    driver to supply a "putchar" function.

    but early_printk is left out. 

    Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
    Cc: Andi Kleen <ak@suse.de>
    Cc: Russell King <rmk@arm.linux.org.uk>

diff --git a/arch/x86_64/kernel/early_printk.c b/arch/x86_64/kernel/early_printk.c
index 56eaa25..296d2b0 100644
--- a/arch/x86_64/kernel/early_printk.c
+++ b/arch/x86_64/kernel/early_printk.c
@@ -91,9 +91,9 @@ static int early_serial_putc(unsigned char ch)
 static void early_serial_write(struct console *con, const char *s, unsigned n)
 {
 	while (*s && n-- > 0) {
-		early_serial_putc(*s);
 		if (*s == '\n')
 			early_serial_putc('\r');
+		early_serial_putc(*s);
 		s++;
 	}
 }
