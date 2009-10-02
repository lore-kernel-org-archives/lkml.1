Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZJBByG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZJBByG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbZJBBdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:07 -0400
Received: from kroah.org ([198.145.64.141]:33101 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbZJBBdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:13 2009
Message-Id: <20091002012412.966392210@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [046/136] tty: remove dtr/rts use from the driver open methods
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=tty-remove-dtr-rts-use-from-the-driver-open-methods.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit 9a68e39d4a701fb3be03cae9b462408664ebd205 upstream.

These are handled by the tty_port core code which will raise and lower the
carrier correctly in tty_wait_until_ready

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -399,12 +399,6 @@ static int cp210x_open(struct tty_struct
 
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
 


