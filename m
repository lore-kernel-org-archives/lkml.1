Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0APP76 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950Ab0APP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:59:55 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:42650 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab0APP7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:59:53 -0500
Date: Sat, 16 Jan 2010 16:59:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Lonnie Mendez <dignome@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 7/9] drivers/usb/serial: Eliminate useless code
Message-ID: <Pine.LNX.4.64.1001161659230.28745@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variables priv and portdata are initialized twice to the same (side
effect-free) expressions.  Drop one initialization in each case.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/serial/cypress_m8.c |    1 -
 drivers/usb/serial/sierra.c     |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 60c2002..9b96c08 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -687,7 +687,6 @@ static void cypress_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	/* drop dtr and rts */
-	priv = usb_get_serial_port_data(port);
 	spin_lock_irq(&priv->lock);
 	if (on == 0)
 		priv->line_control = 0;
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index ac1b644..83a7f49 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -476,7 +476,7 @@ static void sierra_outdat_callback(struct urb *urb)
 static int sierra_write(struct tty_struct *tty, struct usb_serial_port *port,
 					const unsigned char *buf, int count)
 {
-	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
+	struct sierra_port_private *portdata;
 	struct sierra_intf_private *intfdata;
 	struct usb_serial *serial = port->serial;
 	unsigned long flags;
