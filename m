Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXL2BMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXL2BMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXL2BML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:12:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:27542 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbXL2BMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:12:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=xa8UcPd0kDvmve1ReANndAZJTWzXNKWjLFEpzdVH0qGIsW6PybFMVnFEyMjDhQY4PkK0MRpnrR9lvcQ+0VraXn48URJXonXAlkgX1jaTOMMUO7hZgrBJW//2BrvMRtoH5+rVzpyT0J/8CBCrArOei+3QX7HHYvtodmmOHRW+WkY=
Date: Sat, 29 Dec 2007 09:15:57 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH 09/12] rtc : Use mutex instead of semaphore in driver core
Message-ID: <20071229011557.GJ2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/rtc/interface.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -upr linux/drivers/rtc/interface.c linux.new/drivers/rtc/interface.c
--- linux/drivers/rtc/interface.c	2007-12-28 10:41:42.000000000 +0800
+++ linux.new/drivers/rtc/interface.c	2007-12-28 10:43:51.000000000 +0800
@@ -256,7 +256,7 @@ struct rtc_device *rtc_class_open(char *
 	struct device *dev;
 	struct rtc_device *rtc = NULL;
 
-	down(&rtc_class->sem);
+	mutex_lock(&rtc_class->mutex);
 	list_for_each_entry(dev, &rtc_class->devices, node) {
 		if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0) {
 			dev = get_device(dev);
@@ -272,7 +272,7 @@ struct rtc_device *rtc_class_open(char *
 			rtc = NULL;
 		}
 	}
-	up(&rtc_class->sem);
+	mutex_unlock(&rtc_class->mutex);
 
 	return rtc;
 }
