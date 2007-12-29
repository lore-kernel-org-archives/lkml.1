Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbXL2BHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbXL2BHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbXL2BHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:07:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:19199 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXL2BHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=K035Diho2XOZwewRry4iDAd0N+jvLhRTe2PDiIQyj+Lalzo7945Ow22AIS6QIgbMMDIX6xEmc++oCiBsZX6maF53BvJIqE81ojTeHyd/kxu0GsrV73W8XlYu3EcrcNc1wrl/++Zu7Y0E6eoTOc8flzBc96s7qctyywo1Ts0kqI8=
Date: Sat, 29 Dec 2007 09:10:57 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH 06/12] pci : Use mutex instead of semaphore in driver core
Message-ID: <20071229011057.GG2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/pci/bus.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -upr linux/drivers/pci/bus.c linux.new/drivers/pci/bus.c
--- linux/drivers/pci/bus.c	2007-12-28 10:25:07.000000000 +0800
+++ linux.new/drivers/pci/bus.c	2007-12-28 10:28:56.000000000 +0800
@@ -207,9 +207,9 @@ void pci_walk_bus(struct pci_bus *top, v
 			next = dev->bus_list.next;
 
 		/* Run device routines with the device locked */
-		down(&dev->dev.sem);
+		mutex_lock(&dev->dev.mutex);
 		cb(dev, userdata);
-		up(&dev->dev.sem);
+		mutex_unlock(&dev->dev.mutex);
 	}
 	up_read(&pci_bus_sem);
 }
