Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbYIKUUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbYIKUUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYIKUUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:20:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:39056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYIKUUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:20:38 -0400
Date: Thu, 11 Sep 2008 13:15:41 -0700
From: Greg KH <greg@kroah.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, dwmw2@infradead.org, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-ID: <20080911201541.GA18518@kroah.com>
References: <48C68507.6000609@suse.com> <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <m27i9i9az9.fsf@vador.mandriva.com> <20080911134042.GB3293@kroah.com> <1221151165.6309.55.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221151165.6309.55.camel@californication>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 06:39:25PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> > > > > This isn't compatible with the version of udev that people actually have
> > > > > installed, today. And it's also the _wrong_ thing to do.
> > > > > 
> > > > > Firmware really _isn't_ version-specific.
> > > > 
> > > > Tell that to every Debian and Debian derived system on the planet.
> > > > 
> > > > To my knowledge, it is only fedora and possibly one or two other dists
> > > > that put the firmware files in a unary /lib/firmware location, rather
> > > > than a versioned /lib/firmware/$KERNELRELASE one.
> > > 
> > > We (Mandriva Linux) do too.
> > > Why other distro cannot package firmware separatly for all their kernel
> > > flavors?
> > > 
> > > Firmware are not version-specific.
> > 
> > Yes it is, when it is bundled with the kernel source tree itself.
> > 
> > Why do people not realize this?
> > 
> > This is a real problem for distros, and for anyone who wants to have
> > multiple kernel versions on a single machine.  Jeff's patch fixes this.
> 
> once you move the firmware into its own package built from a separate
> source tree (and not the kernel) this is no longer a problem.

Agreed, but that's not what is going on here at all.

This is the firmware that is in the kernel source tree, that has been
moved to use request_firmware, and was originally tied tightly to the
kernel drivers themselves.

Now I can't install multiple kernel versions of a rpm package on my
machine at once.  Or even a single rpm package and then my own build,
without stomping on files owned by a different package.

That's unacceptable and can not work and is why Jeff made this patch.

thanks,

greg k-h
