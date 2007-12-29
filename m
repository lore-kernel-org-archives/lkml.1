Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbXL2BC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbXL2BC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXL2BCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:02:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:12505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXL2BCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=SSZyBhwgmXHp4QYMrQPe/Gfp9q5YsmM0CM5rvW/g3slhUXbfgZcIScgjPoTh9v13EmJoGiIF3AiPfdiI9+LnWCBPrOiqC7qdDRer/iPO7zAzQAuFr9VL2Xs4ETpJFtm1bubvoIuQY6eJJsiCpo20kTIeNBLHdUhtQ+oSDGYF7nc=
Date: Sat, 29 Dec 2007 09:06:02 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: krh@redhat.com, stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [PATCH 03/12] firewire : Use mutex instead of semaphore in driver
	core
Message-ID: <20071229010602.GD2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/firewire/fw-device.c |    6 +++---
1 file changed, 3 insertions(+), 3 deletions(-)

diff -upr linux/drivers/firewire/fw-device.c linux.new/drivers/firewire/fw-device.c
--- linux/drivers/firewire/fw-device.c	2007-12-28 10:02:38.000000000 +0800
+++ linux.new/drivers/firewire/fw-device.c	2007-12-28 10:05:00.000000000 +0800
@@ -26,7 +26,7 @@
 #include <linux/delay.h>
 #include <linux/idr.h>
 #include <linux/rwsem.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include <linux/ctype.h>
 #include "fw-transaction.h"
 #include "fw-topology.h"
@@ -731,9 +731,9 @@ static int update_unit(struct device *de
 	struct fw_driver *driver = (struct fw_driver *)dev->driver;
 
 	if (is_fw_unit(dev) && driver != NULL && driver->update != NULL) {
-		down(&dev->sem);
+		mutex_lock(&dev->mutex);
 		driver->update(unit);
-		up(&dev->sem);
+		mutex_unlock(&dev->mutex);
 	}
 
 	return 0;
