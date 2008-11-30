Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYK3N5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYK3N5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYK3N5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:57:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:11172 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYK3N5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:57:16 -0500
Message-ID: <ac3eb2510811300557u4922699du87a62cfd29020db1@mail.gmail.com>
Date: Sun, 30 Nov 2008 14:57:14 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fix pktcdvd breakage from commit e105b8bfc769b0545b6f0f395179d1e43cbee822
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, gregkh@suse.de,
       petero2@telia.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081130135031.GB28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081130121909.GV28946@ZenIV.linux.org.uk>
	 <ac3eb2510811300441m2a551cc7nec0374bb7a707bb8@mail.gmail.com>
	 <20081130132118.GY28946@ZenIV.linux.org.uk>
	 <ac3eb2510811300525n2e47ccap65e897ac1c4adab5@mail.gmail.com>
	 <20081130133229.GZ28946@ZenIV.linux.org.uk>
	 <20081130134048.GA28946@ZenIV.linux.org.uk>
	 <ac3eb2510811300544r2b228a85n86553d6657ac5578@mail.gmail.com>
	 <20081130135031.GB28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 14:50, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Nov 30, 2008 at 02:44:24PM +0100, Kay Sievers wrote:
>
>> >> Which part of the above constitutes a creation of char device node?
>> >
>> > Wait a minute...  Are you saying that something in userland ends up
>> > seeing that sucker, noticing .../dev and proceeding to do mknod?
>>
>> Sure, it does mkod, as the kernel says it should. But that does not
>> cause any real problem.
>
> "It" being udev, presumably?

Yes, udev, mdev, and a few other tools people use to populate /dev
from the kernel supplied device information.

> What a mess...  How does drivers/usb/core/devio.c avoid essentially the same
> problem?

It's a special case, where two "struct device" have the same dev_t,
but they both point to and handle the same device, so it's fine. The
usb_device class is deprecated, no recent distro uses it, and will be
removed some day.

The /sys/dev/ is handled properly by doing:
  usb_classdev_class->dev_kobj = NULL;

Kay
