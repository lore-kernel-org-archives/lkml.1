Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZF3VBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZF3VBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbZF3VA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:00:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57799 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753849AbZF3VA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:00:58 -0400
Date: Tue, 30 Jun 2009 17:01:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arseniy Lartsev <ars3n@yandex.ru>
cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: USB ACM device does not work
In-Reply-To: <200907010009.51237.ars3n@yandex.ru>
Message-ID: <Pine.LNX.4.44L0.0906301656440.5222-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Arseniy Lartsev wrote:

> On Tuesday 30 June 2009 11:22:04 Oliver Neukum wrote:
> > Yet, your device shows bulk endpoints. Please enable DEBUG in cdc-acm.c
> > and recompile with CONFIG_USB_DEBUG.
> 
> I've recompiled four modules usbcore, ehci_hcd, ohci_hcd and cdc-acm with -DDEBUG.
> Here is kernel log:
> 
> ======================== Device plugged in ========================
...
> Jun 30 23:58:35 noteb00k kernel: usb 2-3: new low speed USB device using ohci_hcd and address 5                        
...
> Jun 30 23:58:35 noteb00k kernel: usb 2-3: config 1 interface 1 altsetting 0 endpoint 0x1 is Bulk; changing to 
> Interrupt
> Jun 30 23:58:35 noteb00k kernel: usb 2-3: config 1 interface 1 altsetting 0 endpoint 0x81 is Bulk; changing to 
> Interrupt                                                                                                                      

This looks like your problem.  Low-speed devices are not allowed to 
have bulk endpoints.  Linux internally changes them to interrupt 
endpoints with interval = 1 and maxpacket size no larger than 8.

Alan Stern

