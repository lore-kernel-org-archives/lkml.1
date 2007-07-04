Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbXGDPmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbXGDPmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXGDPmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:42:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4775 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752934AbXGDPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:42:06 -0400
Date: Wed, 4 Jul 2007 11:42:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Paul Mackerras <paulus@samba.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, <rjw@sisk.pl>, <mjg59@srcf.ucam.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <E1I63Nv-0006Z9-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Miklos Szeredi wrote:

> And we won't know if drivers are OK until we remove the freezer,
> catch-22.
> 
> So I think we need to disable the freezer at least in -mm and/or
> optionally in -linus.
> 
> I applied Matthew's patch, and suspend did in fact stop working
> (thinkpad t60), but there was nothing catastrophic.  Here's the dmesg
> if somebody is interested:
> 
> Suspending console(s)
> usb_endpoint usbdev5.3_ep83: PM: suspend 0->2, parent 5-2:1.0 already 2
> usb_endpoint usbdev5.3_ep02: PM: suspend 0->2, parent 5-2:1.0 already 2
> usb_endpoint usbdev5.3_ep81: PM: suspend 0->2, parent 5-2:1.0 already 2
> hub 2-0:1.0: suspend error -16
> suspend_device(): usb_suspend+0x0/0x1c() returns -16
> Could not suspend device usb2: error -16
> usb_endpoint usbdev5.3_ep81: PM: resume from 0, parent 5-2:1.0 still 2
> usb_endpoint usbdev5.3_ep02: PM: resume from 0, parent 5-2:1.0 still 2
> usb_endpoint usbdev5.3_ep83: PM: resume from 0, parent 5-2:1.0 still 2
> Some devices failed to suspend

Remember what I wrote a few minutes ago about khubd and ksuspend_usbd
wanting to resume devices during a system suspend transition?  This is
exactly what happens when those threads aren't frozen.

Alan Stern

