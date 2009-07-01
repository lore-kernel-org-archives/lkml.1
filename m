Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbZGASBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbZGASBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZGASBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:01:13 -0400
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:43738 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752309AbZGASBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:01:13 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: Problem with /proc/iomem on ARM
Date: Wed, 1 Jul 2009 14:01:14 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901A1383F@mi8nycmail19.Mi8.com>
In-Reply-To: <ac3eb2510907011055r5d5f06c1k754e52ebae88efab@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Problem with /proc/iomem on ARM
Thread-Index: Acn6dRnHtQ/T1viPRv+54bjhD/tnLQAAC+Gw
References: <BD79186B4FD85F4B8E60E381CAEE190901A13822@mi8nycmail19.Mi8.com> <ac3eb2510907011055r5d5f06c1k754e52ebae88efab@mail.gmail.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Jul 2009 18:01:15.0583 (UTC) FILETIME=[ED485CF0:01C9FA75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n61I1WoU031956

On Wednesday, July 01, 2009 10:55 AM, Kay Sievers wrote:
> On Wed, Jul 1, 2009 at 19:32, H Hartley wrote:
>> I just noticed a problem with /proc/iomem on my ARM system
>> that I think was introduced by your patch:
>>
>> commit 1d559e29138834bbcdf34ac072232bf543bfc4e0
>> Author: Kay Sievers <kay.sievers@vrfy.org>
>> Date: Â  Tue Jan 6 10:44:43 2009 -0800
>>
>> Â  Â arm: struct device - replace bus_id with dev_name(), dev_set_name()
>>
>> Â  Â Cc: Russell King <rmk@arm.linux.org.uk>
>> Â  Â Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>> Â  Â Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
>> This was seen with kernel 2.6.30. Â I havn't looked at /proc/iomem for
>> a while so I'm not sure when this first started.
>
> Are you sure, 8a577ffc75d9194fe8cdb7479236f2081c26ca1f isn't in your tree?

That commit is in my tree.  It appears that commit only fixes pci devices.
The serial ports on my system are amba bus devices.

> After all, it seems like this should be fixed in arm somewhere, not to
> copy and store internal driver core pointers, but use the device
> itself to retrieve the values.

Maybe the problem is in drivers/amba/bus.c? amba_device_register() does:

	dev->res.name = dev_name(&dev->dev);

But there is nothing in the code about setting the kobj.

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
