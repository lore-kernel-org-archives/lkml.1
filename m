Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYATW7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYATW7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 17:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYATW7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 17:59:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55107 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755827AbYATW73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 17:59:29 -0500
Date: Sun, 20 Jan 2008 23:59:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <ak@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 regression: reference count leak in PPPoE
Message-ID: <20080120225942.GA31612@elf.ucw.cz>
References: <200801202053.30386.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801202053.30386.ak@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> My workstation running 2.6.24-rc8 just hung during shutdown with an endless 
> (or rather I didn't wait more than a few minutes) loop of 
> 
> unregister_netdev: waiting for ppp-device to become free. Usage count = 1
> 
> ppp-device was an active PPPoE device.
> 
> No more information currently.

Actually, I'm getting something similar:

usb 2-2: USB disconnect, address 23
PM: Removing info for No Bus:usbdev2.23_ep83
usb0: unregister 'cdc_ether' usb-0000:00:1d.0-2, CDC Ethernet Device
PM: Removing info for No Bus:usb0
unregister_netdevice: waiting for usb0 to become free. Usage count = 1
unregister_netdevice: waiting for usb0 to become free. Usage count = 1
unregister_netdevice: waiting for usb0 to become free. Usage count = 1
unregister_netdevice: waiting for usb0 to become free. Usage count = 1
unregister_netdevice: waiting for usb0 to become free. Usage count = 1
unregister_netdevice: waiting for usb0 to become free. Usage count = 1
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.23_ep81
PM: Removing info for No Bus:usbdev2.23_ep02

The unregister_netdevice made it onto console, that means pretty
severe log level. Happened while playing with openmoko connected with
USB cable.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
