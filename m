Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0CETqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:46:55 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43225 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab0CETqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:46:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=qr6SJWofHQr0N3TEiVgIZt0AmVsk4F8A+bgeY9+dM5Ov7FHzE1rwgwSDPZ6vYeBCxj
         bXLA+Nbrsplv3rrO7kPeS+YJWilQYm7br2ioUJizT99+oPQbj5TZQqUnj/S4xlt2+N5E
         Vsy+7zn0AvPDh2qyHfIWaL5j5X0KbpXIKzATA=
MIME-Version: 1.0
In-Reply-To: <20100305164615.GC6000@thunk.org>
References: <20100305151754.GB2505@tempa>
	 <20100305.072612.186421758.davem@davemloft.net>
	 <20100305154009.GC2505@tempa>
	 <20100305.074835.159078083.davem@davemloft.net>
	 <20100305160434.GE2505@tempa> <20100305164615.GC6000@thunk.org>
Date: Fri, 5 Mar 2010 11:38:46 -0800
Message-ID: <e7bd23c31003051138k14436b42t5bf544c375413c6c@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Corbin Simpson <mostawesomedude@gmail.com>
To: tytso@mit.edu, Daniel Stone <daniel@fooishbar.org>,
       David Miller <davem@davemloft.net>, skeggsb@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, mingo@elte.hu, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 8:46 AM,  <tytso@mit.edu> wrote:
> On Fri, Mar 05, 2010 at 06:04:34PM +0200, Daniel Stone wrote:
>>
>> So you're saying that there's no way to develop any reasonable body of
>> code for the Linux kernel without committing to keeping your ABI
>> absolutely rock-solid stable for eternity, no exceptions, ever? Cool,
>> that worked really well for Xlib.
>
> No, that's not what people are saying.  What people are saying is,
> "avoid flag days".  Deprecate things over a 6-12 month time period.
> We have lots of really good interfaces for doing that.
>
> You say you don't want to do that?  Then keep it to your self and
> don't get it dropped into popular distributions like Fedora or Ubuntu.
> You want a larger pool of testers?  Great!  The price you need to pay
> for that is to be able to do some kind of of ABI versioning so that
> you don't have "drop dead flag days".
>
> If you don't want to be a good citizen, then prepared to have people
> call you out for, well, not being a good OSS citizen.

I was trying my hardest to not say anything, but...

Nouveau isn't an official Xorg project. It hasn't been added to the
jhbuild list for auto-checkout, it doesn't get tinderbox time
(admittedly a function of being part of the jhbuild) and I don't think
it's on the katamari list, so it's never been shipped as part of an
Xorg release. It is only in mainline under the staging rules; drivers
come and go from staging under fairly lax rules.

Fedora ships this stuff because they're actively developing it and
enjoy deploying half-broken things to users in the vain hope that it
magically won't break. I can't count the number of kittens eaten by
Fedora systems I've used. (It is kind of sad that Fedora's still the
best distro about not deploying broken stuff but still remaining
up-to-date.) Tellingly, it doesn't look like this interface change has
been deployed to stable Fedora, just Rawhide.

The Ubuntu people don't talk to us as much as they should. Seeing how
badly they biffed Radeon and Intel KMS deployment, it's hard for me to
believe that deploying Nouveau went smoothly. I don't have much more
personal experience; my work computer has an HD 3450 in it now instead
of the old GeForce, and that's my only Ubuntu box.

If distros want to run weird experiments on their users, let them!
Sure, sometimes bad things happen, but sometimes good things happen
too. ConsoleKit, DeviceKit, HAL, NetworkManager, KMS, yaird, dracut,
Plymouth, the list goes on and on.

If the problem here is actually that a distro is deploying a staging
driver and picking up the pieces themselves, then just say it. This
whole thing with flag days, deprecation, interface changes, etc.
hinges on the idea that the code being deprecated was stable, usable,
and widely deployed, but it wasn't and isn't.

That said... Code probably is moving too fast inside nouveau. There is
a bit of a wall to go through to get new patches upstream, which one
would hope would inspire some developer restraint. intel and radeon
both still have most (if not all) of the legacy code needed by ancient
userspaces, and both DDX drivers are doing multiple-branch releases to
keep old userspace interfaces alive for people unable to update their
kernels. It might be useful for the nouveau guys to really seriously
consider code before it leaves their trees and enters mainline;
writing code that you won't commit to is quite lame for the obvious
reasons, but also for some unobvious reasons, e.g. it makes you look
like you don't actually know what you're doing and would rather just
keep reinventing wheels without justifying and testing your design
choices. (This is also why I was not exactly pleased with the
suggestion of retooling all of the r600 userspace over a change to the
CS system; we just spent the better part of a year moving everything
over to CS!)

~ C.

-- 
Only fools are easily impressed by what is only
barely beyond their reach. ~ Unknown

Corbin Simpson
<MostAwesomeDude@gmail.com>
