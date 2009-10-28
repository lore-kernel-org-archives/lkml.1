Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZJ1Dew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZJ1Dew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZJ1Dew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:34:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55647 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbZJ1Dev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:34:51 -0400
Date: Wed, 28 Oct 2009 04:34:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       DRI Development Mailing List 
	<dri-devel@lists.sourceforge.net>,
       Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Subject: Re: is avoiding compat ioctls possible?
Message-ID: <20091028033455.GF7744@basil.fritz.box>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com> <87hbtkjkki.fsf@basil.nowhere.org> <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com> <20091028031904.GA7744@basil.fritz.box> <21d7e9970910272028n6eaa21fap51f15511d51145a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970910272028n6eaa21fap51f15511d51145a2@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 01:28:10PM +1000, Dave Airlie wrote:
> You mean its impossible to design a 32/64-bit safe ioctl no matter what?

Not impossible, but there's always a rate of mistakes.

> and we should live with having compat ioctls? This isn't something that was very
> clearly stated or documented, the advice we had previously was that
> compat ioctls
> were only required for old ioctls or ioctls with design problems. compat_*64
> didn't exist when this code we designed, and we worked around that, but it was
> in no way mistaken, manually aligning 64-bit values is a perfectly
> good solution,
> not sure why you imply it isn't.

It's true, just saying that even people who try to avoid creating
them often (but not always) need them anyways in the end.

> 
> >
> >> and reviewed to do 32/64-bit properly. The s390 was something I didn't
> >> know about but KMS on s390 is probably never going to be something
> >> that sees the light of day.
> >
> > Well in theory there might be more architectures in the future
> > which rely on compat_ptr
> >
> 
> Well this was what I was trying to gather, so maybe I just need to write
> something up to state that compat_ioctl is always required for new ioctls
> that pass pointers or 64-bit values hiding pointers, so more people
> don't make this mistake going forward. I can say when we inquired about this
> 2 or so years ago when designing kms I didn't get this answer, which is a pity.

Right now you could probably ignore it (if you document it), since
there are no non s390 architectures with this problem, just
prepare mentally that you might need to revisit this at some point.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
