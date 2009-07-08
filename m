Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbZGHXm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbZGHXm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 19:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZGHXmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 19:42:16 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:65135 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZGHXmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 19:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ePZZwpDescGsd1laa6FSgFTTdggGLIST/mC5ESdrhRPchoRbURzwlplOCQliV0ACe1
         AGLqgk7H5t28ib31SdUvqw9tgNTEHwkcnQt16SnPqQzvLNzQRwteWENBawN7cg95AgRS
         diiw6AOLxS+wtqF22RW08gLYmEwT45b4sYoD4=
MIME-Version: 1.0
In-Reply-To: <200907080700.33120.elendil@planet.nl>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	 <200907080232.04551.elendil@planet.nl>
	 <21d7e9970907071950n27979df6j44444edd8528a598@mail.gmail.com>
	 <200907080700.33120.elendil@planet.nl>
Date: Thu, 9 Jul 2009 09:42:14 +1000
Message-ID: <21d7e9970907081642l3ef6df5blde31df656cd74432@mail.gmail.com>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
From: Dave Airlie <airlied@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 3:00 PM, Frans Pop<elendil@planet.nl> wrote:
> On Wednesday 08 July 2009, Dave Airlie wrote:
>> On Wed, Jul 8, 2009 at 10:32 AM, Frans Pop<elendil@planet.nl> wrote:
>> > On Tuesday 07 July 2009, Rafael J. Wysocki wrote:
>> >> The following bug entry is on the current list of known regressions
>> >> from 2.6.30.  Please verify if it still should be listed and let me
>> >> know (either way).
>> >>
>> >> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13667
>> >> Subject       : drm: display arifacts when X.Org is stopped
>> >> Submitter     : Frans Pop <elendil@planet.nl>
>> >> Date          : 2009-06-27 18:52 (10 days old)
>> >> References    : http://lkml.org/lkml/2009/6/27/105
>> >
>> > Problem is still there with -rc2. Dave said he'd try to reproduce,
>> > but I've not heard back from him yet.
>>
>> Don't suppose you have a 32-bit install you could also test with?
>
> You're in luck...
> I also get artifacts, though less severe, with .31-rc2 on my Toshiba
> Satellite A40 (32-bit kernel) during logout from X.Org. The switch is
> clean with .30.
>
>> Hopefully I can reproduce it on my box locally, otherwise its really
>> messy dealing with 2 drivers smashing on the same hw.
>
> Not sure why you're saying that. I would think VESA fb + X.Org is quite
> common and also a very valid use case [1]. How else would you get the
> pretty kernel boot logo? ;-)
>
>> btw you get any wierd text mode issues without vesafb?
>
> If I boot .31-rc2 without vga=791 I don't get the artifacts. The artifacts
> also do not appear if I boot with 'nopat'. Checked on both systems.
>
> Note that I reported a similar issue once before, also reproducible on
> both systems. In that case it was a bug in PAT which was eventually fixed.
> See: http://bugzilla.kernel.org/show_bug.cgi?id=10843.
>
> Given that 'nopat' helps, you may want to check with Suresh on this one.
>

I've cc'ed Venki and Suresh, guys since I switched AGP to using the page
arrays instead and the new array setting functions, Frans has been seeing
vesafb corruption when using non-KMS intel driver after X has finished running.
nopat makes it go away.

> [1] I'd even go so far as to feel it should be a standard test case for
> video driver developers, given that this is the third time it's shown
> regressions :-) For the third case the bug was in the X.Org i830 driver:
> http://bugs.freedesktop.org/show_bug.cgi?id=14481.

It might surprise you to learn this, but vesafb has never been considered
supportable by the X.org community, and you'll notice not very many distros
ship with it enabled, it breaks suspend/resume on many machines for example.

As I said having two drivers thinking they own the GPU is a recipe for total
disaster and thats why we've designed the new KMS code so you can get
cool bootup logos and avoid the insanity dance.

However we shall endeavour to fix this issues as it may be systemic of something
else going wrong in the new PAT/AGP code.

Dave.
