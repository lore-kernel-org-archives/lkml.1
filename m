Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbYKRBik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbYKRBik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYKRBic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:38:32 -0500
Received: from host2.marvell.com ([65.219.4.2]:54077 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752009AbYKRBib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:38:31 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2008 20:38:31 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 2.6.28-rc5] mfd da903x: section fix
Date: Mon, 17 Nov 2008 17:18:29 -0800
Message-ID: <E913911567467945BBEB9277E27868B001494C8B@msiexch01.marvell.com>
In-Reply-To: <200811171142.38587.david-b@pacbell.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 2.6.28-rc5] mfd da903x: section fix
Thread-Index: AclI+SwoFgv4kBwfRI+B++f2uukWmgAIlCdQ
References: <200811171142.38587.david-b@pacbell.net>
From: "Eric Miao" <ymiao3@marvell.com>
To: <dbrownell@users.sourceforge.net>, "Samuel Ortiz" <sameo@openedhand.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>,
       "Mike Rapoport" <mike@compulab.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed.

Acked-by: Eric Miao <eric.miao@marvell.com>

Samuel, please consider merge, thanks.

-----Original Message-----
From: David Brownell [mailto:david-b@pacbell.net] 
Sent: Tuesday, November 18, 2008 3:43 AM
To: Samuel Ortiz
Cc: lkml; Eric Miao; Mike Rapoport
Subject: [patch 2.6.28-rc5] mfd da903x: section fix

From: David Brownell <dbrownell@users.sourceforge.net>

This fixes the following section warning:

  WARNING: vmlinux.o(.devinit.text+0x3d36): Section mismatch in
reference from the function 
  da903x_add_subdevs() to the function
.devexit.text:da903x_remove_subdevs()
  The function __devinit da903x_add_subdevs() references
  a function __devexit da903x_remove_subdevs().
  This is often seen when error handling in the init function
  uses functionality in the exit path.
  The fix is often to remove the __devexit annotation of
  da903x_remove_subdevs() so it may be used outside an exit section.

It might be nice to have an "init and exit" section annotation for such
cases; in this case the waste is only about 40 bytes (x86 test build).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mfd/da903x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -435,13 +435,13 @@ static const struct i2c_device_id da903x
 };
 MODULE_DEVICE_TABLE(i2c, da903x_id_table);
 
-static int __devexit __remove_subdev(struct device *dev, void *unused)
+static int __remove_subdev(struct device *dev, void *unused)
 {
 	platform_device_unregister(to_platform_device(dev));
 	return 0;
 }
 
-static int __devexit da903x_remove_subdevs(struct da903x_chip *chip)
+static int da903x_remove_subdevs(struct da903x_chip *chip)
 {
 	return device_for_each_child(chip->dev, NULL, __remove_subdev);
 }
