Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbXHUHeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbXHUHeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXHUHdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:33:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53414 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbXHUHdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:33:52 -0400
Date: Tue, 21 Aug 2007 00:36:56 -0700
From: Greg KH <greg@kroah.com>
To: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel
	events? [u]
Message-ID: <20070821073656.GA6691@kroah.com>
References: <200708171622.05115.aj@ciphirelabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708171622.05115.aj@ciphirelabs.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 04:22:04PM +0200, Andreas Jellinghaus [c] wrote:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9f8b17e643fe6aa505629658445849397bda4e4f
> 
> removes MODALIAS from one of the events,

Which event?

If you enable CONFIG_USB_DEVICE_CLASS, does everything work the same
again?

> this breaks user space applications like openct - everything that
> depends on getting an event that has both the DEVICE= path to the usb
> device and any information on the interface, so it can check if the
> device is something it supports (in case of openct: smart card reader,
> i.e. bInterfaceClass 0b).

What specific udev rule are you matching against here that is now
broken?

> The text does not mention MODALIAS nor the reason for it's removal.

The reason is we don't need the usb_device class anymore, but we still
provide for the compatibility if you have an old distro with old udev
rules that is expecting it (only rule we ran into was the one for the
usbfs /dev nodes, but there might be more.)

confused,

greg k-h
