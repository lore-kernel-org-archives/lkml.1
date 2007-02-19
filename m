Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXBSNbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXBSNbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241AbXBSNbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:31:00 -0500
Received: from smtp.nokia.com ([131.228.20.173]:31072 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbXBSNa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:30:59 -0500
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <200702172214.55654.arnd@arndb.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165751.5845.28503.sendpatchset@localhost.localdomain>
	 <200702172214.55654.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 15:30:25 +0200
Message-Id: <1171891825.13817.53.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 13:30:25.0453 (UTC) FILETIME=[1CF50DD0:01C7542A]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219152657-3F310BB0-753786DF/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 22:14 +0100, Arnd Bergmann wrote:
> This approach doesn't seem to make sense at all. If the MTD device interface
> is flawed, the right approach should be to fix that instead. After all,
> there are not many users of the MTD interface, so you should be able to
> adapt them.

MTD interface is not flawed, why? It is a good abstraction for flash
chips. 

UBI provide too many new services to utilize MTD interface. UBI != MTD,
but UBI may behave like MTD, although it is wider.

> In fact, I would expect that there is much more reason to merge the existing
> MTD interface with the block interface in the kernel

I do not think so, but the idea sounds exciting, please, talk to dwmw2
about this. But surely you know how different flash devices and HDD's
are: http://www.linux-mtd.infradead.org/faq/general.html

MTD devices are bare flashes.
Block devices are HDDs, MMCs, SDs, USB sticks, etc.

> but you now introduce
> a third interface that is unrelated to the first two

Why not? UBI is something which works on top of MTD, so it does relate
to MTD. But yes, it has nothing to do with block devices, I do not why
you talk about them. They are just irrelevant in my opinion, lets remove
them from discussion.

> , and make another
> conversion to convert it back?

All the the conversion things were created as debugging tools. I have
not heard anybody used them in production. But may be someone do, but
this is rare though and they must have _really good reasons_ for this.

> Let's assume I want to use the wear levelling capabilities of UBI on top
> of an SD card, and use the ext3 file system on top of it.

I do not see any point in this. SD card is a block device. It was
designed to be a block device. Using it for different purpose does not
look reasonable. Use bare flashes instead.

But technically it is possible to add block device back-end support to
UBI, but I do not know any real use-case for this.

>  I get a stack of
> 
> 1. MMC
Block device.
> 2. block2mtd
A debugging tool to develop flash software on host. Not normally used
for other purposes.
> 3. UBI
Close to MTD but also have a lot of new services.
> 4. gluebi
MTD devices emulated by UBI.
> 5. mtdblock
Stupid FTL driver, to emulated block devices on top of MTD. Too
straightforward, may only be used in RO mode. Any use in RW mode is
dangerous as you loose whole eraseblock in case of an unclean reboot.
> 6. VFS
Generalized FS view of the kernel.

> when in an ideal world, it should just be
> 
> 1. MMC
Just all block devices.
> 2. UBI
Is MTD here?


-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

