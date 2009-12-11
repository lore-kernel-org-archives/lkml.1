Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbZLKSvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbZLKSvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbZLKSvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:51:49 -0500
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:36913 "EHLO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbZLKSvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:51:48 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] i2c-iop3xx.c: fix memory resource
Date: Fri, 11 Dec 2009 13:51:55 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB1072@mi8nycmail19.Mi8.com>
In-Reply-To: <1260556842.18299.34.camel@Joe-Laptop.home>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i2c-iop3xx.c: fix memory resource
Thread-Index: Acp6kXLIdGLq4d1ySsW1YMzD+tYFPgAARwgg
References: <BD79186B4FD85F4B8E60E381CAEE190901FB1063@mi8nycmail19.Mi8.com> <1260556842.18299.34.camel@Joe-Laptop.home>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Joe Perches" <joe@perches.com>
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       <linux-i2c@vger.kernel.org>, <khali@linux-fr.org>,
       "Ben Dooks" <ben-linux@fluff.org>,
       "Lennert Buytenhek" <buytenh@wantstofly.org>,
       <dan.j.williams@intel.com>
X-OriginalArrivalTime: 11 Dec 2009 18:51:54.0720 (UTC) FILETIME=[02151E00:01CA7A93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nBBIqK16002617

On Friday, December 11, 2009 11:41 AM, Joe Perches wrote:
> On Fri, 2009-12-11 at 13:32 -0500, H Hartley Sweeten wrote:
>> The i2c-iop3xx driver requires a resource region of 0x18 bytes and
>> currently uses the magic number IOP3XX_I2C_IO_SIZE (defined in
>> i2c-iop3xx.h) to indicate this.  All of the users of this driver
>> have a platform memory resource so use resource_size() instead of
>> the magic number.  This requires fixing a couple of the memory
>> resources since they were either off by 1 or just wrong.
>[]
>>  static struct resource iop13xx_i2c_0_resources[] = {
>>  	[0] = {
>>  		.start = IOP13XX_I2C0_PHYS,
>> -		.end = IOP13XX_I2C0_PHYS + 0x18,
>> +		.end = IOP13XX_I2C0_PHYS + 0x17,
>
> etc.
>
>> -#define	IOP3XX_I2C_IO_SIZE	0x18
>
> Maybe it's clearer to keep the IO_SIZE define
> and let the compiler do the adding.
>
> .start = FOO;
> .end = FOO + IOP3XX_I2C_IO_SIZE - 1;

The problem with that, right now, is that IOP3XX_I2C_IO_SIZE is
defined in drivers/i2c/busses/i2c-iop3xx.h.  All the platform
users under arch/arm would have a pretty oddball include.

Also, that header really should just go away and all the information
in it just moved into the driver.

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
