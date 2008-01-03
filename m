Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbYACF7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbYACF7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760266AbYACF6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:58:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:52615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760250AbYACF6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:58:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ifyjamcy93ZG1Mx7lKlzi0Xm92zYz5btK+z/RhsjcjcB0orZpyW4qUud6ftV1x4+NWnqoXRpsL1m9rQ07H9JeyHV3Dj/ikHBevkgBvMXhq/jBmrIiCfSw8Txlk3BlwFgbFSb8tanOSk9FMCPJuoZyGfx5sER1PToCAnZPmvQmHs=
Date: Thu, 3 Jan 2008 14:02:10 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH 7/7] spi : convert semaphore to mutex in struct class
Message-ID: <20080103060210.GH4885@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex instead of semaphore in struct class.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
---
drivers/spi/spi.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -upr linux/drivers/spi/spi.c linux.new/drivers/spi/spi.c
--- linux/drivers/spi/spi.c	2007-12-28 10:47:38.000000000 +0800
+++ linux.new/drivers/spi/spi.c	2007-12-28 10:48:22.000000000 +0800
@@ -494,7 +494,7 @@ struct spi_master *spi_busnum_to_master(
 	struct spi_master	*master = NULL;
 	struct spi_master	*m;
 
-	down(&spi_master_class.sem);
+	mutex_lock(&spi_master_class.mutex);
 	list_for_each_entry(dev, &spi_master_class.children, node) {
 		m = container_of(dev, struct spi_master, dev);
 		if (m->bus_num == bus_num) {
@@ -502,7 +502,7 @@ struct spi_master *spi_busnum_to_master(
 			break;
 		}
 	}
-	up(&spi_master_class.sem);
+	mutex_unlock(&spi_master_class.mutex);
 	return master;
 }
 EXPORT_SYMBOL_GPL(spi_busnum_to_master);
