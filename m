Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbYLZH3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbYLZH3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYLZH3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:29:24 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:33498 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbYLZH3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:29:22 -0500
Date: Fri, 26 Dec 2008 08:29:19 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/7] drivers/usb/serial: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0812260829000.25450@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@disable is_null@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (E == NULL) S
  f(...,E->fld,...);
- if (E == NULL) S

@@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (!E) S
  f(...,E->fld,...);
- if (!E) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/serial/usb-serial.c     |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 080ade2..45f8ce8 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -509,11 +509,11 @@ static void usb_serial_port_work(struct work_struct *work)
 		container_of(work, struct usb_serial_port, work);
 	struct tty_struct *tty;
 
-	dbg("%s - port %d", __func__, port->number);
-
 	if (!port)
 		return;
 
+	dbg("%s - port %d", __func__, port->number);
+
 	tty = tty_port_tty_get(&port->port);
 	if (!tty)
 		return;
