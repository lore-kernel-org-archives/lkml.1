Return-Path: <linux-kernel-owner+w=401wt.eu-S1030588AbXCLQ0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030588AbXCLQ0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXCLQ0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:26:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58808 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030588AbXCLQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:26:30 -0400
Date: Mon, 12 Mar 2007 12:26:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: rmmod uhci_hcd -> BUG: atomic counter underflow
In-Reply-To: <45F57B80.5000203@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703121223150.2489-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Jiri Slaby wrote:

> Hi.
> 
> After rmmoding of uhci_hcd on fresh booted 2.6.21-rc3-mm2 I got this:
> 
> BUG: atomic counter underflow at:
>   [<c0104f0b>] show_trace_log_lvl+0x1a/0x30
>   [<c01055f3>] show_trace+0x12/0x14
>   [<c010567a>] dump_stack+0x16/0x18
>   [<c01dc41b>] kref_put+0x4d/0xb2
>   [<c01db754>] kobject_put+0x14/0x16
>   [<c01db8a3>] kobject_unregister+0x22/0x25
>   [<c024c987>] bus_remove_driver+0x75/0x82
>   [<c024d3b8>] driver_unregister+0xb/0x18
>   [<c01e7020>] pci_unregister_driver+0x13/0x73
>   [<f88dbbd9>] uhci_hcd_cleanup+0xd/0x2d [uhci_hcd]
>   [<c013fb69>] sys_delete_module+0x133/0x195
>   [<c0103fe0>] syscall_call+0x7/0xb
>   =======================
> 
> Note, that this is connected:
> Bus 004 Device 001: ID 0000:0000
> Bus 003 Device 001: ID 0000:0000
> Bus 002 Device 004: ID 0458:004c KYE Systems Corp. (Mouse Systems) Slimstar 
> Pro Keyboard
> Bus 002 Device 003: ID 04b4:2050 Cypress Semiconductor Corp.
> Bus 002 Device 002: ID 045e:00f0 Microsoft Corp.
> Bus 002 Device 001: ID 0000:0000
> Bus 001 Device 001: ID 0000:0000
> Bus 005 Device 001: ID 0000:0000
> 
> What other info do you want me to post?

My guess is that this was caused by changes to the driver core, not by 
anything connected to USB.

Would it be possible for you to add the atomic counter underflow check to 
2.6.21-rc3 and see if the problem still occurs?  If it doesn't, that's a 
good indication the USB stack isn't guilty -- the bus registration code 
hasn't changed for several kernel releases.

Alan Stern

