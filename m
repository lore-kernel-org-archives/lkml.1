Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYCCWsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYCCWsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYCCWsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:48:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47811 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbYCCWsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:48:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] Device core: Remove dpm_sysfs_remove() from error path of device_add()
Date: Mon, 3 Mar 2008 23:46:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803032346.52173.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The appended patch fixes a bug in the error path of device_add().

Please accept it for 2.6.25.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Since device_pm_remove(dev) calls dpm_sysfs_remove(dev), it's
incorrect to call the latter after the former in the device_add()
error path.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/core.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -839,7 +839,6 @@ int device_add(struct device *dev)
 	return error;
  BusError:
 	device_pm_remove(dev);
-	dpm_sysfs_remove(dev);
  PMError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
