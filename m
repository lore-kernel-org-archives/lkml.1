Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbYBVSUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbYBVSUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbYBVSTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:19:54 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:39679 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYBVSTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:19:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nu0g3fEko6rGmH1Pbsmco8vPnautQWSI0c7KP5lPgVeq65+/NWpFJ4WFUCmXfALm94/m1mRnNbUpW57l8xWw3edyesErhTRZehi4lUy8KX0bxfYBhFXumy9Znhr2aMTh2bFX6J45CdEckDlkWY3PFWXs0AEppFOAna61ZAQ1Kc8=
Subject: [PATCH] char: static functions and integer as NULL pointer fixes
	in epca.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 10:20:10 -0800
Message-Id: <1203704410.5962.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/epca.c:926:28: warning: Using plain integer as NULL pointer
drivers/char/epca.c:1841:2: warning: Using plain integer as NULL pointer

Forward declarations were already marked static, mark the definitions too.
drivers/char/epca.c:2493:6: warning: symbol 'digi_send_break' was not declared. Should it be static?
drivers/char/epca.c:2881:12: warning: symbol 'init_PCI' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/epca.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index ffd747c..b034b37 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -923,7 +923,7 @@ static int pc_open(struct tty_struct *tty, struct file * filp)
 		return(-ENODEV);
 	}
 
-	if ((bc = ch->brdchan) == 0) {
+	if ((bc = ch->brdchan) == NULL) {
 		tty->driver_data = NULL;
 		return -ENODEV;
 	}
@@ -1838,7 +1838,7 @@ static void epcaparam(struct tty_struct *tty, struct channel *ch)
 	unsigned mval, hflow, cflag, iflag;
 
 	bc = ch->brdchan;
-	epcaassert(bc !=0, "bc out of range");
+	epcaassert(bc != NULL, "bc out of range");
 
 	assertgwinon(ch);
 	ts = tty->termios;
@@ -2490,7 +2490,7 @@ static void pc_unthrottle(struct tty_struct *tty)
 	}
 }
 
-void digi_send_break(struct channel *ch, int msec)
+static void digi_send_break(struct channel *ch, int msec)
 {
 	unsigned long flags;
 
@@ -2878,7 +2878,7 @@ static struct pci_device_id epca_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, epca_pci_tbl);
 
-int __init init_PCI (void)
+static int __init init_PCI (void)
 {
 	memset (&epca_driver, 0, sizeof (epca_driver));
 	epca_driver.name = "epca";
-- 
1.5.4.2.200.g99e75



