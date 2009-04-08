Return-Path: <linux-kernel-owner+w=401wt.eu-S1759060AbZDHKmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbZDHKmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbZDHKmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:42:11 -0400
Received: from mailgate4.9netweb.it ([66.71.190.73]:58563 "EHLO
	mailgate4.9netweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZDHKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:42:10 -0400
X-Greylist: delayed 2054 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2009 06:42:10 EDT
Message-ID: <49DC7754.4030404@evidence.eu.com>
Date: Wed, 08 Apr 2009 12:07:16 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jesper Nilsson <Jesper.Nilsson@axis.com>, starvik@axis.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       Janez Cufer <janez.cufer@cetrtapot.si>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dev-etrax@axis.com,
       adobriyan@gmail.com
Subject: [PATCH] Fix broken compilation of Cris serial driver
Content-Type: multipart/mixed;
 boundary="------------080205010708070108040309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080205010708070108040309
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

    compilation of cris serial driver on 2.6.30-rc1 is broken since 
commit number 0f043a81ebe84be3576667f04fdda481609e3816 removed the 
read_proc field from the tty_driver structure.

The patch in attachment may fix the problem. Please check it very 
carefully: I don't have hardware to make any test.

Regards,

           Claudio

--------------080205010708070108040309
Content-Type: text/x-diff;
 name="0001-Fix-remove-read_proc-field-from-cris-serial-driver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Fix-remove-read_proc-field-from-cris-serial-driver.patc";
 filename*1="h"

From: Claudio Scordino <claudio@evidence.eu.com>

Commit number 0f043a81ebe84be3576667f04fdda481609e3816 removed the read_proc
field from the tty_driver structure.

This broke cris serial driver compilation.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 drivers/serial/crisv10.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 7ba7d70..a331e40 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -27,6 +27,7 @@ static char *serial_version = "$Revision: 1.25 $";
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/bitops.h>
+#include <linux/proc_fs.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -4425,7 +4426,6 @@ static const struct tty_operations rs_ops = {
 	.break_ctl = rs_break,
 	.send_xchar = rs_send_xchar,
 	.wait_until_sent = rs_wait_until_sent,
-	.read_proc = rs_read_proc,
 	.tiocmget = rs_tiocmget,
 	.tiocmset = rs_tiocmset
 };
@@ -4490,6 +4490,7 @@ rs_init(void)
 	if (tty_register_driver(driver))
 		panic("Couldn't register serial driver\n");
 	/* do some initializing for the separate ports */
+	driver->proc_entry->read_proc = rs_read_proc;
 
 	for (i = 0, info = rs_table; i < NR_PORTS; i++,info++) {
 		if (info->enabled) {
-- 
1.5.4.3


--------------080205010708070108040309--
