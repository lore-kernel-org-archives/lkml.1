Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZEDU0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZEDU0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZEDU0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:26:38 -0400
Received: from kroah.org ([198.145.64.141]:37867 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbZEDU0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:26:37 -0400
Date: Mon, 4 May 2009 13:13:23 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>, Matthias Fuchs <mfuchs@ma-fu.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] of_serial: remove driver_data direct access of struct
	device
Message-ID: <20090504201323.GA23069@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Matthias Fuchs <mfuchs@ma-fu.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/of_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/serial/of_serial.c
+++ b/drivers/serial/of_serial.c
@@ -122,7 +122,7 @@ static int __devinit of_platform_serial_
 
 	info->type = port_type;
 	info->line = ret;
-	ofdev->dev.driver_data = info;
+	dev_set_drvdata(&ofdev->dev, info);
 	return 0;
 out:
 	kfree(info);
@@ -135,7 +135,7 @@ out:
  */
 static int of_platform_serial_remove(struct of_device *ofdev)
 {
-	struct of_serial_info *info = ofdev->dev.driver_data;
+	struct of_serial_info *info = dev_get_drvdata(&ofdev->dev);
 	switch (info->type) {
 #ifdef CONFIG_SERIAL_8250
 	case PORT_8250 ... PORT_MAX_8250:
