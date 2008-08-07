Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYHGNPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYHGNPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYHGNOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:14:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49527 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752336AbYHGNOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:14:42 -0400
Date: Thu, 7 Aug 2008 11:36:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Stuart <dstuart@rogers.com>
Cc: David Stuart <dstuart@rogers.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with disk + network on 2.6.25.11-60.fc8
Message-ID: <20080807113604.70447431@lxorguk.ukuu.org.uk>
In-Reply-To: <489A5336.5080904@rogers.com>
References: <48973EB9.90408@rogers.com>
	<20080804184232.601881a8@lxorguk.ukuu.org.uk>
	<4897671F.1050003@rogers.com>
	<20080804214441.0811138e@lxorguk.ukuu.org.uk>
	<48979079.9030409@rogers.com>
	<20080805001330.6d43bcbb@lxorguk.ukuu.org.uk>
	<489797A8.408@rogers.com>
	<489A5336.5080904@rogers.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It occurs to me that you might be implying there is some "chip config" 
> that I can retrieve and give to you. Is there anything I can/should do 
> in order to give you more information, or is this pretty much out of my 
> hands at this point?

There are two things you can play with. One is the UDMA burst mode on the
chip which should be getting set, the other is PCI latencies (which the
BIOS should have set up but you can play with)

> Should I be filing a bug report for this?

Probably a good idea

Next things to try are

1.	edit drivers/ata/pata_pdc202xx_old.c
	after the line

	iowrite8(burst | 0x01, bmdma + 0x1f);

add

	printk(KERN_ERR "BURST was %02X\n", burst);

build/install/boot that kernel and see what it says.

The second (sledgehammer) approach would be to use setpci to set the
LATENCY_TIMER value on the pdc202xx_old and network card differently.

Alan
