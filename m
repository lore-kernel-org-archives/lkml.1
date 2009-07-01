Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZGASrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZGASrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZGASrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:47:09 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46873 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZGASrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901A13854@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901A13822@mi8nycmail19.Mi8.com> 
	<ac3eb2510907011055r5d5f06c1k754e52ebae88efab@mail.gmail.com> 
	<BD79186B4FD85F4B8E60E381CAEE190901A1383F@mi8nycmail19.Mi8.com> 
	<ac3eb2510907011112k690e5c38y2a8871dde5db1f13@mail.gmail.com> 
	<BD79186B4FD85F4B8E60E381CAEE190901A13854@mi8nycmail19.Mi8.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 1 Jul 2009 20:46:55 +0200
Message-ID: <ac3eb2510907011146o25204845i9deb0ebdd114f655@mail.gmail.com>
Subject: Re: Problem with /proc/iomem on ARM
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 20:24, H Hartley
Sweeten<hartleys@visionengravers.com> wrote:
> On Wednesday, July 01, 2009 11:13 AM, Kay Sievers wrote:
>>> The serial ports on my system are amba bus devices.
>>>
>>>> After all, it seems like this should be fixed in arm somewhere, not to
>>>> copy and store internal driver core pointers, but use the device
>>>> itself to retrieve the values.
>>>
>>> Maybe the problem is in drivers/amba/bus.c? amba_device_register() does:
>>>
>>>        dev->res.name = dev_name(&dev->dev);
>>
>> Looks like. If you get the name directly from dev->init_name. Does that work?
>>
>
> The following patch does fix /proc/iomem for the amba uarts on my system.
> Is this the correct approach to fixing the issue?

Looks fine to work around the issue that statically allocated struct
devices can cause. The proper fix would be to convert them to dynamic
objects and get rid of .init_name entirely.

Thanks,
Kay
