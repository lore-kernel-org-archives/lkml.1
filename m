Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbXLGXDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbXLGXDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbXLGXDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:03:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754394AbXLGXDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:03:12 -0500
Date: Fri, 7 Dec 2007 15:02:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
Message-Id: <20071207150251.a0dbae23.akpm@linux-foundation.org>
In-Reply-To: <1197059904.15428.15.camel@localhost>
References: <1197059904.15428.15.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2007 20:38:24 +0000
Zan Lynx <zlynx@acm.org> wrote:

> While I'm reporting problems I'll get this one out there.
> 
> I normally use a USB-2 memory card reader but I also have a PCMCIA
> CompactFlash adapter that I use occasionally.  During the MM series
> kernels 2.6.22 and 23 (I am pretty sure) this didn't work at all.  I
> don't know about vanilla since I don't run that.
> 
> Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again, but I
> only get read rates of 1.6 MB/s.  When it used to work in 2.6.20 I got
> at least 16 MB/s.  The card itself is capable of 30+ in the USB-2
> reader.
> 
> It might be that it auto-configures for PIO-0.  I have no idea why it
> does that.
> 
> Another interesting thing is that doing a dd to or from the card brings
> the rest of the system to a nearly complete halt.  Interrupt problem?

Are we talking about this?


Yenta: CardBus bridge found at 0000:02:04.0 [103c:006d]
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 00003000-000030ff
  IO window: 00003400-000034ff
  PREFETCH window: 50000000-53ffffff
  MEM window: e0400000-e07fffff
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:04.0, mfunc 0x01111d22, devctl 0x64
Yenta: ISA IRQ mask 0x0cf8, PCI irq 19
Socket status: 30000051
Yenta: Raising subordinate bus# of parent bus (#02) from #02 to #06
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x7fff
pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe17fffff
pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x57ffffff
Yenta: CardBus bridge found at 0000:02:04.1 [103c:006d]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:04.1, mfunc 0x01111d22, devctl 0x64
Yenta: ISA IRQ mask 0x0cf8, PCI irq 18
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #06 to #0a
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x7fff
pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe17fffff
pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x57ffffff
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
pccard: PCMCIA card inserted into slot 0
cs: memory probe 0x50000000-0x57ffffff: excluding 0x50000000-0x57ffffff
cs: memory probe 0xe0100000-0xe17fffff: excluding 0xe0100000-0xe026ffff 0xe03e0000-0xe082ffff 0xe0b10000-0xe10cffff
pcmcia: registering new device pcmcia0.0

> It might be that it auto-configures for PIO-0.  I have no idea why it
> does that.
> 
> Another interesting thing is that doing a dd to or from the card brings
> the rest of the system to a nearly complete halt.  Interrupt problem?

Where are you seeing the evidence that it autoconfigures for PIO-0?

