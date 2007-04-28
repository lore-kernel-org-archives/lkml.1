Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbXD1A0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbXD1A0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757961AbXD1A0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:26:39 -0400
Received: from www.osadl.org ([213.239.205.134]:41690 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757958AbXD1A0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:26:37 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Date: Sat, 28 Apr 2007 02:28:46 +0200
User-Agent: KMail/1.9.5
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>
References: <20070427224957.GA17967@kroah.com> <20070427160425.710c0230.akpm@linux-foundation.org>
In-Reply-To: <20070427160425.710c0230.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280228.47500.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 April 2007 01:04 schrieb Andrew Morton:
> On Fri, 27 Apr 2007 15:49:57 -0700
>
> Greg KH <gregkh@suse.de> wrote:
> > Here are the updated UIO (Userspace I/O driver framework) patches for
> > 2.6.21.
>
> I'm a bit uncertain about the whole UIO idea, really.  I have this vague
> feeling that we'd prefer to encourage people to move device drivers into
> GPL'ed kernel rather than encouraging them to do closed-source userspace
> implementations which will probably end up being slower, less reliable and
> unavailable on various architectures, distros, etc.
>
> But I don't think I have the capacity to actually think about this further
> - just tossing it out there ;)

Thanks for tossing it out ;-) I understand your uncertainty and I share your
opinion about encouraging industry developers to GPL their drivers. It really
took me some time until I understood that sometimes there are _good_ reasons
for a closed driver. UIO is not intended for mass products like graphic cards.
We're talking about companies who developed special hardware for use in
special applications like machine control. They sometimes need to keep a 
part of their driver closed, at least for some time. Sometimes it's because
they want to protect themselves, sometimes because their customer demands it.
Usually, they know about the disadvantages you mentioned (if they're our
customers, be sure we tell them!).

Anyway, UIO is not just a system to allow closed drivers. There are enough
other reasons why these industry developers want userspace drivers. The most
important one is that they're usually no experienced kernel developers. They
can let somebody write the kernel part for them, and then write their driver
using the tools and libraries they know, with floating point and all that 
stuff. It's just convenient. If I had to write a driver for a fieldbus card
today, I'd use UIO. And I'd make it free software. UIO doesn't force anybody 
to close his drivers.

>
> > They have been revamped from the last time you have seen them, and they
> > include a real driver, the Hilscher CIF DeviceNet and Profibus card
> > controller, which is being used in production systems with this driver
> > framework right now.  The kernel driver they replaced was a total mess,
> > with over 60+ ioctls to try to control the different aspects of the
> > device.  See the last patch in this series for more details on this
> > driver.
> >
> > These patches include full documentation, are self-contained from the
> > rest of the kernel, and have been in the -mm tree for the past few
> > months with no complaints.
> >
> > Please pull from:
> > 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/uio-2.6.git/
> >
> > Patches will be sent as a follow-on to this message to lkml for people
> > to see.
> >
> >  drivers/uio/uio_cif.c                 |  156 ++++++++
>
> eh?  How come a particular device requires 156 lines of kernel code to
> support a userspace driver?  Doesn't that kind of defeat the point?

This is quite a large kernel module for an UIO device due to quite 
stupid hardware design. It needs two memory mappings, and the interrupt
handler is not the simplest thing possible. BTW, I don't think that
156 lines is so much. It allows to handle quite a complex PCI card. And
it's so simple that it can be even explained to industry programmers
who are no kernel gurus.

Thanks,
Hans

