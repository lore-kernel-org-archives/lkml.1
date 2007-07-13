Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXGMS0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXGMS0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbXGMS0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:26:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61597 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbXGMS0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:26:31 -0400
Date: Fri, 13 Jul 2007 20:25:47 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Use BIOS Keyboard variable to set Numlock
In-Reply-To: <46958D9D.9090802@zytor.com>
Message-ID: <Pine.LNX.4.58.0707132017190.3034@be1.lrz>
References: <Pine.LNX.4.58.0707112305390.2432@be1.lrz> <46957CBF.1000101@zytor.com>
 <Pine.LNX.4.58.0707120321200.28727@be1.lrz> <46958D9D.9090802@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+lwXViVkjh2i2BEuEtPJzzkeN8OW4dyF1rJ3f
 JzdRX4lfmRiemnyCdZiXjSdQK2xdG5cuoWv21/cdwxqoKK2odt
 L3zP7rnq/zi76RYAqXZJw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, H. Peter Anvin wrote:
> Bodo Eggert wrote:

> >> That being said, one could argue that since this is a BIOS interface it
> >> should be queried via INT 16h, AH=02h and stuffed in the zeropage
> >> structure.  This would also solve the issue of it not being supported by
> >> non-BIOS firmware.
> > 
> > This is an interesting option, but it's more invasive. I'd rather like a 
> > feedback saying we can depend on that data area to be there.
> 
> I don't think we can.  You might find garbage there.

I asked you not to say that ...


Can somebody using LinuxBIOS or OpenFirmware please do

dd if=/dev/mem bs=1 count=1 skip=$((0x417)) | hexdump
 - and -
dd if=/dev/mem bs=1 count=14 skip=$((0x400)) | hexdump

You should get
 - one byte for the keyboard status, 0x20 == Numlock

 - seven words for the legacy serial and parallel ports, port address only
   (e.g. 03f8 02f8 0000 0000 0378 0000 0000)

-- 
C program run. C program crash. C programmer quit. 
