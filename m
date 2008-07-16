Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYGPEnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYGPEnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYGPEnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:43:24 -0400
Received: from 1wt.eu ([62.212.114.60]:1557 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYGPEnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:43:23 -0400
Date: Wed, 16 Jul 2008 06:42:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, david@lang.hm,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Message-ID: <20080716044228.GN1369@1wt.eu>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org> <200807160222.40705.elendil@planet.nl> <alpine.LFD.1.10.0807151726520.2867@woody.linux-foundation.org> <487D441B.5010908@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D441B.5010908@garzik.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 08:43:07PM -0400, Jeff Garzik wrote:
> Linus Torvalds wrote:
> >
> >On Wed, 16 Jul 2008, Frans Pop wrote:
> >>Where did you get this strange notion that mkinitrd is the _only_ (your 
> >>emphasis) thing people use?
> >
> >Heh. Maybe from the fact that I don't personally use modules or initrd at 
> >all, and have no interest in doing so ;)
> >
> >Ok, so people use other things. Grr. I guess we can't just require updated 
> >tools, because we don't know what the tools are.
> 
> Yes, that's part of the problem :/
> 
> Everybody seems to love rolling their own stuff in this area, partly 
> necessitated I suppose by the wide variety of ways to boot on various 
> platforms.

Exactly. To give you an idea, I have a lot of servers running on a
"firmware" which consists in two parts :
  - a bzImage containing an initramfs with modules and a few scripts
  - an initrd which is in fact the rootfs

When the kernel boots, it mounts the initrd, does a pivot_root and mounts
its modules into /boot/$(uname -r). All my kernels run modules from /boot
and not from /lib/modules, because it makes them more convenient to add
and remove. So /lib/modules is just a symlink to /boot.

The above process is very convenient, as it is compatible with a lot of
boot methods : hard disk, CDROM, USB stick, PXE, etc...

And moreover, I can have multiple kernels with only one rootfs (SMP, etc).
Introducing firmware there would mean a major thinking and rework of the
build (and possibly boot) process. The least invasive would probably be
to stuff them next to the modules in $(uname -r)/firmware, but even then,
it will take a lot of time to switch to a new system.

And judging from what I see around, I'm far from being the only one not
using mkinitrd.

Willy

