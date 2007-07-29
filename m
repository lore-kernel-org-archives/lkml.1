Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbXG2OhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbXG2OhE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762686AbXG2Ogy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:36:54 -0400
Received: from dsl017-112-251.lax1.dsl.speakeasy.net ([69.17.112.251]:39577
	"EHLO NickAndBarb.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762555AbXG2Ogy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:36:54 -0400
Date: Sun, 29 Jul 2007 07:36:02 -0700
From: Nick Pasich <NewsLetters@NickAndBarb.net>
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: Nick Pasich <NewsLetters@NickAndBarb.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <greg@kroah.com>,
       Al Borchers <alborchers@steinerpoint.com>, linux-kernel@vger.kernel.org,
       Peter Berger <pberger@brimson.com>
Subject: Re: [linux-usb-devel] Edgeport UPS Monitoring Problems
Message-ID: <20070729143602.GA14118@69.17.112.251>
References: <20070727203708.GA10839@NICK2> <20070727152254.202959c1.akpm@linux-foundation.org> <003701c7d16c$8c72b7b0$03c8a8c0@kroptech.com> <20070729124813.GA30633@69.17.112.251> <008001c7d1e9$6a8625b0$03c8a8c0@kroptech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008001c7d1e9$6a8625b0$03c8a8c0@kroptech.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam,

Yep..... That did it....

Thank You Very Much for your Super Quick Fix......

         ---( Nick )---

On Sun, Jul 29, 2007 at 10:04:44AM -0400, Adam Kropelin wrote:
> From: "Nick Pasich" <NewsLetters@NickAndBarb.net>
> >Here's the dmesg output ......
> >
> >[...]
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: LCR - 
> >write to send_cmd_write_uart_register register 0x03
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> >SendCmdWriteUartReg - Not writing to MCR Register
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: MCR - 
> >write to send_cmd_write_uart_register register 0x0b
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> >SendCmdWriteUartReg - Not writing to MCR Register
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> >change_port_settings - baud rate = 9600
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> >SendCmdWriteBaudRate - NOT Setting baud rate for port = 0, baud = 9600
> 
> Yup, there's what I expected. Not setting the baud rate and not writing 
> status registers is unlikely to produce working results. This 9600 must 
> be the default setting being applied.
> 
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> >SendCmdWriteUartReg - Not writing to MCR Register
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: MCR - 
> >write to send_cmd_write_uart_register register 0x0b
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> >SendCmdWriteUartReg - Not writing to MCR Register
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> >change_port_settings - baud rate = 2400
> >Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: 
> >SendCmdWriteBaudRate - NOT Setting baud rate for port = 0, baud = 2400
> 
> Here's apcupsd trying to set 2400 baud.
> 
> Please try the attached patch (against 2.6.22.1). This will allow 
> writing to the baud rate and MCR/LCR registers on non-EPIC adapters. I 
> suspect the previous code was a copy-paste error.
> 
> --Adam



-- 
--------
WebSite: http://NickAndBarb.net
--------

