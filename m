Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZISVlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZISVlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZISVla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:41:30 -0400
Received: from kroah.org ([198.145.64.141]:40467 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbZISVl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:41:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/79] tty: remove dtr/rts use from the driver open methods
Date: Sat, 19 Sep 2009 14:36:43 -0700
Message-Id: <1253396244-7885-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

These are handled by the tty_port core code which will raise and lower the
carrier correctly in tty_wait_until_ready

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/cp210x.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 985cbcf..b5275c4 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -399,12 +399,6 @@ static int cp210x_open(struct tty_struct *tty, struct usb_serial_port *port,
 
 	/* Configure the termios structure */
 	cp210x_get_termios(tty, port);
-
-	/* Set the DTR and RTS pins low */
-	cp210x_tiocmset_port(tty ? (struct usb_serial_port *) tty->driver_data
-			: port,
-		NULL, TIOCM_DTR | TIOCM_RTS, 0);
-
 	return 0;
 }
 
-- 
1.6.4.2

