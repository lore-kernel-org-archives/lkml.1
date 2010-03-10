Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0CJW0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:26:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:36509 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757346Ab0CJW0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:26:41 -0500
X-Authenticated: #9008106
X-Provags-ID: V01U2FsdGVkX1+6ywkLlWu6x7FHrY/XX/YPib5v5rqER4dzWF7YMM
	6QMycAt9fUwUDz
Date: Wed, 10 Mar 2010 23:26:37 +0100
From: Michael Brunner <mibru@gmx.de>
To: craig@microtron.org.uk, gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB-SERIAL cp210x: Remove double usb_control_msg from
 cp210x_set_config
Message-ID: <20100310232637.7e14e773@mail.gmx.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a double usb_control_msg that sets the cp210x
configuration registers a second time when calling cp210x_set_config.
For data sizes >2 the second write gets corrupted.
The patch has been created against 2.6.34-rc1, but all cp210x driver
revisions are affected.

Signed-off-by: Michael Brunner <mibru@gmx.de>
---
 drivers/usb/serial/cp210x.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 507382b..ec9b044 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -313,11 +313,6 @@ static int cp210x_set_config(struct usb_serial_port *port, 
        return -EPROTO;
    }
 
-   /* Single data value */
-   result = usb_control_msg(serial->dev,
-           usb_sndctrlpipe(serial->dev, 0),
-           request, REQTYPE_HOST_TO_DEVICE, data[0],
-           0, NULL, 0, 300);
    return 0;
 }
 
