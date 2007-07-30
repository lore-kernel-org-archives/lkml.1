Return-Path: <linux-kernel-owner+w=401wt.eu-S936120AbXG3NVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936120AbXG3NVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbXG3NVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:21:45 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39496 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757939AbXG3NVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:21:44 -0400
Date: Mon, 30 Jul 2007 15:19:46 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Haboustak <mike-@cinci.rr.com>, Andreas Gal <gal@uci.edu>,
       Vojtech Pavlik <vojtech@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH][hid] Fix a NULL pointer dereference when we fail to
 allocate memory
In-Reply-To: <200707220006.20359.jesper.juhl@gmail.com>
Message-ID: <Pine.LNX.4.64.0707301518530.5747@twin.jikos.cz>
References: <200707220006.20359.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007, Jesper Juhl wrote:

> If, in usb_hid_configure(), we fail to allocate storage for 'usbhid', 
>  "if (!(usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL)))", 
> then we'll jump to the 'fail:' label where we have this code:
>         usb_free_urb(usbhid->urbin);
>         usb_free_urb(usbhid->urbout);
>         usb_free_urb(usbhid->urbctrl);
> Since we got here because we couldn't allocate storage for 'usbhid', 
> what we have here is a NULL pointer dereference - ouch...

Hi Jesper,

thanks a lot for noticing this, I have queued your patch in HID tree.

(and sorry for late reply, I was offline on vacation for some time).

-- 
Jiri Kosina
