Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXEVGLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXEVGLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbXEVGLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:11:09 -0400
Received: from plover.csun.edu ([130.166.1.24]:23653 "EHLO plover.csun.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbXEVGLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:11:08 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 02:11:08 EDT
Message-ID: <46528811.2010302@cyte.com>
Date: Mon, 21 May 2007 23:05:05 -0700
From: Jeff Wiegley <jeffw@cyte.com>
Organization: Cyte.Com, LLC
User-Agent: Thunderbird 1.5.0.10 (X11/20070401)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 8250_pnp is confused... (udev?)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've used serial ports a lot in the past but not for the
past year so. Did something fundamental change?

I have serial_core, 8250 and 8250_pnp modules installed
and things are quite weird... I get all of the /dev/ttyS's
that I DON'T have and none of the ones that I do!

$modprobe -a 8250_pnp
$tail /var/log/message
May 21 22:59:35 home Serial: 8250/16550 driver $Revision: 1.90 $ 4
ports, IRQ sharing disabled
May 21 22:59:35 home pnp: Device 00:07 activated.
May 21 22:59:35 home 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

So, yes it looks like it sees the one serial port that I also
think I have. but...

$ls -al /dev/ttyS*
crw-rw---- 1 root uucp 4, 65 May 21 22:59 /dev/ttyS1
crw-rw---- 1 root uucp 4, 66 May 21 22:59 /dev/ttyS2
crw-rw---- 1 root uucp 4, 67 May 21 22:59 /dev/ttyS3

It seems that somehow either 8250_pnp (or maybe udev) gets the
logic inverted. It doesn't create a device for the one device
that 8250_pnp found and yet it does create devices for everything
NOT found??

If I rmmod 8250_pnp 8250 serial_core then all the serial devices
go away. So it's 8250/udev creating these oddities and not me.

I am using gentoo with kernel v2.6.21.1 on an intel 64 bit dual-core
with Nvidia 580i chipset. I haven't tweaked any udev rules. udev is
version 104-r12.

Any help is appreciated. Thanks!

- Jeff
