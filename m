Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbZHZGfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbZHZGfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbZHZGfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:35:07 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:42206 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZHZGfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kBwKBeL2HUNAG1oNcpd0MRogEwrwCp1c2ZkkvAQlU4x7kBcT5MePkK57tdj02NUG5t
         Ru8hWtJNc8wZbc9dYUpPK9oI00FkwrZ+b9MY+HGsoAnrl8GYwq+nHSk/zYEJU98St48k
         RgDnTcuypjBTHQrLVnF1+4vLHzr03ED95VZL4=
MIME-Version: 1.0
In-Reply-To: <1251268018.18434.16.camel@gaiman.anholt.net>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
	 <4A941E8B.8080902@plzk.org>
	 <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
	 <4A94599F.9020508@plzk.org>
	 <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
	 <1251239637.26348.20.camel@gaiman.anholt.net>
	 <20090826015127.GA1402@zhen-devel.sh.intel.com>
	 <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>
	 <21d7e9970908252047g6db2fb2aj69280efa5eebe681@mail.gmail.com>
	 <1251268018.18434.16.camel@gaiman.anholt.net>
Date: Wed, 26 Aug 2009 16:35:05 +1000
Message-ID: <21d7e9970908252335o4d355776t692e72ee4a16b29@mail.gmail.com>
Subject: Re: Linux 2.6.31-rc7
From: Dave Airlie <airlied@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 4:26 PM, Eric Anholt<eric@anholt.net> wrote:
> On Wed, 2009-08-26 at 13:47 +1000, Dave Airlie wrote:
>> On Wed, Aug 26, 2009 at 1:33 PM, Linus
>> Torvalds<torvalds@linux-foundation.org> wrote:
>> >
>> >
>> > On Wed, 26 Aug 2009, Zhenyu Wang wrote:
>> >>
>> >> > In my experience, the BIOS setup doesn't reflect what outputs should be
>> >> > used at runtime, and certainly not the correct configuration of the
>> >> > enabled outputs.  For example, if we went to this, the giant monitor
>> >> > attached to my laptop that I actually look at would go unused.
>> >>
>> >> yeah, normally VBIOS startup just needs or only can driver one pipe, so
>> >> we don't have any pre knowledge except detect everything.
>> >
>> > Umm. What's your guys point, exactly?
>> >
>> > The fact is, as-is, YOU DETECT THE WRONG OUTPUTS!
>> >
>> > If you actually detected things _right_, none of this would be an issue.
>> > But you don't. And you seem to have a really hard time even admitting
>> > that. You try to re-detect things, and you SCREW UP.
>>
>> This isn't anything to do with redetection, and in the Mac case there isn't
>> even a BIOS table that you can really rely on since Apple hard coded all
>> this stuff into their EFI and Mac OSX drivers.
>>
>> Now you probably get a video bios using Apples bios layer, but it also
>> is most likely not telling anything close to the truth about the hw layout.
>>
>> Just because the BIOS manages to light up an output in now way effects
>> whether the driver can do the same.
>>
>> >
>> >> we already have some mac relate bugs open, but please report on it so we
>> >> do have people with hardware to try and response. We have recently got a
>> >> MacBook, yakui is looking after the modesetting issue on it.
>> >
>> > Quite frankly, I've reported these things several times. I've been open to
>> > try patches. Nothing has ever come out of it.
>> >
>> > I have a Mac Mini that I reported as broken over a month ago. I have a
>> > Westemere I've reported as not doing any DDC probing - and that I have to
>> > disable the LVDS probing on entirely in order to not make KMS set up the
>> > display to go to a non-existent LVDS port.
>> >
>> > You claim that you "detect everything", but quite frankly, you don't. The
>> > KMS code seems to assume that if it's a mobile chipset, it should have an
>> > LVDS output - and whether anything is connected to that or not is totally
>> > immaterial. There's clearly _zero_ "detection" going on.
>> >
>> > And the thing is, X seems to get it right, at least more often than KMS
>> > does.
>> >
>>
>> I'm not sure why the mac-mini hack hasn't been merged I asked for it a
>> few times,
>> I'd rather the proper solution was merged but that seems to not have
>> happened either.
>
> Your complaint about needing to do the proper solution was why I never
> merged it.  It looked like a NAK to me.

I later told Keith to go ahead and send it onwards with the proviso someone
would look at doing it properly.

Granted with Linus suggestions maybe someone needs to look at it sooner.

Dave.
