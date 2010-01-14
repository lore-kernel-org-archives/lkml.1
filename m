Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046Ab0ANXbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab0ANXbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830Ab0ANXbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:31:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56142 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754214Ab0ANXbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:31:50 -0500
Date: Thu, 14 Jan 2010 23:34:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Neil Schemenauer <nas@arctrix.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: ATA error with Asus A7VX board
Message-ID: <20100114233457.1af3e06a@lxorguk.ukuu.org.uk>
In-Reply-To: <20100114232037.GA17411@arctrix.com>
References: <20100114232037.GA17411@arctrix.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [  366.463909] spurious 8259A interrupt: IRQ7.
> [ 5432.078546] hda: task_no_data_intr: status=0x30 { DeviceFault SeekComplete }
> [ 5432.078555] hda: possibly failed opcode: 0xb0
> [ 5462.224012] hda: lost interrupt

DeviceFault comes from the drive

> ata4.00: failed command: READ DMA
> ata4.00: cmd c8/00:18:4f:27:1b/00:00:00:00:00/e0 tag 0 dma 12288 in
>          res 51/10:18:4f:27:1b/00:00:00:00:00/a0 Emask 0x81 (invalid argument)
> ata4.00: status: { DRDY ERR }
> ata4.00: error: { IDNF }

IDNF - ID not found. The drive couldn't find the sector you requested.
Some drives do this if they get an invalid sector number in the command
but that doesn't look to be the case this time.

> I'm attaching the kernel log for the pata_via and ide setups and the
> output from lspci.

I'd say its a busted drive. If you had bad cables I'd expect to see CRC
errors not IDNF.

Alan
