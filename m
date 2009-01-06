Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZAFAhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZAFAhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZAFAgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:36:53 -0500
Received: from blaine.gmane.org ([80.91.229.8]:38640 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZAFAgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:36:53 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=jn6aa8d8CCRJg873L1wA:9 a=oFit9KpAV4Vr9Tg3-wRD75Yc894A:4 a=fzWx928WHQcA:10 a=w2uCo4zaT6UA:10
Message-ID: <4962A792.9070706@shaw.ca>
Date: Mon, 05 Jan 2009 18:36:34 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.usb.general,gmane.linux.kernel
To: Jiri Slaby 
	<public-jirislaby-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>
CC: David Brownell 
	<public-dbrownell-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@hugh.gmane.org>,
       USB list <public-linux-usb-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       Alan Stern 
	<public-stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@hugh.gmane.org>
Subject: Re: quirk_usb_disable_ehci takes 2x 1.5s on boot
References: <49620DF7.9040006@gmail.com>
In-Reply-To: <49620DF7.9040006@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jiri Slaby wrote:
> Hi,
> 
> I don't know since which moment (maybe I changed something in bios, but usb
> legacy kbd was ever enabled), but quirk_usb_disable_ehci takes for both of my
> ehci controllers 1.5 s.
> 
> More precisely, the time is spent in
> pci_write_config_byte(pdev, offset + 3, 1);
> by
> outb((u8)value, 0xCFC + (reg & 3));
> from pci_conf1_write deep in the callstack.
> 
> Is there any workaround known or something. Turning legacy usb off is not an
> option, I want to control grub.

Most likely the PCI config space write is causing some SMM trap and the 
BIOS is taking forever to do whatever it's doing. It doesn't report that 
the handoff failed, though?

I'd look for a BIOS update..

