Return-Path: <linux-kernel-owner+w=401wt.eu-S965153AbXDWQUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153AbXDWQUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXDWQUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:20:31 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:13178 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965153AbXDWQUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:20:30 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Date: Mon, 23 Apr 2007 18:20:27 +0200
User-Agent: KMail/1.8.2
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1791
Subject: [PATCH] ib_core: Add missing device link to class device
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200704231820.27752.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing device link from /sys/class/infiniband/* to the actual device.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

 sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.20/drivers/infiniband/core/sysfs.c.old    2007-04-23 15:37:37.000000000 +0200
+++ linux-2.6.20/drivers/infiniband/core/sysfs.c        2007-04-23 15:38:22.000000000 +0200
@@ -683,6 +683,7 @@ int ib_device_register_sysfs(struct ib_d

        class_dev->class      = &ib_class;
        class_dev->class_data = device;
+       class_dev->dev        = device->dma_device;
        strlcpy(class_dev->class_id, device->name, BUS_ID_SIZE);

        INIT_LIST_HEAD(&device->port_list);

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239

