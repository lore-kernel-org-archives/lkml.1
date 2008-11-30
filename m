Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYK3Nof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYK3Nof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYK3No0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:44:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:8127 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYK3No0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:44:26 -0500
Message-ID: <ac3eb2510811300544r2b228a85n86553d6657ac5578@mail.gmail.com>
Date: Sun, 30 Nov 2008 14:44:24 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fix pktcdvd breakage from commit e105b8bfc769b0545b6f0f395179d1e43cbee822
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, gregkh@suse.de,
       petero2@telia.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081130134048.GA28946@ZenIV.linux.org.uk>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 14:40, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Nov 30, 2008 at 01:32:29PM +0000, Al Viro wrote:
>> On Sun, Nov 30, 2008 at 02:25:43PM +0100, Kay Sievers wrote:
>>
>> > Pktcdvd creates char _and_ block device nodes at the same time, while
>> > the char nodes are not allocated, but created and conflict in
>> > /sys/dev/ with properly allocated ones from other subsystems. Your
>> > patch just papers over this bug.
>>
>> Where the hell is it creating any char device nodes?  Show me.
>> And note that device_create() is not creating *any* device nodes,
>> char or block.  It creates a directory in some place in sysfs,
>> associated with struct device (which has arseloads of uses unrelated
>> to block *or* char devices) and, if dev_t argument is non-zero,
>> dumps its value into one of the attributes.
>>
>> These days it might also dump a symlink into /sys/dev/*.
>>
>> Which part of the above constitutes a creation of char device node?
>
> Wait a minute...  Are you saying that something in userland ends up
> seeing that sucker, noticing .../dev and proceeding to do mknod?

Sure, it does mkod, as the kernel says it should. But that does not
cause any real problem.

These device nodes are not used for anything. Opening the created char
pktcdvd device node in userspace would in many cases just open a
random usb device. :)

Kay
