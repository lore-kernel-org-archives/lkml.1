Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbXL2BJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbXL2BJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbXL2BJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:09:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:23735 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbXL2BJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:09:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ph6du/ohGVoyKblTbw2n7s2TRIJB95fAZC+4+FVJ/idQ3B4sHPPq5LihDnhlVoNeltvMxCjj7WIPPPM8JTgzBORDEqpcjWqrh7Xl0VdqNFHJHrifDOfd4XL+1sAOdAEiwKljJDhRSPYOcDkHF+HDvD1TPGzDI/oFFqyay7PzKp8=
Date: Sat, 29 Dec 2007 09:13:07 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] pcmcia : Use mutex instead of semaphore in driver
	core
Message-ID: <20071229011307.GH2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/pcmcia/ds.c |    8 ++++----
1 file changed, 4 insertions(+), 4 deletions(-)

diff -upr linux/drivers/pcmcia/ds.c linux.new/drivers/pcmcia/ds.c
--- linux/drivers/pcmcia/ds.c	2007-12-28 10:31:52.000000000 +0800
+++ linux.new/drivers/pcmcia/ds.c	2007-12-28 10:33:14.000000000 +0800
@@ -1119,9 +1119,9 @@ static int runtime_suspend(struct device
 {
 	int rc;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	rc = pcmcia_dev_suspend(dev, PMSG_SUSPEND);
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 	return rc;
 }
 
@@ -1129,9 +1129,9 @@ static void runtime_resume(struct device
 {
 	int rc;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	rc = pcmcia_dev_resume(dev);
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 }
 
 /************************ per-device sysfs output ***************************/
