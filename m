Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbXDZCIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbXDZCIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 22:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXDZCIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 22:08:12 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041AbXDZCIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 22:08:11 -0400
Date: Wed, 25 Apr 2007 19:07:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
Subject: Re: pcmcia - failed to initialize IDE interface
Message-Id: <20070425190753.fb8c272d.akpm@linux-foundation.org>
In-Reply-To: <D7810733513F4840B4EBAAFA64D9C6A4012D5E5F@stgw002a.ww002.siemens.net>
References: <D7810733513F4840B4EBAAFA64D9C6A4012D5E5F@stgw002a.ww002.siemens.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 15:27:26 +0200 "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com> wrote:

> Hi,
> 
> [kernel 2.6.20.7, arch=mips, processor=amd au1550]
> 
> I'm trying to install a 2.6 kernel on an Alchemy au1550, and having
> problem with the pcmcia socket, where I plugged a CompactFlash card. The
> card seems to be recognized by the kernel, appears in
> /sys/bus/pcmcia/devices, but not in /proc/bus/pccard, and I can't access
> the device (/dev/hda).
> 
> The relevant console messages:
> ----------------------------------------------------------------
> pccard: PCMCIA card inserted into slot 0
> pcmcia: registering new device pcmcia0.0
> hda: SanDisk SDCFB-64, CFA DISK drive
> ide0: Disabled unable to get IRQ 35.
> ide0: failed to initialize IDE interface
> ide0: I/O resource 0x10200E-0x10200E not free.
> ide0: ports already in use, skipping probe
> ide0: I/O resource 0x10200E-0x10200E not free.
> ide0: ports already in use, skipping probe
> ide0: I/O resource 0x10200E-0x10200E not free.
> ide0: ports already in use, skipping probe
> ide0: I/O resource 0x10200E-0x10200E not free.
> ide0: ports already in use, skipping probe
> ide0: I/O resource 0x10200E-0x10200E not free.
> ide0: ports already in use, skipping probe
> ide0: I/O resource 0x10200E-0x10200E not free.
> ide0: ports already in use, skipping probe
> ide0: I/O resource 0x10200E-0x10200E not free.
> ide0: ports already in use, skipping probe
> ide0: I/O resource 0x10200E-0x10200E not free.
> ide0: ports already in use, skipping probe
> ide0: I/O resource 0x10200E-0x10200E not free.
> ide0: ports already in use, skipping probe
> ide-cs: ide_register() at 0x102000 & 0x10200e, irq 35 failed
> ----------------------------------------------------------------
> 
> Here is the relevant part of the kernel config:
> CONFIG_IDE=y
> CONFIG_IDE_GENERIC=y
> CONFIG_BLK_DEV_IDE=y
> CONFIG_BLK_DEV_IDECS=y
> CONFIG_PCCARD=y
> CONFIG_PCMCIA_DEBUG=y
> CONFIG_PCMCIA=y
> CONFIG_PCMCIA_AU1X00=y
> 

(cc'ed linux-mips)

Perhaps /proc/ioports will tell us where the conflict lies.

The output of `dmesg -s 1000000' might also be needed.
