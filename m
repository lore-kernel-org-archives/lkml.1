Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab0BENrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:47:08 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58624 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451Ab0BENrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:47:06 -0500
Date: Fri, 5 Feb 2010 14:47:18 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@linux.intel.com>, Vikram Pandita <vikram.pandita@ti.com>,
       Christian Pellegrin <chripell@fsfe.org>, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] obsolete config in kernel source (HARD_PPS)
Message-ID: <20100205134718.GC7077@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	There are a bunch of files in the current linux tree checking
for CONFIG_HARD_PPS which isn't in KConfig neither any other media of
setting it as far as I can tell and has been like this for ages.

	As this is seemingly unnecessary and a bit confusing when
going over the tree it migt be beneficial to clean out these parts
from the actual source.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From f0276583080d5732f160b9dcf6f45caddac3a999 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 5 Feb 2010 13:59:53 +0100
Subject: [PATCH] Remove HARD_PPS conditionalizing

HARD_PPS is another case of unsetable CONFIG_* Item that hasn't been
touched in git history. It  is currently still used in 3 source files
which this patch addresses.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/char/amiserial.c     |    5 -----
 drivers/serial/68360serial.c |    5 -----
 include/linux/serial_core.h  |    5 -----
 3 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 6c32fbf..7e33af5 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -390,11 +390,6 @@ static void check_modem_status(struct async_struct *info)
 			icount->dsr++;
 		if (dstatus & SER_DCD) {
 			icount->dcd++;
-#ifdef CONFIG_HARD_PPS
-			if ((info->flags & ASYNC_HARDPPS_CD) &&
-			    !(status & SER_DCD))
-				hardpps();
-#endif
 		}
 		if (dstatus & SER_CTS)
 			icount->cts++;
diff --git a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
index 24661cd..dc05e36 100644
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -557,11 +557,6 @@ static _INLINE_ void check_modem_status(struct async_struct *info)
 			icount->dsr++;
 		if (status & UART_MSR_DDCD) {
 			icount->dcd++;
-#ifdef CONFIG_HARD_PPS
-			if ((info->flags & ASYNC_HARDPPS_CD) &&
-			    (status & UART_MSR_DCD))
-				hardpps();
-#endif
 		}
 		if (status & UART_MSR_DCTS)
 			icount->cts++;
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 8c3dd36..677f261 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -494,11 +494,6 @@ uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 
 	uport->icount.dcd++;
 
-#ifdef CONFIG_HARD_PPS
-	if ((uport->flags & UPF_HARDPPS_CD) && status)
-		hardpps();
-#endif
-
 	if (port->flags & ASYNC_CHECK_CD) {
 		if (status)
 			wake_up_interruptible(&port->open_wait);
-- 
1.6.3.3

