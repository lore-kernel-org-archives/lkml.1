Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbZHGMK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbZHGMK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbZHGMKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:10:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:27187 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678AbZHGMKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=JOP7fP57EoLOIqEck9lrjYUObYq1Y8x+Uk5RWT28ueABXqd+pINHqVcENLhEZxQHgO
         YbCOP3B5RUOOZcdHhmJTpVGUi4eONqzZj+TPGHniJ9J5LGrzEkHfqTswYbfYjuywUK3f
         rUpQqS9vICwpkbsr4v7l8ELK2bkwd2x0pLzt8=
Date: Fri, 7 Aug 2009 14:10:45 +0200 (SAST)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: linux-kernel@vger.kernel.org
Subject: [patch] off by one error in rioctrl.c
Message-ID: <alpine.DEB.2.00.0908032147520.6185@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure who to send this to.

If DownLoad.ProductCode == MAX_PRODUCT, that would be a problem when we do 
RIOBootTable[DownLoad.ProductCode] a couple lines down.

Found by smatch (http://repo.or.cz/w/smatch.git).

regards,
dan carpenter


Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/char/rio/rioctrl.c	2009-08-03 21:44:01.000000000 +0200
+++ devel/drivers/char/rio/rioctrl.c	2009-08-03 21:44:26.000000000 +0200
@@ -873,7 +873,7 @@
 		/*
 		 ** It is important that the product code is an unsigned object!
 		 */
-		if (DownLoad.ProductCode > MAX_PRODUCT) {
+		if (DownLoad.ProductCode >= MAX_PRODUCT) {
 			rio_dprintk(RIO_DEBUG_CTRL, "RIO_DOWNLOAD: Bad product code %d passed\n", DownLoad.ProductCode);
 			p->RIOError.Error = NO_SUCH_PRODUCT;
 			return -ENXIO;
