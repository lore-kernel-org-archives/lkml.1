Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbYGQPJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbYGQPJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYGQPI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:08:58 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:33523
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbYGQPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:08:57 -0400
X-Greylist: delayed 808 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 11:08:57 EDT
Subject: [PATCH] make n_hdlc honor O_NONBLOCK on write
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 08:55:00 -0500
Message-Id: <1216302900.3842.4.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make n_hdlc line discipline honor the O_NONBLOCK
file flag on write.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/n_hdlc.c	2008-07-17 08:39:15.000000000 -0500
+++ b/drivers/char/n_hdlc.c	2008-07-17 08:43:58.000000000 -0500
@@ -677,6 +677,10 @@ static ssize_t n_hdlc_tty_write(struct t
 	/* Allocate transmit buffer */
 	/* sleep until transmit buffer available */		
 	while (!(tbuf = n_hdlc_buf_get(&n_hdlc->tx_free_buf_list))) {
+		if (file->f_flags & O_NONBLOCK) {
+			error = -EAGAIN;
+			break;
+		}
 		schedule();
 			
 		n_hdlc = tty2n_hdlc (tty);


