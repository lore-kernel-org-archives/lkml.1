Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYICQ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYICQ16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYICQ1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:27:49 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:38647 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYICQ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:27:48 -0400
Date: Wed, 3 Sep 2008 18:26:41 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg K-H <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Patch 2/2] Driver core: Fix cleanup in device_create_vargs().
Message-ID: <20080903182641.75db23a6@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080903162808.36bb2405@gondolin.boeblingen.de.ibm.com>
References: <20080903162808.36bb2405@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() in device_create_vargs() fails, the device
must be cleaned up with put_device() (which is also fine on NULL)
instead of kfree().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -1248,7 +1248,7 @@ struct device *device_create_vargs(struc
 	return dev;
 
 error:
-	kfree(dev);
+	put_device(dev);
 	return ERR_PTR(retval);
 }
 EXPORT_SYMBOL_GPL(device_create_vargs);
