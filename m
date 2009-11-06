Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbZKFW3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbZKFW3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbZKFW3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:29:43 -0500
Received: from kroah.org ([198.145.64.141]:57100 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627AbZKFWX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:49 2009
Message-Id: <20091106221549.637855004@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>
Subject: [78/99] hwmon: (it87) Fix VID reading on IT8718F/IT8720F
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-it87-fix-vid-reading-on-it8718f-it8720f.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 371dc4a6d8c3c74a9a1c74b87c2affb3fcef6500 upstream.

Comparing apples to bananas doesn't seem right. Consistently use the
chips enum for chip type comparisons, to avoid such bugs in the
future.

The bug has been there since support for the IT8718F was added, so
VID never worked for this chip nor for the similar IT8720F.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/it87.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -1028,12 +1028,11 @@ static int __init it87_find(unsigned sho
 		chip_type, *address, sio_data->revision);
 
 	/* Read GPIO config and VID value from LDN 7 (GPIO) */
-	if (chip_type != IT8705F_DEVID) {
+	if (sio_data->type != it87) {
 		int reg;
 
 		superio_select(GPIO);
-		if ((chip_type == it8718) ||
-		    (chip_type == it8720))
+		if (sio_data->type == it8718 || sio_data->type == it8720)
 			sio_data->vid_value = superio_inb(IT87_SIO_VID_REG);
 
 		reg = superio_inb(IT87_SIO_PINX2_REG);


