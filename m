Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0BFI72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 03:59:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab0BFI70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 03:59:26 -0500
Date: Sat, 6 Feb 2010 00:55:18 -0800
From: Greg KH <gregkh@suse.de>
To: Chris Verges <chrisv@cyberswitching.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rob Owings <rowings@thermistor.com>
Subject: Re: [PATCH] linux-2.6.32-directemp
Message-ID: <20100206085518.GA4680@suse.de>
References: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local> <20100205124038.4f1e83ac.akpm@linux-foundation.org> <68FBE0F3CE97264395875AC1C468F22C24A608@mail03.cyberswitching.local> <20100205134600.59eb8fae.akpm@linux-foundation.org> <20100205235833.GA16411@suse.de> <68FBE0F3CE97264395875AC1C468F22C24A633@mail03.cyberswitching.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C24A633@mail03.cyberswitching.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 04:26:42PM -0800, Chris Verges wrote:
> > Sorry, but no, this driver will not be accepted, as it can be done
> just
> > fine from userspace instead of a kernel driver, as discussed before.
> 
> Hi Greg,
> 
> Sounds good.  I'll still be sending out an updated patch for anyone who
> is interested in a kernel driver.  They're welcome to patch in the
> driver themselves.

That's great.

> I may be missing some key piece of information about libusb and usbfs,
> but it seems like it pushes a lot of the protocol communication off to
> the user app.  So if there are several user apps that want to use the
> same USB device, they either need a userland library or to re-implement
> functionality; is that correct?

Yes, that is true.

> What I may be missing is the rationale behind pushing these drivers into
> userland libraries and having yet another entity in the FOSS world that
> is responsible for managing them.  The kernel seems like an obvious
> clearinghouse for software/hardware interactions.  Yes, there may be
> lots of drivers, but at least everyone knows where to go for them.  But
> like I said before, I may be missing something.

No, you are correct.  We want a driver in the kernel when it provides a
common interface to a class of devices (network, tty, video, etc.)  For
devices like yours, there is no specific class in the kernel (well,
there is for hardware monitoring devices, but not for generic
thermometers.)  So for that, you are going to write a custom userspace
program anyway to be reading the temp value from sysfs, so you might as
well just either use a library to talk to your device, or put it within
the application itself.

Hope this helps explain things,

greg k-h
