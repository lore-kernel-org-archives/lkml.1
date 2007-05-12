Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbXELT7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbXELT7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbXELT7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:59:21 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1715 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757698AbXELT7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:59:20 -0400
Date: Sat, 12 May 2007 15:59:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Soeren Sonnenburg <kernel@nn7.de>
cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] converting appletouch to usb autosuspend...
In-Reply-To: <1178995886.4168.10.camel@localhost>
Message-ID: <Pine.LNX.4.44L0.0705121552230.22494-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007, Soeren Sonnenburg wrote:

> Dear all,
> 
> I've realized using the great powertop ( http://www.linuxpowertop.org/ )
> that loading the appletouch driver (and touching it once) makes consumes
> about 0.3 W even when not touching the pad. As rmmod'ing appletouch
> fixes this I wonder why the driver does not do this alone. So my
> question is what does one have to do to convert a driver (such as
> appletouch) to make use of usb autosuspend except for
> 
>  .supports_autosuspend = 1

One has to add appropriate calls to usb_autopm_get_interface() and
usb_autopm_put_interface(), or equally well, to usb_autopm_enable() and
usb_autopm_disable().  One might also need to set
intf->needs_remote_wakeup to 1 in the probe routine.

> While we are at it usb related powerhogs on this macbook pro are
> uhci_hcd (usb keyboard) and usb_hcd_poll_rh_status (rh_timer_func)
> too...

They would use less power if the UHCI host controller were suspended.  
But obviously it cannot be suspended while devices attached to it (such as
the USB keyboard and the appletouch device) remain active.

Alan Stern

