Return-Path: <linux-kernel-owner+w=401wt.eu-S1763760AbXFKANL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763760AbXFKANL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 20:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760540AbXFKAM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 20:12:58 -0400
Received: from smtpa1.aruba.it ([62.149.128.210]:43680 "HELO smtpa2.aruba.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1760576AbXFKAM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 20:12:57 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2007 20:12:57 EDT
Date: Mon, 11 Jun 2007 01:44:29 +0200
From: Federico Di Dio <eflags@paolyno.ath.cx>
To: linux-kernel@vger.kernel.org
Subject: Hidden IO-Ports: workarounded but WHY?
Message-ID: <20070610234429.GA2880@charm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: GNU/Linux(i686) 2.6.21.3
X-Spam-Rating: smtpa2.aruba.it 1.6.2 0/1000/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,
I have an IT8705F SuperIO on my motherboard and everything is working
but the voltage/temperature sensors (running kernel 2.6.21.3).
I read the specs and figured out how to get direct access to the chip:
you can setup it through IO port 0x2e (or 0x4e), and decide where the
sensors will be in the IO space (default: 0x290).
Everything about it is fine, but reading from (or writing to) ports
0x290-0x297 is useless (all I get is 0xff).

With a few lines of code I canged base port to 0xc00 and now it works,
it87.ko loads and works flawlessly; this puzzled me, so I tried a 2.4
kernel and discovered it just works, no need to change the base port.
I also look directly at the ports with DOS DEBUG and got the same
results.

A few facts:
1) The IT8705F is fine (BIOS, Win98, linux 2.4 are just happy
   about it);
2) it works with kernel 2.4.33.3, it doesn't with 2.6.17.13;
3) disabling ACPI, hotplug and everything I tried is irrelevant;
4) the bug is NOT related to the it87 driver: reading the ports
   right after a reboot (with no modules loaded) just returns 0xff,
   while I'm sure I should get reasonable values (I read the whole
   spec, so I'm not messing around with the wrong ports or anything like
   that); the it87 driver, however, finds the chip, but when it
   understands it's unable to do anything useful, it quits (ENODEV);
   after altering the io port to something different, it runs just fine;
5) the io ports are not used by other devices. From /proc/ioports:
   0201-0201 : ns558-pnp
   0330-0331 : MPU401 UART
   [...]
   03f8-03ff : serial
   0cf8-0cff : PCI conf1
   so 0x290-0x297 should be as good as 0xc00-0xc07;
6) I have no idea of what, in the kernel, can cause such a behaviour ;)

  I'm no kernel expert, but this sounds quite like an interesting
problem to me!
  I can produce a detailed report, if you need more informations, but
I'm not subscribed to the lkml, so please CC: me any answer.

Ciao,
Federico Di Dio
