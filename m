Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0CIIRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:17:44 -0500
Received: from av7-2-sn3.vrr.skanova.net ([81.228.9.182]:58792 "EHLO
	av7-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab0CIIRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:17:41 -0500
Message-ID: <4B960420.8040804@pelagicore.com>
Date: Tue, 09 Mar 2010 09:17:36 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100121 Iceowl/1.0b1 Icedove/3.0.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ben Dooks <ben@fluff.org>, linux-i2c@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
       xtfeng@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] i2c: Add support for Xilinx XPS IIC Bus	Interface
References: <4B94C951.6050703@pelagicore.com> <20100308150121.GW10014@trinity.fluff.org> <4B956F9E.8020304@oracle.com>
In-Reply-To: <4B956F9E.8020304@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------080005070004060500060707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080005070004060500060707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

On 03/08/2010 10:43 PM, Randy Dunlap wrote:
> On 03/08/10 07:01, Ben Dooks wrote:
>> On Mon, Mar 08, 2010 at 10:54:25AM +0100, Richard Röjfors wrote:
>>> Here is an updated patch due to build failure in linux-next.
>>>
>>> This patch also contains the header file that was missing in v3.
>>
>> Please just send what is missing, now the base is merged it is difficult
>> to get it removed.
>
> and sooner would be better than later since linus-mainline does not build cleanly
> due to this.

Attached (mail client issues) is the patch with the missing header file.

And as Randy mentioned his patch below is needed too.

>
> (more below)
>
>>> diff --git a/include/linux/i2c-xiic.h b/include/linux/i2c-xiic.h
>>> new file mode 100644
>>> index 0000000..4f9f225
>>> --- /dev/null
>>> +++ b/include/linux/i2c-xiic.h
>>> @@ -0,0 +1,43 @@
>>> +/*
>>> + * i2c-xiic.h
>>> + * Copyright (c) 2009 Intel Corporation
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License
>>> + * along with this program; if not, write to the Free Software
>>> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>> + */
>>> +
>>> +/* Supports:
>>> + * Xilinx IIC
>>> + */
>>> +
>>> +#ifndef _LINUX_I2C_XIIC_H
>>> +#define _LINUX_I2C_XIIC_H
>>> +
>>> +/**
>>> + * struct xiic_i2c_platform_data - Platform data of the Xilinx I2C driver
>>> + * @num_devices:	Number of devices that shall be added when the driver
>>> + *			is probed.
>>> + * @devices:		The actuall devices to add.
>
> 				actual
>
>>> + *
>>> + * This purpose of this platform data struct is to be able to provide a number
>>> + * of devices that should be added to the I2C bus. The reason is that sometimes
>>> + * the I2C board info is not enough, a new PCI board can for instance be
>>> + * plugged into a standard PC, and the bus number might be unknown at
>>> + * early init time.
>>> + */
>>> +struct xiic_i2c_platform_data {
>>> +	u8				num_devices;
>>> +	struct i2c_board_info const	*devices;
>>> +};
>>> +
>>> +#endif /* _LINUX_I2C_XIIC_H */
>
>
> And it still needs this patch that I have sent since Feb. 04-2010:
>
> ---
>
> From: Randy Dunlap<randy.dunlap@oracle.com>
>
> Add header file to fix build error:
>
> drivers/i2c/busses/i2c-xiic.c:493: error: implicit declaration of function 'mdelay'
>
> Signed-off-by: Randy Dunlap<randy.dunlap@oracle.com>
> Cc: "Ben Dooks (embedded platforms)"<ben-linux@fluff.org>
> Cc: linux-i2c@vger.kernel.org
> ---
>   drivers/i2c/busses/i2c-xiic.c |    1 +
>   1 file changed, 1 insertion(+)
>
> --- linux-next-20100204.orig/drivers/i2c/busses/i2c-xiic.c
> +++ linux-next-20100204/drivers/i2c/busses/i2c-xiic.c
> @@ -31,6 +31,7 @@
>   #include<linux/module.h>
>   #include<linux/init.h>
>   #include<linux/errno.h>
> +#include<linux/delay.h>
>   #include<linux/platform_device.h>
>   #include<linux/i2c.h>
>   #include<linux/interrupt.h>



--------------080005070004060500060707
Content-Type: text/x-patch;
 name="xiic-platform.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="xiic-platform.patch"

This patch adds the platform data include for the Xilinx XPS IIC Bus Interface.

Signed-off-by: Richard RÃ¶jfors <richard.rojfors@pelagicore.com>
---
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

--------------080005070004060500060707--
