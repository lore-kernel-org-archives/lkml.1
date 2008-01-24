Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYAXSXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYAXSXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 13:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYAXSXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 13:23:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35217 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYAXSXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:23:00 -0500
Date: Thu, 24 Jan 2008 10:03:13 -0800
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Wilco Beekhuizen <wilcobeekhuizen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Message-ID: <20080124180313.GA16006@kroah.com>
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <20080124013720.GA21978@kroah.com> <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com> <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com> <20080124164418.GA8226@kroah.com> <84144f020801240906l7e018a95wfd4ad7736851dd63@mail.gmail.com> <20080124172049.GA9665@kroah.com> <84144f020801240942y1c75c82geddc250b7e7814ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020801240942y1c75c82geddc250b7e7814ac@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 07:42:20PM +0200, Pekka Enberg wrote:
> Hi Greg,
> 
> On Jan 24, 2008 7:20 PM, Greg KH <greg@kroah.com> wrote:
> > > So it's not a simple code change at all.
> >
> > Just create a root directory for every device that is seen in the
> > probe() function.  That should be pretty simple to do.
> 
> Yeah, that would work but why do we want to mount all devices under
> the same mount point? If you move device discovery to ->probe() it's
> simple to have per-device mount points by overriding ->get_sb() to
> check for USB_DEVICE_MAJOR and look up the actual device, no?
> Otherwise you have to deal with device plug/unplug at filesystem
> level...

Yes, you could do that (per device mount), but it might be confusing for
users to have to control things that way.

And the unplug issue at a filesystem level should be pretty trivial to
handle, we do it all the time in /proc and /sys and other virtual
filesystems (usbfs) with no problems.

thanks,

greg k-h
