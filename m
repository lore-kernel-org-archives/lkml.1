Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbYH2VW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbYH2VW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbYH2VWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:22:06 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2551 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758593AbYH2VWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:22:05 -0400
Date: Fri, 29 Aug 2008 17:22:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frans Pop <elendil@planet.nl>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [regression] usb: sometimes dead keyboard after boot (was: new
 errors during device detection)
In-Reply-To: <200808291933.43331.elendil@planet.nl>
Message-ID: <Pine.LNX.4.44L0.0808291709400.13185-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Frans Pop wrote:

> Here's a snippet of what I got when I enabled USB debug recently:
> [...]
> Aug  6 22:06:23 faramir kernel: hub 2-0:1.0: hub_resume
> Aug  6 22:06:23 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
> Aug  6 22:06:23 faramir kernel: usb usb1: usb auto-resume
> Aug  6 22:06:23 faramir kernel: usb usb1: wakeup_rh
> Aug  6 22:06:23 faramir kernel: hub 1-0:1.0: hub_resume
> Aug  6 22:06:23 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
> Aug  6 22:06:24 faramir kernel: usb usb2: suspend_rh (auto-stop)
> Aug  6 22:06:24 faramir kernel: usb usb1: suspend_rh (auto-stop)
> Aug  6 22:06:25 faramir kernel: hub 5-0:1.0: hub_suspend
> Aug  6 22:06:25 faramir kernel: usb usb5: bus auto-suspend
> Aug  6 22:06:25 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
> Aug  6 22:06:25 faramir kernel: hub 2-0:1.0: hub_suspend
> Aug  6 22:06:25 faramir kernel: usb usb2: bus auto-suspend
> Aug  6 22:06:25 faramir kernel: usb usb2: suspend_rh
> Aug  6 22:06:25 faramir kernel: hub 1-0:1.0: hub_suspend
> Aug  6 22:06:25 faramir kernel: usb usb1: bus auto-suspend
> Aug  6 22:06:25 faramir kernel: usb usb1: suspend_rh
> Aug  6 22:06:28 faramir kernel: usb usb5: usb auto-resume
> Aug  6 22:06:28 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
> Aug  6 22:06:28 faramir kernel: hub 5-0:1.0: hub_resume
> Aug  6 22:06:28 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
> Aug  6 22:06:28 faramir kernel: usb usb2: usb auto-resume
> Aug  6 22:06:28 faramir kernel: usb usb2: wakeup_rh
> Aug  6 22:06:28 faramir kernel: hub 2-0:1.0: hub_resume
> Aug  6 22:06:28 faramir kernel: usb usb1: usb auto-resume
> Aug  6 22:06:28 faramir kernel: usb usb1: wakeup_rh
> Aug  6 22:06:28 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
> Aug  6 22:06:28 faramir kernel: hub 1-0:1.0: hub_resume
> Aug  6 22:06:28 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
> Aug  6 22:06:29 faramir kernel: usb usb2: suspend_rh (auto-stop)
> Aug  6 22:06:29 faramir kernel: usb usb1: suspend_rh (auto-stop)
> [...]
> 
> AFAIK I have not enabled anything special in userland when it comes to
> USB suspension; this is just a standard boot.

Maybe you haven't enabled anything special, but something sure is 
running.  It appears to be probing your USB devices every 5 seconds.  
You might be able to find out what it is by adding

	printk(KERN_INFO "usbdev open by %s\n", current->comm);

to usbdev_open() in drivers/usb/core/devio.c.

> I do have CONFIG_USB_SUSPEND enabled though, so maybe one should not do that
> when using USB_DEBUG?

Turning off CONFIG_USB_SUSPEND would get rid of most but not all of
those messages above.

Alan Stern

