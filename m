Return-Path: <linux-kernel-owner+w=401wt.eu-S932550AbZJ1DTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbZJ1DTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932544AbZJ1DTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:19:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbZJ1DTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:19:00 -0400
Date: Wed, 28 Oct 2009 04:19:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       DRI Development Mailing List 
	<dri-devel@lists.sourceforge.net>,
       Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Subject: Re: is avoiding compat ioctls possible?
Message-ID: <20091028031904.GA7744@basil.fritz.box>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com> <87hbtkjkki.fsf@basil.nowhere.org> <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 01:05:08PM +1000, Dave Airlie wrote:
> We've designed that into a/c also, we pad all 64-bit values to 64-bit
> alignment on all the
> ioctls we've added to the drm in the past couple of years. Just because of
> this particular insanity.

That's actually not needed, just use compat_*64.
> 
> Assume no mistakes are made, new ioctls designed from scratch

That seems like a bad assumption. It sounds like you already
made some.

> and reviewed to do 32/64-bit properly. The s390 was something I didn't
> know about but KMS on s390 is probably never going to be something
> that sees the light of day.

Well in theory there might be more architectures in the future
which rely on compat_ptr

> 
> I'm just amazed that compat_ioctl should be required for all new code.
> 
> DrNick on irc suggested just doing:
> if (is_compat_task()) ptr &= 0x00000000FFFFFFFF;

Such hacks often have problems on BE.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
