Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbXGWGQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbXGWGQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbXGWGQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:16:41 -0400
Received: from pcls1.std.com ([192.74.137.141]:46060 "EHLO TheWorld.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753872AbXGWGQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:16:41 -0400
From: Alan Curry <pacman@TheWorld.com>
Message-Id: <200707230616.l6N6GaPg1212004@shell01.TheWorld.com>
Subject: keyboard not found in 2.6.22.1
To: linux-kernel@vger.kernel.org
Date: Mon, 23 Jul 2007 02:16:36 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I boot 2.6.22.1 on my PegasosPPC, the PS/2 keyboard is not detected. It
works in 2.6.21.5. Both kernels have:
CONFIG_KEYBOARD_ATKBD=y
CONFIG_SERIO_I8042=y

The 2.6.21.5 kernel logs this stuff during boot:
  serio: i8042 KBD port at 0x60,0x64 irq 1
  serio: i8042 AUX port at 0x60,0x64 irq 12
  input: AT Translated Set 2 keyboard as /class/input/input0
  atkbd.c: keyboard reset failed on isa0060/serio1

(The "keyboard reset failed" has always been there and the keyboard has
always worked, it doesn't seem to indicate any actual problem)

The 2.6.22.1 doesn't log anything like those 4 lines. The only new thing that
shows up in 2.6.22.1 is
  console handover: boot [udbg0] -> real [tty0]

Aside from those lines, there's an exact line-for-line correspondence between
the boot logs.

I can log in over the network while running the broken kernel, but I'm not
sure what information I should be gathering once I'm in there.

In my attempt to understand the workings of input/serio/i8042.c, the only
result so far is that I noticed an unimportant typo in the 2.6.22 patch
("readinng" in the comment above i8042_toggle_aux).

