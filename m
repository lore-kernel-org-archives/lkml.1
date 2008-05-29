Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYE2XEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYE2XEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYE2XEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:04:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58679 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYE2XEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:04:23 -0400
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <483F1C17.8040207@linux.intel.com>
References: <1212077700.26088.83.camel@shinybook.infradead.org>
	 <20080529164745.GA21763@kroah.com>	<483F1232.4010003@linux.intel.com>
	 <20080529.140919.160813310.davem@davemloft.net>
	 <483F1C17.8040207@linux.intel.com>
Content-Type: text/plain
Date: Fri, 30 May 2008 02:04:18 +0300
Message-Id: <1212102258.20303.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 14:11 -0700, Arjan van de Ven wrote: 
> David Miller wrote:
> > Arjan, by definition the firmware has to be tied to the kernel somehow.
> > THe datastructure and other aspects are often tied directly to
> > the firmware version loaded.
> 
> agreed that there are cases like this, and I have no personal objection to having
> those in the kernel.
> 
> > If debian or whoever else have these concernes and want to rip the
> > firmware out, it is one hundred percent their problem to patch things
> > out of the kernel tree they use.
> 
> I don't care at all about the argument from that camp.

I do -- partly because it's not just from the fundamentalist camp,
partly because (after the work I've been doing) it doesn't actually
_hurt_ us to assume that they're right, but mostly because I have a
horrible suspicion that they _are_ right.

Expanding on those three points not in that order...:

The firmware is an independent and separate work in itself. Section 2 of
the GPL talks about such sections of the work, explicitly. The only way
to excuse what we're doing at the moment is to call it 'mere
aggregation' -- an exception which was intended to handle stuff like the
'freeware' CDs on the covers of magazines, distributing a bunch of
unrelated software. Not a coherent work combining software from
different sources into a single entity which works closely together as
one, and where one part is useless without the other.

The more that people claim it would be such a burden to split the
firmware from their driver because they're so closely interrelated, the
more they are arguing against the 'mere aggregation' defence, which was
tenuous enough in the first place.

And it isn't just the nutters. Fedora also wants to ship the firmware in
a separate package from the kernel -- since the alleged GPL violation is
such a _gratuitous_ risk given that we always use an initrd anyway, and
because people want to be able to do 'Free' spins which don't feature
the firmware at all, even in the source packages.

I strongly suspect we'd end up building the Fedora kernel from a special
'linux-2.6.2x-nofirmware.tar.bz2' tarball, rather than using the stock
tarballs if they continue to include the firmware. We do similar things
with 'openssh-5.0p1-noacss.tar.bz2' already, for example.

> My aim was more the opposite: be able to get MORE firmware easily used/loaded,
> not less. Right now it's a royal pain for users to get all the right pieces of
> firmware.... having ONE place to put all that would go a long way of making that
> side of things easier.

There are people who own copyright on firmware who refuse to put it into
the Linux source tree, because their lawyers don't believe the 'mere
aggregation' line, and believe that including it in the kernel source in
any form would require them to license it under the GPL.

But those same companies _would_ consider putting their firmware into a
non-GPL'd 'linux-firmware' repository instead. So by moving our firmware
out into a separate tree, we should actually make it _easier_ for people
to find all the necessary firmware in one place.

It's not as if it's hard to set CONFIG_BUILTIN_FIRMWARE_DIR to point to
your checkout of the linux-firmware repository, and build your kernel
with _whatever_ firmware you choose. You end up with _more_ choice, not
less.

And on the rare occasion that we really do have an incompatible change
of firmware/kernel interaction from one kernel to the next, it really
isn't difficult to add a version number to the name of the firmware
file, and ship both old and new firmwares in the firmware tree for a
while. That's a bogus argument, even if people _do_ manage to come up
with a better example for it, where their firmware has actually changed
in the last couple of years.

> If you want to argue that that should be in the kernel tarbal itself, you won't
> hear me complain. But others will... and for that a 2nd tarbal might well be the answer.

As soon as we have firmware converted to ihex files in the kernel source
tree, I'll set up a 'shadow' git tree like my kernel-headers tree, which
automatically follows the linux-2.6.git tree commit by commit, and
contains just the results you'd get from 'make firmware_install'.

At that point, when the distributions want to do it separately and
individuals who want to build firmware into their kernel really could
continue to do so _very_ easily, I just don't see any good reason why
we'd continue to keep them together.

-- 
dwmw2

