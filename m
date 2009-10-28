Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZJ1Dla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZJ1Dla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZJ1Dl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:41:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47776
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426AbZJ1Dl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:41:29 -0400
Date: Tue, 27 Oct 2009 20:41:52 -0700 (PDT)
Message-Id: <20091027.204152.220815765.davem@davemloft.net>
To: airlied@gmail.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970910272028n6eaa21fap51f15511d51145a2@mail.gmail.com>
References: <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com>
	<20091028031904.GA7744@basil.fritz.box>
	<21d7e9970910272028n6eaa21fap51f15511d51145a2@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@gmail.com>
Date: Wed, 28 Oct 2009 13:28:10 +1000

> On Wed, Oct 28, 2009 at 1:19 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> On Wed, Oct 28, 2009 at 01:05:08PM +1000, Dave Airlie wrote:
>>> We've designed that into a/c also, we pad all 64-bit values to 64-bit
>>> alignment on all the
>>> ioctls we've added to the drm in the past couple of years. Just because of
>>> this particular insanity.
>>
>> That's actually not needed, just use compat_*64.
>>>
>>> Assume no mistakes are made, new ioctls designed from scratch
>>
>> That seems like a bad assumption. It sounds like you already
>> made some.
> 
> You mean its impossible to design a 32/64-bit safe ioctl no matter what?

If you use pointers at all, yes.  We've said this several times.

> and we should live with having compat ioctls? This isn't something that was very
> clearly stated or documented, the advice we had previously was that
> compat ioctls
> were only required for old ioctls or ioctls with design problems. compat_*64
> didn't exist when this code we designed, and we worked around that, but it was
> in no way mistaken, manually aligning 64-bit values is a perfectly
> good solution,
> not sure why you imply it isn't.

Manually "aligning" the way you have solves only one side of the
compat problem on x86 with 64-bit types.  It may handle the layout
properly bit it doesn't change the alignment requirements of the
containing structure and that's a similarly important the issue.

If you want to solve both aspects, use the "aligned_u64" type.

But once you introduce pointers, you must have compat layer code,
and this is a hard requirement.  And there is nothing baroque or
wrong about it.
