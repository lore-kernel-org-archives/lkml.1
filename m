Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYAXQn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYAXQn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYAXQnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:43:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51683 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYAXQnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:43:19 -0500
Date: Thu, 24 Jan 2008 08:44:18 -0800
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Wilco Beekhuizen <wilcobeekhuizen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Message-ID: <20080124164418.GA8226@kroah.com>
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <20080124013720.GA21978@kroah.com> <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com> <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 01:19:25PM +0200, Pekka Enberg wrote:
> Hi Wilco,
> 
> On Jan 24, 2008 12:05 PM, Wilco Beekhuizen <wilcobeekhuizen@gmail.com> wrote:
> > Most code is pretty ancient, I just manage it so it compiles with
> > recent kernels. Is there somehting exported that is similar to
> > usb_find_device?
> 
> The problem is that iriverfs shouldn't be calling usb_find_device() at
> all. What happens when you plug in two players to the same computer?
> AFAICT the whole thing should be a proper USB driver in drivers/usb/
> and not a "filesystem" in fs/.

No, that's not the problem.  The code should just be using
usb_register_driver() and then doing what it needs to do in the probe()
callback, like any other USB driver.

By calling usb_find_device() it allows more than one driver to talk to
the device at the same time, setting it up for some very bad things to
possibly happen to the device.

So a simple code change should be all that is needed to properly fix
this.

If you want, I can make up a patch, just point me at the version you
wish me to modify.

thanks,

greg k-h
