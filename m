Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab0CNMJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 08:09:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41634 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab0CNMJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 08:09:09 -0400
Date: Sun, 14 Mar 2010 23:05:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?B?IlJpY2hhcmQgUsO2amZvcnMi?= 
	<richard.rojfors@pelagicore.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ben Dooks <ben@fluff.org>,
       linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
       xtfeng@gmail.com, linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH, fix 1/2] Add the platform data include for the Xilinx XPS
 IIC Bus Interface
Message-Id: <20100314230525.352410e5.sfr@canb.auug.org.au>
In-Reply-To: <4B960420.8040804@pelagicore.com>
References: <4B94C951.6050703@pelagicore.com>
	<20100308150121.GW10014@trinity.fluff.org>
	<4B956F9E.8020304@oracle.com>
	<4B960420.8040804@pelagicore.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Richard Röjfors <richard.rojfors@pelagicore.com>
Date:	Tue, 09 Mar 2010 09:17:36 +0100

This file was missed in the original patch that went into Linus' tree.

Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---

Hi Linus,

This missing include file has been killing most (if not all) the
allmodconfig builds since March 9.  Please apply.  I have had the
equivalent of this patch in linux-next since then.

diff --git a/include/linux/i2c-xiic.h b/include/linux/i2c-xiic.h
new file mode 100644
index 0000000..4f9f225
--- /dev/null
+++ b/include/linux/i2c-xiic.h
@@ -0,0 +1,43 @@
+/*
+ * i2c-xiic.h
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/* Supports:
+ * Xilinx IIC
+ */
+
+#ifndef _LINUX_I2C_XIIC_H
+#define _LINUX_I2C_XIIC_H
+
+/**
+ * struct xiic_i2c_platform_data - Platform data of the Xilinx I2C driver
+ * @num_devices:	Number of devices that shall be added when the driver
+ *			is probed.
+ * @devices:		The actuall devices to add.
+ *
+ * This purpose of this platform data struct is to be able to provide a number
+ * of devices that should be added to the I2C bus. The reason is that sometimes
+ * the I2C board info is not enough, a new PCI board can for instance be
+ * plugged into a standard PC, and the bus number might be unknown at
+ * early init time.
+ */
+struct xiic_i2c_platform_data {
+	u8				num_devices;
+	struct i2c_board_info const	*devices;
+};
+
+#endif /* _LINUX_I2C_XIIC_H */

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
