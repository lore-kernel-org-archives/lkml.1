Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0CHVqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:46:35 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:43794 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0CHVq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:46:29 -0500
Message-ID: <4B956F9E.8020304@oracle.com>
Date: Mon, 08 Mar 2010 13:43:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ben Dooks <ben@fluff.org>
CC: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
       linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       Jean Delvare <khali@linux-fr.org>, xtfeng@gmail.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] i2c: Add support for Xilinx XPS IIC Bus	Interface
References: <4B94C951.6050703@pelagicore.com> <20100308150121.GW10014@trinity.fluff.org>
In-Reply-To: <20100308150121.GW10014@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B95700C.019C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/10 07:01, Ben Dooks wrote:
> On Mon, Mar 08, 2010 at 10:54:25AM +0100, Richard Röjfors wrote:
>> Here is an updated patch due to build failure in linux-next.
>>
>> This patch also contains the header file that was missing in v3.
> 
> Please just send what is missing, now the base is merged it is difficult
> to get it removed.

and sooner would be better than later since linus-mainline does not build cleanly
due to this.

(more below)

>> diff --git a/include/linux/i2c-xiic.h b/include/linux/i2c-xiic.h
>> new file mode 100644
>> index 0000000..4f9f225
>> --- /dev/null
>> +++ b/include/linux/i2c-xiic.h
>> @@ -0,0 +1,43 @@
>> +/*
>> + * i2c-xiic.h
>> + * Copyright (c) 2009 Intel Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + */
>> +
>> +/* Supports:
>> + * Xilinx IIC
>> + */
>> +
>> +#ifndef _LINUX_I2C_XIIC_H
>> +#define _LINUX_I2C_XIIC_H
>> +
>> +/**
>> + * struct xiic_i2c_platform_data - Platform data of the Xilinx I2C driver
>> + * @num_devices:	Number of devices that shall be added when the driver
>> + *			is probed.
>> + * @devices:		The actuall devices to add.

				    actual

>> + *
>> + * This purpose of this platform data struct is to be able to provide a number
>> + * of devices that should be added to the I2C bus. The reason is that sometimes
>> + * the I2C board info is not enough, a new PCI board can for instance be
>> + * plugged into a standard PC, and the bus number might be unknown at
>> + * early init time.
>> + */
>> +struct xiic_i2c_platform_data {
>> +	u8				num_devices;
>> +	struct i2c_board_info const	*devices;
>> +};
>> +
>> +#endif /* _LINUX_I2C_XIIC_H */


And it still needs this patch that I have sent since Feb. 04-2010:

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file to fix build error:

drivers/i2c/busses/i2c-xiic.c:493: error: implicit declaration of function 'mdelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/busses/i2c-xiic.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100204.orig/drivers/i2c/busses/i2c-xiic.c
+++ linux-next-20100204/drivers/i2c/busses/i2c-xiic.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
