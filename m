Return-Path: <linux-kernel-owner+w=401wt.eu-S936232AbXGLA7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232AbXGLA7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936338AbXGLA7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:59:18 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936155AbXGLA7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:59:16 -0400
Message-ID: <46957CBF.1000101@zytor.com>
Date: Wed, 11 Jul 2007 17:58:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Use BIOS Keyboard variable to set Numlock
References: <Pine.LNX.4.58.0707112305390.2432@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707112305390.2432@be1.lrz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> 
> Instead of the byte at 0x497 as suggested in that thread, I'm using the 
> byte at 0x417, which reflects the intended LED state. In order to change 
> the keyboard LED, DOS programs would change this byte and call INT 5
> (which is the keyboard software interrupt).
> 

0x417 is actually the current keyboard modifier state, which is the
right thing to use.

Presumably you meant INT 9 (IRQ 1), not INT 5 which is the print screen
interrupt (also used by the CPU for BOUND error, which has some amusing
consequence if anyone ever used the BOUND instruction in DOS.)

That being said, one could argue that since this is a BIOS interface it
should be queried via INT 16h, AH=02h and stuffed in the zeropage
structure.  This would also solve the issue of it not being supported by
non-BIOS firmware.

	-hpa
