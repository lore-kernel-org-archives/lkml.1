Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbXHAQgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbXHAQgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbXHAQgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:36:47 -0400
Received: from ns.suse.de ([195.135.220.2]:34147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbXHAQgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:36:46 -0400
Date: Wed, 1 Aug 2007 09:36:04 -0700
From: Greg KH <gregkh@suse.de>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       paulus@samba.org
Subject: Re: 2.6.23-rc1-mm2
Message-ID: <20070801163604.GC27879@suse.de>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708011002.30962.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708011002.30962.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 10:02:30AM +0200, Mariusz Kozlowski wrote:
> Then reattaching a usb mouse caused this (only once)
> 
> usb 2-1: USB disconnect, address 2
> BUG: atomic counter underflow at:
>  [<c010456a>] show_trace_log_lvl+0x1a/0x30
>  [<c010508d>] show_trace+0x12/0x14
>  [<c01051e0>] dump_stack+0x15/0x17
>  [<c01418cf>] __free_pages+0x50/0x52
>  [<c01418f0>] free_pages+0x1f/0x21
>  [<c010783d>] dma_free_coherent+0x43/0x9c
>  [<c0315067>] hcd_buffer_free+0x43/0x6a
>  [<c030b2b4>] usb_buffer_free+0x23/0x29
>  [<c0346db4>] hid_free_buffers+0x23/0x71
>  [<c0346eb2>] hid_disconnect+0xb0/0xc8
>  [<c0313676>] usb_unbind_interface+0x30/0x72
>  [<c02c6df0>] __device_release_driver+0x6a/0x92
>  [<c02c71c3>] device_release_driver+0x20/0x36
>  [<c02c6736>] bus_remove_device+0x62/0x85
>  [<c02c49f8>] device_del+0x16d/0x27c
>  [<c0310f25>] usb_disable_device+0x7a/0xe2
>  [<c030d0bc>] usb_disconnect+0x94/0xde
>  [<c030e030>] hub_thread+0x2fe/0xc1b
>  [<c0128aee>] kthread+0x36/0x58
>  [<c0104233>] kernel_thread_helper+0x7/0x14
>  =======================
> uhci_hcd 0000:00:0c.0: dma_pool_free buffer-32, 6b6b6b6b/6b6b6b6b (bad dma)
> 
> Every new try shows:
> 
> usb 2-1: new low speed USB device using uhci_hcd and address 3
> usb 2-1: new device found, idVendor=046d, idProduct=c00e
> usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
> usb 2-1: Product: USB-PS/2 Optical Mouse
> usb 2-1: Manufacturer: Logitech
> usb 2-1: configuration #1 chosen from 1 choice
> input: Logitech USB-PS/2 Optical Mouse as /class/input/input9
> input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:0c.0-1
> usb 2-1: USB disconnect, address 3
> uhci_hcd 0000:00:0c.0: dma_pool_free buffer-32, 6b6b6b6b/6b6b6b6b (bad dma)
> 
> But mouse works ok.

Can you see if the patch posted by Jiri fixes this or not?

thanks,

greg k-h
