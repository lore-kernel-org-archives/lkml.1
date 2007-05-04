Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXEDNbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXEDNbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbXEDNbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:31:39 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:38825 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbXEDNbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:31:38 -0400
X-Greylist: delayed 1236 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 09:31:38 EDT
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Fri, 4 May 2007 18:58:23 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, rpjday@mindspring.com, alan@lxorguk.ukuu.org.uk,
       markus.lidel@shadowconnect.com
Subject: [PATCH] drivers/message/i2o/device.c: remove redundant GFP_ATOMIC
 from kmalloc
Message-ID: <Pine.LNX.4.64.0705041835530.13758@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/message/i2o/device.c:i2o_parm_field_get() unnecessarily passes 
GFP_ATOMIC (along with GFP_KERNEL) to kmalloc() from a context that is not 
atomic. Remove the pointless GFP_ATOMIC.

 	Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

diff -ruNp linux-2.6.21.1/drivers/message/i2o/device.c linux-2.6.21.1~patch/drivers/message/i2o/device.c
--- linux-2.6.21.1/drivers/message/i2o/device.c	2007-04-26 08:38:32.000000000 +0530
+++ linux-2.6.21.1~patch/drivers/message/i2o/device.c	2007-05-04 17:48:30.000000000 +0530
@@ -485,7 +485,7 @@ int i2o_parm_field_get(struct i2o_device
  	u8 *resblk;		/* 8 bytes for header */
  	int rc;

-	resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
+	resblk = kmalloc(buflen + 8, GFP_KERNEL);
  	if (!resblk)
  		return -ENOMEM;

