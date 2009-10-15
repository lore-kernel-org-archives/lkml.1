Return-Path: <linux-kernel-owner+w=401wt.eu-S935293AbZJOSpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935293AbZJOSpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935284AbZJOSpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:45:13 -0400
Received: from kroah.org ([198.145.64.141]:60254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935258AbZJOSpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:45:12 -0400
Date: Thu, 15 Oct 2009 11:21:36 -0700
From: Greg KH <greg@kroah.com>
To: Brian Rogers <brian@xyzw.org>
Cc: tim.gardner@canonical.com, stable <stable@kernel.org>,
       linux-bluetooth@vger.kernel.org, kernel-team@lists.ubuntu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Bluetooth input fixes for stable
Message-ID: <20091015182136.GA3921@kroah.com>
References: <4AD284F1.7050605@xyzw.org>
 <4AD3DCAF.7050908@canonical.com>
 <4AD4661A.8090905@xyzw.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD4661A.8090905@xyzw.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:35:54AM -0700, Brian Rogers wrote:
> Tim Gardner wrote:
> > Brian Rogers wrote:
> >   
> >> For Karmic's kernel, I recommend the following cherry-picks from upstream:
> >>
> >> 364f63519d94442ed373ac7da79033c8282df46a
> >> 9eba32b86d17ef87131fa0bce43c614904ab5781
> >> edad63886993d18ab800c49f6587a93432ef8b35
> >>
> >> They ensure Bluetooth input devices such as keyboards and mice are 
> >> removed completely and in proper order when they disconnect, so that HAL 
> >> sees the removal and relays the info to X. Without this, disconnected 
> >> Bluetooth devices are left in X, and duplicates appear on each 
> >> reconnection until the input device limit is hit. Then no newly 
> >> connected input devices will work.
> >>
> >> Brian
> >>     
> >
> > These look suitable for 2.6.31 stable. Have you sent them to
> > stable@kernel.org?
> >   
> 
> Actually, I hadn't sent these to stable yet, but that's a good idea. 
> CCing relevant parties.
> 
> It's not actually a regression (or at least not a recent one) since the 
> stale input device problem has existed as far back as I can remember, 
> but these commits do 'fix a real bug that bothers people', as the 
> guideline states, so I guess it's appropriate for stable.
> 
> Commit messages below:
> 
> commit 364f63519d94442ed373ac7da79033c8282df46a
> Author: Marcel Holtmann <marcel@holtmann.org>
> Date:   Sat Aug 22 14:15:53 2009 -0700
> 
>     Bluetooth: Disconnect HIDRAW devices on disconnect
> 
>     Currently the HID subsystem will create HIDRAW devices for the transport
>     driver, but it will not disconnect them. Until the HID subsytem gets
>     fixed, ensure that HIDRAW and HIDDEV devices are disconnected when the
>     Bluetooth HID device gets removed.
> 
>     Based on a patch from Brian Rogers <brian@xyzw.org>
> 
>     Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> 
> commit 9eba32b86d17ef87131fa0bce43c614904ab5781
> Author: Marcel Holtmann <marcel@holtmann.org>
> Date:   Sat Aug 22 14:19:26 2009 -0700
> 
>     Bluetooth: Add extra device reference counting for connections
> 
>     The device model itself has no real usable reference counting at the
>     moment and this causes problems if parents are deleted before their
>     children. The device model itself handles the memory details of this
>     correctly, but the uevent order is not consistent. This causes various
>     problems for systems like HAL or even X.
> 
>     So until device_put() does a proper cleanup, the device for Bluetooth
>     connection will be protected with an extra reference counting to ensure
>     the correct order of uevents when connections are terminated.
> 
>     This is not an automatic feature. Higher Bluetooth layers like HIDP or
>     BNEP should grab this new reference to ensure that their uevents are
>     send before the ones from the parent device.
> 
>     Based on a report by Brian Rogers <brian@xyzw.org>
> 
>     Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> 
> commit edad63886993d18ab800c49f6587a93432ef8b35
> Author: Marcel Holtmann <marcel@holtmann.org>
> Date:   Sat Aug 22 14:22:15 2009 -0700
> 
>     Bluetooth: Let HIDP grab the device reference for connections
> 
>     The core exports the hci_conn_hold_device() and hci_conn_put_device()
>     functions for device reference of connections. Use this to ensure that
>     the uevents from the parent are send after the child ones.
> 
>     Based on a report by Brian Rogers <brian@xyzw.org>
> 
>     Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

All queued up now.

thanks,

greg k-h
