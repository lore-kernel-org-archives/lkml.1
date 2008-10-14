Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYJNJP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYJNJP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbYJNJPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:15:18 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:41242 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbYJNJPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:15:15 -0400
Message-Id: <20081014091413.003841094@linux.vnet.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Oct 2008 11:12:49 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/5] hvc_console: Add tty driver flag TTY_DRIVER_RESET_TERMIOS
Content-Disposition: inline; filename=hvc/common/02_hvc_termios.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

After a tty hangup() or close() operation, processes might not reset the
termio settings to a sane state. In order to reset the termios to its
default settings the tty driver flag TTY_DRIVER_RESET_TERMIOS has been added.

TTY driver flag description from include/linux/tty_driver.h:
	TTY_DRIVER_RESET_TERMIOS --- requests the tty layer to reset the
	  termios setting when the last process has closed the device.
	  Used for PTY's, in particular.


Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 drivers/char/hvc_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -796,7 +796,7 @@ static int hvc_init(void)
 	drv->minor_start = HVC_MINOR;
 	drv->type = TTY_DRIVER_TYPE_SYSTEM;
 	drv->init_termios = tty_std_termios;
-	drv->flags = TTY_DRIVER_REAL_RAW;
+	drv->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_RESET_TERMIOS;
 	tty_set_operations(drv, &hvc_ops);
 
 	/* Always start the kthread because there can be hotplug vty adapters

-- 
Hendrik Brueckner
D/3303 Linux on System z Development
Tel: +49 7031 16-1073
Fax: +49 7031 16-3456
eMail: brueckner@linux.vnet.ibm.com
IBM Deutschland Research & Development GmbH, Schoenaicher Str. 220, 71032 Boeblingen

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

