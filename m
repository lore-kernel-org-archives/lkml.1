Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbZGHWKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbZGHWKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZGHWJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:09:56 -0400
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:58364 "HELO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758483AbZGHWJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:09:54 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: Problem with /proc/iomem on ARM
Date: Wed, 8 Jul 2009 18:09:51 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901A689D3@mi8nycmail19.Mi8.com>
In-Reply-To: <ac3eb2510907011146o25204845i9deb0ebdd114f655@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Problem with /proc/iomem on ARM
Thread-Index: Acn6fFjScMtTTYugSSGknQ8Ieg+ybAFm9+Gg
References: <BD79186B4FD85F4B8E60E381CAEE190901A13822@mi8nycmail19.Mi8.com> <ac3eb2510907011055r5d5f06c1k754e52ebae88efab@mail.gmail.com> <BD79186B4FD85F4B8E60E381CAEE190901A1383F@mi8nycmail19.Mi8.com> <ac3eb2510907011112k690e5c38y2a8871dde5db1f13@mail.gmail.com> <BD79186B4FD85F4B8E60E381CAEE190901A13854@mi8nycmail19.Mi8.com> <ac3eb2510907011146o25204845i9deb0ebdd114f655@mail.gmail.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Jul 2009 22:09:52.0710 (UTC) FILETIME=[D1798E60:01CA0018]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n68MAWXx029080

On Wednesday, July 01, 2009 11:47 AM, Kay Sievers wrote:
> On Wed, Jul 1, 2009 at 20:24, H Hartley Sweeten wrote:
>> On Wednesday, July 01, 2009 11:13 AM, Kay Sievers wrote:
>>>> The serial ports on my system are amba bus devices.
>>>>
>>>>> After all, it seems like this should be fixed in arm somewhere,
>>>>> not to copy and store internal driver core pointers, but use the
>>>>> device itself to retrieve the values.
>>>>
>>>> Maybe the problem is in drivers/amba/bus.c? amba_device_register()
>>>> does:
>>>>
>>>> Â  Â  Â  Â dev->res.name = dev_name(&dev->dev);
>>>
>>> Looks like. If you get the name directly from dev->init_name. Does
>>> that work?
>>>
>>
>> The following patch does fix /proc/iomem for the amba uarts on my
>> system.  Is this the correct approach to fixing the issue?
>
> Looks fine to work around the issue that statically allocated struct
> devices can cause. The proper fix would be to convert them to dynamic
> objects and get rid of .init_name entirely.

Disregard.

Russell King added a patch that fixed the issue.  I just showed up.

commit 557dca5f48a45df88a73e69ee0700cfd4e2358c9
Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
Date:   Sun Jul 5 22:39:08 2009 +0100

    [ARM] amba: fix amba device resources

    AMBA device resources were being reported as:

    10004000-10004fff : <BAD>

    This is because dev_name() was returning NULL prior to device_register.
    Ensure that the struct device is properly initialized, and the name is
    set before adding it to the device tree.

    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
