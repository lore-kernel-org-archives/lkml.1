Return-Path: <linux-kernel-owner+w=401wt.eu-S935232AbZLGPHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935232AbZLGPHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935186AbZLGPHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:07:38 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:47084 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932728AbZLGPHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:07:36 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Mon, 7 Dec 2009 16:07:36 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0912041427550.3070-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912041427550.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3387
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912071607.38351.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009, Alan Stern wrote:
> > With uhci_hcd, rmmod works fine. With ehci_hcd, rmmod hangs the bus - all
> > urbs fail with -ENOENT:
> > f67265e8 1428021080 S Bi:1:009:2 -115 128 <
> > f67265e8 1431508327 C Bi:1:009:2 -108 0
> > f6726718 1458252464 S Co:1:007:0 s 40 09 0001 0000 0000 0
> > f6726718 1463261404 C Co:1:007:0 -2 0
> > f6726978 1463261428 S Co:1:002:0 s 23 08 0070 0001 0000 0
> > f6726718 1463261509 S Co:1:007:0 s 40 00 0000 0000 0000 0
> > f6726978 1464273397 C Co:1:002:0 -2 0
> > f6726718 1468273397 C Co:1:007:0 -2 0
>
> This may be a bug in ehci-hcd, a bug in your EHCI hardware, or a bug in
> the hub.  Can you try using a different high-speed hub to see if it
> makes any difference?

Just tried another hub. Now there are two hubs connected to separate ports
on the machine. Nexio is the only device connected to the "new" hub. No matter
where I connect the device or the 2nd hub, it always appears on "Bus 001":

Bus 002 Device 002: ID 041e:4068 Creative Technology, Ltd Webcam Live! Notebook
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 002: ID 413c:2003 Dell Computer Corp. Keyboard
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 002: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0 multicard reader
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 010: ID 1870:0001 Nexio Co., Ltd iNexio Touchscreen controller
Bus 001 Device 009: ID 088c:2030 Swecoin AB Ticket Printer TTP 2030
Bus 001 Device 008: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
Bus 001 Device 007: ID 065a:0001 Optoelectronics Co., Ltd Barcode scanner
Bus 001 Device 002: ID 2001:f103 D-Link Corp. [hex] DUB-H7 7-port USB 2.0 hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 005: ID 04cc:1521 Philips Semiconductors USB 2.0 Hub

The problem is still the same. Removing the module causes devices on the other
hub to fail.

Disconnecting the touchscreen first and then removing the module does not
cause any problems (with either of the hubs) - so it must be a software
problem.

-- 
Ondrej Zary
