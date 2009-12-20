Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZLTTu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZLTTu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZLTTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:50:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbZLTTuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:50:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sun, 20 Dec 2009 20:51:01 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912201434340.27137-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912201434340.27137-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912202051.01328.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Alan Stern wrote:
> On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:
> 
> > BTW, what's the right place to call device_enable_async_suspend() for USB
> > devices?
> 
> For USB devices, it's in drivers/usb/core/hub.c:usb_new_device() 
> anywhere before the call to usb_device_add().
> 
> For USB interfaces, it's in 
> drivers/usb/core/message.c:usb_set_configuration() before the call to 
> device_add().
> 
> For USB endpoints, it's in 
> drivers/usb/core/endpoint.c:usb_create_ep_devs() before the call to 
> device_register().

Thanks!

> However you won't need to do it for interfaces and endpoints if you 
> automatically treat as async any device without suspend/resume 
> callbacks.

I don't do that right now and I need these settings just for testing at the
moment.

Rafael
