Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbXF0RzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbXF0RzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbXF0RzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:55:07 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59368
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbXF0RzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:55:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH RFC #2] hwrng: Add type categories
Date: Wed, 27 Jun 2007 19:54:16 +0200
User-Agent: KMail/1.9.6
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706262021.51410.mb@bu3sch.de> <200706271505.33970.mb@bu3sch.de> <20070627170331.GB6508@khazad-dum.debian.net>
In-Reply-To: <20070627170331.GB6508@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271954.16963.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 19:03:31 Henrique de Moraes Holschuh wrote:
> On Wed, 27 Jun 2007, Michael Buesch wrote:
> > Well, we have that userspace ABI of one hwrng char device. I did not
> 
> Yeah.  Talk about shortsighted ABIs that deserve to die an horrible death.
> The same goes for the watchdog ABI.
> 
> > And changing it in a compatible way is probably difficult.
> 
> Well, sort of.  Some sort of compromise will have to be taken.
> 
> IMHO, anything worth bothering with in userspace will react well to a
> symlink in /dev/hw_random, which is userspace's problem to set.  Anyone else
> is expected to fix his /dev or whatever when they upgrade kernels, and we
> can always provide the old hw_random char device returning EFAULT or
> somesuch, so that it becomes very obvious that something is in need of
> attention (and it FAILS instead of just disappearing).
> 
> > And then we would _still_ export some kind of hint for rngd that
> > the CPU rng device should be preferred over the bcm43xx device.
> 
> Yes, export all the characterisitics of the RNG, and let userspace decide
> what to do.
> 
> > How would you implement that? (We're back to my TYPE_XXX definitions ;) )
> 
> I'd implement it as an IOCTL with gives back:
> 
> 1. Hardware device name
> 2. Hardware device revision
> 3. expected worst-case minimum entropy per bit of output
> 4. current config expected minimum entropy per bit of output
> 5. average bit rate (worst config)
> 6. average bit rate (current config)
> 
> There are probably others, but they don't come to mind at the moment.  We
> could add something for type of device (oscilators, radioactive decay,
> whatever), I suppose.
> 
> Use some magic value (0x00 ?) for unknown.  I won't bother with the scales,
> if someone is going to write this, we can decide that later.  Just remember
> that there are 10 Mbit/s RNGs out there, and 100 bit/s RNGs out there, and
> that entropy goes from 0/unknown to 1 and needs at least a precison of
> 10^-3.
> 
> You also need a way to lock the RNG configuration, and you need to detect if
> you ever read a byte from it that was produced by a different
> configuration, which probably means a few more IOCTLs.

Ok, all very good ideas. Patches are welcome ;)

> I don't much like sysfs over IOCTLs for this, as you will probably need to
> be able to set and get things in an atomic way.  A sysfs binary attribute
> would also work.  A sysfs one-value-per-attribute bunch of them is
> completely useless from a security point of view.

hm? Why?


-- 
Greetings Michael.
