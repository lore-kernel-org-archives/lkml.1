Return-Path: <linux-kernel-owner+w=401wt.eu-S934623AbXGLBm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623AbXGLBm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764167AbXGLBmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:42:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759634AbXGLBmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:42:20 -0400
Date: Thu, 12 Jul 2007 03:41:03 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Use BIOS Keyboard variable to set Numlock
In-Reply-To: <46957CBF.1000101@zytor.com>
Message-ID: <Pine.LNX.4.58.0707120321200.28727@be1.lrz>
References: <Pine.LNX.4.58.0707112305390.2432@be1.lrz> <46957CBF.1000101@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19F7USN4amlbhn1nMXLhdyHTQaYNssheoW0Fxz
 z1wWVOiJYFD1rd4KrXpbUqPm8Kq1ZNWn/n6ct9nboYZkvq4MIy
 6tjWzqTriS5oGq75BsVZA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, H. Peter Anvin wrote:
> Bodo Eggert wrote:

> > Instead of the byte at 0x497 as suggested in that thread, I'm using the 
> > byte at 0x417, which reflects the intended LED state. In order to change 
> > the keyboard LED, DOS programs would change this byte and call INT 5
> > (which is the keyboard software interrupt).
> > 
> 
> 0x417 is actually the current keyboard modifier state, which is the
> right thing to use.

exactly.

> Presumably you meant INT 9 (IRQ 1), not INT 5 which is the print screen
> interrupt (also used by the CPU for BOUND error, which has some amusing
> consequence if anyone ever used the BOUND instruction in DOS.)

I meant int 0x16:
   mem[0x40:0x17] |= 0x20;
   ah = 1;
   int 0x16;

> That being said, one could argue that since this is a BIOS interface it
> should be queried via INT 16h, AH=02h and stuffed in the zeropage
> structure.  This would also solve the issue of it not being supported by
> non-BIOS firmware.

This is an interesting option, but it's more invasive. I'd rather like a 
feedback saying we can depend on that data area to be there.
-- 
Top 100 things you don't want the sysadmin to say:
64. Do you really need your home directory to do any work?
