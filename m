Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbXL2BPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbXL2BPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbXL2BPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:15:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:32836 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbXL2BPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:15:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=pPY8VPrad7Yg60m+ARAx3UZfZewqLyt2SuwHNhN1ZDyFlgiSkDWQJj2rlWMvewsUAsqjsL44DbdkFUTUValJDiS4NkcNWbuh+2X/lPAIf8npxsAV1vSG6nY24UucN1nUoGNKVK0VfPR2hI2pAc4yYom6nJYr7JsbpbT80ihxqMw=
Date: Sat, 29 Dec 2007 09:18:58 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH 11/12] spi : Use mutex instead of semaphore in driver core
Message-ID: <20071229011858.GL2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
