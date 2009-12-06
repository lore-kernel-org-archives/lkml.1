Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbZLFXjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbZLFXjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758195AbZLFXjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:39:00 -0500
Received: from kroah.org ([198.145.64.141]:33843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758181AbZLFXiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:38:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 15:32:11 2009
Message-Id: <20091206233211.121828427@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:30:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Willy Tarreau <w@1wt.eu>, Jean Delvare <khali@linux-fr.org>
Subject: [20/20] hwmon: (it87) Fix VID reading on IT8718F
References: <20091206233032.387950574@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-it87-fix-vid-reading-on-it8718f.patch
In-Reply-To: <20091206233711.GA11609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 371dc4a6d8c3c74a9a1c74b87c2affb3fcef6500 upstream

Comparing apples to bananas doesn't seem right.

The bug has been there since support for the IT8718F was added, so
VID never worked for this chip.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/it87.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -1017,7 +1017,7 @@ static int __init it87_find(unsigned sho
 		int reg;
 
 		superio_select(GPIO);
-		if (chip_type == it8718)
+		if (sio_data->type == it8718)
 			sio_data->vid_value = superio_inb(IT87_SIO_VID_REG);
 
 		reg = superio_inb(IT87_SIO_PINX2_REG);


