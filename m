Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXC3VXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXC3VXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbXC3VX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:23:28 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:54337 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbXC3VXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:23:06 -0400
Message-ID: <460D7F70.3090702@gmail.com>
Date: Fri, 30 Mar 2007 23:21:52 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: mcdx -- do_request(): non-read command to cd!!
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al.

GIT doesn't remember, it's been too long, but IIRC you were the last one 
to do some work on mcdx (the old proprietary mitsumi cd-rom driver). The 
thing builds without warnings on 2.6.20.4, unlike most other proprietary 
CD-ROM drivers, so someone did...

In any case, I just bet you're positively thrilled receiving bug-reports 
for the thing right? Mmm?

I dug up a 1-speed Mitsumi CRMC-LU005S today. Brilliant drive! You push 
on the front, after which it comes loose and you then yank the entire 
drive, mechanism and all, out of its casing over some kind of magnetic 
resistance it seems and then open a _second_ top-loading door, put in 
the CD and follow the procedure backwards again. I've done that at least 
20 times now and I'm not by any means done yet. Brilliant.

The drive works fine under DOS (*), with both IRQ-less and IRQ-enabled 
controllers. The linux driver does not work though:

root@5va2:~# modprobe mcdx

root@5va2:~# dmesg | tail -4
mcdx Version 2.14(hs)
mcdx $Id: mcdx.c,v 1.21 1997/01/26 07:12:59 davem Exp $
Uniform CD-ROM driver Revision: 3.20
  mcdx: Mitsumi CD-ROM installed at 0x300, irq 15. (Firmware version M 4)

root@5va2:~# mount /dev/mcdx0 /mnt/cdrom
mount: block device /dev/mcdx0 is write-protected, mounting read-only
mount: /dev/mcdx0: can't read superblock

root@5va2:~# dmesg | tail -4
  mcdx: Mitsumi CD-ROM installed at 0x300, irq 15. (Firmware version M 4)
mcdx do_request(): non-read command to cd!!
end_request: I/O error, dev mcdx0, sector 0
FAT: unable to read boot sector
root@5va2:~#

This same 300/15 pair works under DOS in the same machine and IRQ15 is 
firing. The error sounds very block-ish. Would you happen to know?

I'll happily test patches :-)

Rene.

(*) Mitsumi not only has the old DOS driver online, it even keeps a 
scanned manual available:

http://www.mitsumi.com/enduser/1_drivers.html#Manuals

