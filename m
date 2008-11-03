Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbYKCSmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbYKCSmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYKCSme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:42:34 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:6923 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbYKCSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:42:33 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Some minor ugliness in changed boot logging
Date: Mon, 3 Nov 2008 19:42:19 +0100
User-Agent: KMail/1.9.9
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       David Brownell <dbrownell@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031942.20360.elendil@planet.nl>
X-OriginalArrivalTime: 03 Nov 2008 18:42:20.0915 (UTC) FILETIME=[E7982C30:01C93DE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Toshiba Satellite (i386):
yenta_cardbus 0000:01:0b.0: ISA IRQ mask 0x0c38, PCI irq 18
yenta_cardbus 0000:01:0b.0: Socket status: 30000020
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge I/O window: 0xc000 - 0xcfff
 : cs: IO port probe 0xc000-0xcfff: clean.
^^--- missing device ID

Note that a bit later the device ID _is_ present in the same message:
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0xcfe00000 - 0xcfefffff
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0x28000000 - 0x2bffffff
pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.

Due to:
commit dbe4ea5fde198a3808e46b665d889818c1e600f5
Author: Dominik Brodowski <linux@dominikbrodowski.net>
Date:   Sat Aug 2 21:36:19 2008 +0200
    pcmcia: use dev_printk in module rsrc_nonstatic


On HP 2510p (x86_64):
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, , hpet irqs irqs
                                                           ^^^^^^^^^--- "irqs" repeated
                                                   ^^--- missing value?
Due to:
commit c8fc40cd345bfd88d8a98e7916909b9143502999
Author: David Brownell <dbrownell@users.sourceforge.net>
Date:   Sat Oct 18 20:27:47 2008 -0700
    rtc-cmos: export second NVRAM bank

Cheers,
FJP
