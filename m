Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZJ1D2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZJ1D2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbZJ1D2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:28:07 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:40528 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZJ1D2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lMjqBjRJZFMgmL9Pymt3hDDhOqhq+dZK9SdSf4q4w3nUaKV+LfZ/z2w4eBE27MZwB2
         Vt40gF+lL1K0hOMyBmouyujbV3Rgl0KCJigxTX4VmvLgmHsMXaA4V6m+ViMQCqR8mY2h
         KVgohD36EJQVnz0uXeP+a72ogZNOCEObiA/+Y=
MIME-Version: 1.0
In-Reply-To: <20091028031904.GA7744@basil.fritz.box>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com>
	 <87hbtkjkki.fsf@basil.nowhere.org>
	 <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com>
	 <20091028031904.GA7744@basil.fritz.box>
Date: Wed, 28 Oct 2009 13:28:10 +1000
Message-ID: <21d7e9970910272028n6eaa21fap51f15511d51145a2@mail.gmail.com>
Subject: Re: is avoiding compat ioctls possible?
From: Dave Airlie <airlied@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       DRI Development Mailing List 
	<dri-devel@lists.sourceforge.net>,
       Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 1:19 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Oct 28, 2009 at 01:05:08PM +1000, Dave Airlie wrote:
>> We've designed that into a/c also, we pad all 64-bit values to 64-bit
>> alignment on all the
>> ioctls we've added to the drm in the past couple of years. Just because of
>> this particular insanity.
>
> That's actually not needed, just use compat_*64.
>>
>> Assume no mistakes are made, new ioctls designed from scratch
>
> That seems like a bad assumption. It sounds like you already
> made some.

You mean its impossible to design a 32/64-bit safe ioctl no matter what?
and we should live with having compat ioctls? This isn't something that was very
clearly stated or documented, the advice we had previously was that
compat ioctls
were only required for old ioctls or ioctls with design problems. compat_*64
didn't exist when this code we designed, and we worked around that, but it was
in no way mistaken, manually aligning 64-bit values is a perfectly
good solution,
not sure why you imply it isn't.

>
>> and reviewed to do 32/64-bit properly. The s390 was something I didn't
>> know about but KMS on s390 is probably never going to be something
>> that sees the light of day.
>
> Well in theory there might be more architectures in the future
> which rely on compat_ptr
>

Well this was what I was trying to gather, so maybe I just need to write
something up to state that compat_ioctl is always required for new ioctls
that pass pointers or 64-bit values hiding pointers, so more people
don't make this mistake going forward. I can say when we inquired about this
2 or so years ago when designing kms I didn't get this answer, which is a pity.

Dave.
