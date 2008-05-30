Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYE3RaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYE3RaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYE3RaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:30:02 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:40109 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYE3RaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qWYtoj4G6XDcs0jhbmT3CTbuSADK1aCiVtFs9JRWf7Luwo/kCIeGp4I9qsknYE4yHD4r3PkPvkDb6AvsGhskhwBurQrd2yyhozQhqgDGkyIbyKwZYXMS1fsZXr4/bN3p2HJwAwbSe7A9X+qdRAXSYF3lyH+02p+Ny59E2xF8pOE=
Subject: [PATCH] usb: cp2101.c fix sparse signedness mismatch warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 30 May 2008 10:29:55 -0700
Message-Id: <1212168595.28403.198.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get/set 2101_config helpers take an unsigned int rather than an
int.  It is safe to change these in each case and may even produce
better code as it will be an unsigned divide rather than a signed
divide in places.  All other manipulation was setting/masking bits
which will not be affected by the sign change.

Fixes the following sparse warnings:
drivers/usb/serial/cp2101.c:378:44: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:378:44:    expected unsigned int *data
drivers/usb/serial/cp2101.c:378:44:    got int *<noident>
drivers/usb/serial/cp2101.c:388:40: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:388:40:    expected unsigned int *data
drivers/usb/serial/cp2101.c:388:40:    got int *<noident>
drivers/usb/serial/cp2101.c:413:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:413:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:413:42:    got int *<noident>
drivers/usb/serial/cp2101.c:421:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:421:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:421:42:    got int *<noident>
drivers/usb/serial/cp2101.c:444:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:444:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:444:42:    got int *<noident>
drivers/usb/serial/cp2101.c:451:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:451:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:451:42:    got int *<noident>
drivers/usb/serial/cp2101.c:458:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:458:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:458:42:    got int *<noident>
drivers/usb/serial/cp2101.c:471:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:471:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:471:42:    got int *<noident>
drivers/usb/serial/cp2101.c:481:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:481:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:481:42:    got int *<noident>
drivers/usb/serial/cp2101.c:561:41: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:561:41:    expected unsigned int *data
drivers/usb/serial/cp2101.c:561:41:    got int *<noident>
drivers/usb/serial/cp2101.c:591:45: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:591:45:    expected unsigned int *data
drivers/usb/serial/cp2101.c:591:45:    got int *<noident>
drivers/usb/serial/cp2101.c:597:41: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:597:41:    expected unsigned int *data
drivers/usb/serial/cp2101.c:597:41:    got int *<noident>
drivers/usb/serial/cp2101.c:608:45: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:608:45:    expected unsigned int *data
drivers/usb/serial/cp2101.c:608:45:    got int *<noident>
drivers/usb/serial/cp2101.c:614:41: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:614:41:    expected unsigned int *data
drivers/usb/serial/cp2101.c:614:41:    got int *<noident>
drivers/usb/serial/cp2101.c:623:45: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:623:45:    expected unsigned int *data
drivers/usb/serial/cp2101.c:623:45:    got int *<noident>
drivers/usb/serial/cp2101.c:680:50: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:680:50:    expected unsigned int *data
drivers/usb/serial/cp2101.c:680:50:    got int *<noident>
drivers/usb/serial/cp2101.c:690:43: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:690:43:    expected unsigned int *data
drivers/usb/serial/cp2101.c:690:43:    got int *<noident>
drivers/usb/serial/cp2101.c:715:41: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:715:41:    expected unsigned int *data
drivers/usb/serial/cp2101.c:715:41:    got int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/usb/serial/cp2101.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/cp2101.c b/drivers/usb/serial/cp2101.c
index f5b57b1..2bc5576 100644
--- a/drivers/usb/serial/cp2101.c
+++ b/drivers/usb/serial/cp2101.c
@@ -365,8 +365,8 @@ static void cp2101_close (struct usb_serial_port *port, struct file * filp)
 static void cp2101_get_termios (struct usb_serial_port *port)
 {
 	unsigned int cflag, modem_ctl[4];
-	int baud;
-	int bits;
+	unsigned int baud;
+	unsigned int bits;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -498,7 +498,7 @@ static void cp2101_set_termios (struct usb_serial_port *port,
 		struct ktermios *old_termios)
 {
 	unsigned int cflag, old_cflag;
-	int baud=0, bits;
+	unsigned int baud = 0, bits;
 	unsigned int modem_ctl[4];
 
 	dbg("%s - port %d", __func__, port->number);
@@ -654,7 +654,7 @@ static void cp2101_set_termios (struct usb_serial_port *port,
 static int cp2101_tiocmset (struct usb_serial_port *port, struct file *file,
 		unsigned int set, unsigned int clear)
 {
-	int control = 0;
+	unsigned int control = 0;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -683,7 +683,8 @@ static int cp2101_tiocmset (struct usb_serial_port *port, struct file *file,
 
 static int cp2101_tiocmget (struct usb_serial_port *port, struct file *file)
 {
-	int control, result;
+	unsigned int control;
+	int result;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -703,7 +704,7 @@ static int cp2101_tiocmget (struct usb_serial_port *port, struct file *file)
 
 static void cp2101_break_ctl (struct usb_serial_port *port, int break_state)
 {
-	int state;
+	unsigned int state;
 
 	dbg("%s - port %d", __func__, port->number);
 	if (break_state == 0)
-- 
1.5.6.rc0.277.g804cf



