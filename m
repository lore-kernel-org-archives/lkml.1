Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZGEMTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZGEMTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 08:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZGEMSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 08:18:55 -0400
Received: from the.earth.li ([217.147.81.2]:38268 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbZGEMSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 08:18:55 -0400
X-Greylist: delayed 2937 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jul 2009 08:18:54 EDT
Date: Sun, 5 Jul 2009 12:29:51 +0100
From: Jonathan McDowell <noodles@earth.li>
To: Josua Dietze <digidietze@draisberghof.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix option_ms regression in 2.6.31-rc2
Message-ID: <20090705112951.GC23150@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 32ebbe7b6ad44ae9c276419710b56de6ba705303 which filters the
SCSI REZERO command in option_ms based on a SCSI INQUIRY with a vendor
of Option breaks my Option Icon 225 (0af0:6971). This device returns a
vendor of ZCOPTION for the ZeroCD device. The following trivial patch
fixes things for me.

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-----
--- linux-2.6.31-rc2/drivers/usb/storage/option_ms.c.orig	2009-07-05 11:48:19.000000000 +0100
+++ linux-2.6.31-rc2/drivers/usb/storage/option_ms.c	2009-07-05 11:50:59.000000000 +0100
@@ -118,6 +118,9 @@ static int option_inquiry(struct us_data
 
 	result = memcmp(buffer+8, "Option", 6);
 
+	if (result != 0)
+		result = memcmp(buffer+8, "ZCOPTION", 8);
+
 	/* Read the CSW */
 	usb_stor_bulk_transfer_buf(us,
 			us->recv_bulk_pipe,
-----

J.

-- 
   Nice computers don't go down.   |  .''`.  Debian GNU/Linux Developer
                                   | : :' :  Happy to accept PGP signed
                                   | `. `'   or encrypted mail - RSA
                                   |   `-    key on the keyservers.
