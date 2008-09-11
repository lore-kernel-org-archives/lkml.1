Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYIKW0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYIKW0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 18:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIKWZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 18:25:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYIKWZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 18:25:52 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080911220700.GD5823@kroah.com>
References: <48C68507.6000609@suse.com>
	 <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <m27i9i9az9.fsf@vador.mandriva.com> <20080911134042.GB3293@kroah.com>
	 <1221151165.6309.55.camel@californication>
	 <20080911201541.GA18518@kroah.com>
	 <1221165518.4077.17.camel@macbook.infradead.org>
	 <20080911205738.GB11708@kroah.com>
	 <1221167725.4077.34.camel@macbook.infradead.org>
	 <20080911220700.GD5823@kroah.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 15:25:43 -0700
Message-Id: <1221171943.4077.59.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 15:07 -0700, Greg KH wrote:
> > And it's a completely bogus example _anyway_, because you're not adding
> > this extra firmware to the kernel tree.
> 
> No, it shows that the firmware does change over time.

For _new_ drivers.

Current drivers.

The ones which would be using request_firmware() anyway.

What is true for those is irrelevant to the discussion at hand. The only
drivers with firmware in the firmware/ directory of the kernel source
tree are the _old_, _unloved_ drivers which don't get updated. If they
had active and competent maintainers, they'd have been switched to
request_firmware() long ago _anyway_.

DIFFERENT DRIVERS, Greg. With DIFFERENT CHARACTERISTICS.

> > All I've done _recently_ is a bit of a sweep on the stragglers. And
> > because of the amount of stupid whining, I made it possible to keep it
> > in the kernel tree rather than just evicting it, as we did in the past.
> 
> But it was that "sweep" that has caused problems by having the kernel
> put these files into the lib/firmware directory, without any version
> information unlike any other file that our kernel installs.
>
> That's the only point here.

Yes. Except that it's nonsense because it's not really a problem, unless
you _choose_ to be stupid in the way you package it.

> It seems that the point that it is a bad thing for multiple kernel
> packages to be installing into the same location, no matter if the file
> has the same content or not (date will change which will cause
> problems) isn't coming across here.  Why is that?

Of _course_ it's coming across. So DON'T DO THAT THEN!

Take a look at the Fedora packaging. See how it doesn't do that.

> Think of the very real example here:

 < snip contrived bogus example >

Yeah, that would be broken. Don't do it like that. Or if you _must_ do
it that stupid way, feel free to override INSTALL_FW_PATH. But don't
expect us to pat you on the back for it. It's the _wrong_ thing to do.

> > > > You can just ignore what the kernel ships with, and install the firmware
> > > > from the linux-firmware.git repository instead.
> > > 
> > > So you are now forcing distros to ship the linux-firmware.git repo
> > > instead?  That's not nice and is a totally new dependancy for them to
> > > handle.
> > 
> > Not at all; that's the ideal situation, but nobody's forced to do it
> > that way.
> 
> It's either use that package or add a patch that upstream seems to be
> objecting to.  That seems a bit "forced".
> 
> > > What about the very basic fact that kernel versions will stomp on files
> > > from other kernel versions if you install multiple kernels on the same
> > > machine?  That's just bad and ripe for problems in any package
> > > management system.
> > 
> > Only if you do stupid things in your packaging. So don't do that.
> 
> How do you expect anyone to package this up so that no conflicts occur?

Take a look at how Fedora does it. There is a 'kernel-firmware'
subpackage which is automatically generated with the kernel build, but
you don't have multiple such packages installed at the same time -- you
only have the _latest_ one.

This has a theoretical problem if drivers are removed from the tree, or
if firmware is removed from the tree (for example, because a newer
incompatible version supersedes it). That's fixed by packaging firmware
from the linux-firmware.git repository, in which the old firmware will
live on even after the current Linux kernel no longer has it. But since
it _is_ a purely theoretical problem, there's no particular rush for
that to happen. As I said, these ancient unloved drivers aren't getting
their firmware updated _anyway_.

Now, can we _please_ stop being bloody stupid? If there are _real_
problems, like the one I fixed with commit 1cede1af last week, then I'm
perfectly happy to deal with them. But stop making crap up.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

