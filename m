Return-Path: <linux-kernel-owner+w=401wt.eu-S934437AbYEBQxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbYEBQxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762378AbYEBQxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:53:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57626 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369AbYEBQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:53:11 -0400
Date: Fri, 2 May 2008 09:14:47 -0700
From: Greg KH <greg@kroah.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25.1, stray noise in dmesg
Message-ID: <20080502161447.GB6852@kroah.com>
References: <200805021126.15225.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805021126.15225.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 11:26:15AM -0400, Gene Heskett wrote:
> Greetings;
> 
> I just rebooted to 2.6.25.1, and was momentarily panic'd by the messages going by early in the boot, but on putting 2&2 
> together, found they were just noise.
> 
> >From dmesg:
> [root@coyote ~]# dmesg|grep unable
> [    2.093502] hub 1-0:1.0: unable to enumerate USB device on port 2
> [    2.248475] hub 1-0:1.0: unable to enumerate USB device on port 5
> [    2.454444] hub 1-0:1.0: unable to enumerate USB device on port 6
> And lsusb:
> [root@coyote ~]# lsusb
> Bus 001 Device 011: ID 04b8:010f Seiko Epson Corp. Perfection 1250
> Bus 001 Device 010: ID 046d:c510 Logitech, Inc.
> Bus 001 Device 009: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
> Bus 001 Device 008: ID 0409:0059 NEC Corp. HighSpeed Hub
> Bus 001 Device 007: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
> Bus 001 Device 006: ID 050d:0751 Belkin Components
> Bus 001 Device 002: ID 0409:0059 NEC Corp. HighSpeed Hub
> Bus 001 Device 001: ID 1d6b:0002
> Bus 003 Device 002: ID 0451:2046 Texas Instruments, Inc. TUSB2046 Hub
> Bus 003 Device 001: ID 1d6b:0001
> Bus 002 Device 003: ID 06a3:8021 Saitek PLC Eclipse II Keyboard
> Bus 002 Device 002: ID 04b8:0005 Seiko Epson Corp. Stylus Printer
> Bus 002 Device 001: ID 1d6b:0001
> 
> Indicating 3 empty ports, which is not correct either, but everything
> that is plugged in is accounted for.  However, if there is no device
> there, is it supposed to tell us?  In which case it should do that 2-3
> more times in dmesg.

That's because your hardware is trying to enumerate a device, yet there
really isn't one there at all.  Blame the hardware :)

This warning is new, but it's needed as we now notice if we fail to
enumerate a device that might really be there.

thanks,

greg k-h
