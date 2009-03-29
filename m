Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZC2SG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZC2SG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 14:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZC2SGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 14:06:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:15508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZC2SGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 14:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <49CFB553.1020800@archlinux.org>
References: <49CF9BA1.5030400@archlinux.org> <20090329091148.16a618bf@infradead.org> 
	<49CFA436.5080000@archlinux.org> <ac3eb2510903291036w13dc34cbi97525e6dd9af1da5@mail.gmail.com> 
	<49CFB553.1020800@archlinux.org>
Date: Sun, 29 Mar 2009 20:06:00 +0200
Message-ID: <ac3eb2510903291106k27902bafpa8231d6781f8f5c@mail.gmail.com>
Subject: Re: fastboot/async and initramfs: How am I supposed to know when 
	devices are finished initializing?
From: Kay Sievers <kay.sievers@vrfy.org>
To: =?UTF-8?Q?Thomas_B=C3=A4chler?= <thomas@archlinux.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 19:52, Thomas Bächler <thomas@archlinux.org> wrote:
> Kay Sievers schrieb:
>>
>> In initramfs, you have to wait until the device shows up, not for a
>> random module to initialize, or a bus to be scanned -- that can never
>> work correctly, it's pure luck, that your logic was always slower than
>> the kernel.
>>
>> You need a block device -- so you should just wait for the block
>> device, instead of making assumptions about initialization of drivers
>> or buses. :)
>
> I am planning to do that but there is one problem: Usually, the user
> specifies a root device, or a device that I want to open with cryptsetup, or
> anything similar and I can wait until it shows up.

Right, you have to run the tools until the have found all what they
need to give you your root device. Please ask the device mapper
developers to port their stuff to the year 2009. :)

> For lvm however, the user does not specify a specific block device that I
> can wait for, instead lvm scans all available block devices. Now, how do I
> know that the block device that contains my physical volume is already
> there? Maybe I have several hard drives, and several volume groups, so
> should I now call vgchange -ay again and again until the right volume group
> shows up?

Yeah, today, you just call the "broken" tools in a loop until they
give you the device you wait for. :(

Assembling meta devices, or multi-volume devices should be triggered
directly when the underlying devices show up. If auto-assembly (which
kind of works today with md's --incremental) is properly implemented,
you should still be able to just wait for the specified root device to
show up, but the dm/lvm guys need to get the stuff done they talk
about for years now. :)

Thanks,
Kay
