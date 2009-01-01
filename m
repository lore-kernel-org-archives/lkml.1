Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZAAQLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZAAQLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 11:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZAAQLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 11:11:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:48343 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZAAQLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 11:11:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fc1xZOPEi7/e61nhZoZqr6+6jnXut5ZIPcbAjC2zqZjj7pIZ4qL19ZGt5cTY/Sv+53
         jQXE7tcSt7ZOWsP5pvxYZHDtRiUz0o/qLOzJf+5yH9Q/y5bFGp/xtoQIYyntG9IcLgXw
         08mZebe89EONjtq7+IrAwyAlfdps0nxKhewtg=
Date: Fri, 2 Jan 2009 01:11:14 +0900
From: sangsu <sangsu@gmail.com>
To: linux-usb@vger.kernel.org
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       david-b@pacbell.net
Subject: [PATCH]USB:Fix goku_udc usb speed handling
Message-ID: <20090101161114.GA7977@sangsu-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb gadget framework revealed weakness in the godu_udc
gadget driver register function. Instead of checking if 
speed asked for was USB_LOW_SPEED upon usb_gadget_register()
to deny service, it checked only for USB_FULL_SPEED, thus
denying service to usb high speed capable gadgets.

Signed-off-by: SangSu Park<sangsu@gmail.com>
---
drivers/usb/gadget/goku_udc.c |2+-
1 files changed, 1 insertion(+), 1 deletions(-)


--- a/drivers/usb/gadget/goku_udc.c	2008-12-30 23:24:02.000000000 +0900
+++ b/drivers/usb/gadget/goku_udc.c	2009-01-02 00:49:15.000000000 +0900
@@ -1349,7 +1349,7 @@
 	int			retval;
 
 	if (!driver
-			|| driver->speed != USB_SPEED_FULL
+			|| driver->speed < USB_SPEED_FULL
 			|| !driver->bind
 			|| !driver->disconnect
 			|| !driver->setup)
