Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZLTTi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZLTTi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZLTTiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:38:24 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41061 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754087AbZLTTiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:38:24 -0500
Date: Sun, 20 Dec 2009 14:38:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912201910.26895.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912201434340.27137-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:

> BTW, what's the right place to call device_enable_async_suspend() for USB
> devices?

For USB devices, it's in drivers/usb/core/hub.c:usb_new_device() 
anywhere before the call to usb_device_add().

For USB interfaces, it's in 
drivers/usb/core/message.c:usb_set_configuration() before the call to 
device_add().

For USB endpoints, it's in 
drivers/usb/core/endpoint.c:usb_create_ep_devs() before the call to 
device_register().

However you won't need to do it for interfaces and endpoints if you 
automatically treat as async any device without suspend/resume 
callbacks.

Alan Stern

