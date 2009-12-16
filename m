Return-Path: <linux-kernel-owner+w=401wt.eu-S1762684AbZLPRoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762684AbZLPRoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762658AbZLPRoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:44:12 -0500
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:53503 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1762654AbZLPRoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:44:10 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] ep93xx_eth.c: general cleanup
Date: Wed, 16 Dec 2009 12:44:05 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200ECF5@mi8nycmail19.Mi8.com>
In-Reply-To: <1260984721.30093.23.camel@Joe-Laptop.home>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ep93xx_eth.c: general cleanup
Thread-Index: Acp+da610jNxN5cnTVmHWExYpv5hUAAACj0g
References: <BD79186B4FD85F4B8E60E381CAEE19090200ECDE@mi8nycmail19.Mi8.com> <1260984721.30093.23.camel@Joe-Laptop.home>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Joe Perches" <joe@perches.com>
Cc: "kernel list" <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       "Lennert Buytenhek" <kernel@wantstofly.org>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 16 Dec 2009 17:44:06.0145 (UTC) FILETIME=[5D169710:01CA7E77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nBGHiu16031287

On Wednesday, December 16, 2009 10:32 AM, Joe Perches wrote:

Added netdev to the Cc: list, and removed Nick M. (unintended)

> On Wed, 2009-12-16 at 12:09 -0500, H Hartley Sweeten wrote:
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
>
> I think KBUILD_MODNAME ":%s: " fmt, __func__
> or its equivalent direct use is more common.
> It's possibly useful to standardize.

I wasn't sure about that and could not find anything "standard" in mainline.
The biggest user of pr_fmt that I could find is in drivers/s390 and that
uses a local KMSG_COMPONENT define instead of KBUILD_MODNAME.

>> -#define DRV_MODULE_NAME		"ep93xx-eth"
>> -#define DRV_MODULE_VERSION	"0.1"
>> +#include <mach/hardware.h>
>
> I think these sorts of defines are common and useful.

I can add those back if needed.  Just seemed a waste to have the two defines
and only use them in one place.

>>  static int __init ep93xx_eth_init_module(void)
>>  {
>> -	printk(KERN_INFO DRV_MODULE_NAME " version " DRV_MODULE_VERSION " loading\n");
>
> Why remove this printk completely?

In my dmesg is just looks like noise.

ep93xx-eth version 0.1 loading
eth0: ep93xx on-chip ethernet, IRQ 39, 00:21:f5:00:00:17

If the drive loads correctly you will get the second line.  If it error's for
some reason you will get one of the dev_err messages.

But, if the defines go back in I can also add this message back.

Regards,
Hartley


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
