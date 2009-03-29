Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZC2Rh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZC2Rh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 13:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZC2RhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 13:37:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:11986 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZC2RhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 13:37:16 -0400
MIME-Version: 1.0
In-Reply-To: <49CFA436.5080000@archlinux.org>
References: <49CF9BA1.5030400@archlinux.org> <20090329091148.16a618bf@infradead.org> 
	<49CFA436.5080000@archlinux.org>
Date: Sun, 29 Mar 2009 19:36:59 +0200
Message-ID: <ac3eb2510903291036w13dc34cbi97525e6dd9af1da5@mail.gmail.com>
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

On Sun, Mar 29, 2009 at 18:39, Thomas Bächler <thomas@archlinux.org> wrote:
> Arjan van de Ven schrieb:
>>>
>>> Among other things, this loads the ata_piix on my machine. On older
>>> kernels I could assume that after these commands, /dev/sda* existed
>>
>> not if you have CONFIG_SCSI_SCAN_ASYNC set though..
>>
>>> and I could immediately access them (in my case, I run cryptsetup on
>>> /dev/sda6). But now, the devices don't exist here, but are only
>>> created a second or so later. As a result, the initramfs script has
>>> already bailed out as it couldn't find /dev/sda6 and assumed that the
>>> hard drive didn't exist.
>>
>> the CONFIG_SCSI_WAIT_SCAN method (basically loading that module to wait
>> for the scans to finish) will work for you......
>
> Thanks, I will integrate that into our initramfs. Will that also work for
> USB mass storage (which was already problematic with older kernels, you load
> the module you don't know how long it takes until the sdX devices are
> created)?

USB is interrupt driven, there is and will never be such a thing as
"scanned" or "settled" -- anything can come and go at any time.

In initramfs, you have to wait until the device shows up, not for a
random module to initialize, or a bus to be scanned -- that can never
work correctly, it's pure luck, that your logic was always slower than
the kernel.

You need a block device -- so you should just wait for the block
device, instead of making assumptions about initialization of drivers
or buses. :)

Thanks,
Kay
