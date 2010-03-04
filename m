Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab0CDTZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:25:40 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:47245 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab0CDTZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:25:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WzV+uqFokI6FwcbCKIAXVEKEd7CBzLdZbOLckF264Ij7IH9XjQrgSU2bu7lZSj7NVH
         mPrc8jjYLLNQNa2+WFHRa9LjXX3h4Y271w644NsFbP2z/5l3G3/rvww0TIkjZUoL9PmM
         WZ16HRL5vsv2CdUOC2ILo6/xDXycTuBlmMZOE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <20100304103655.0b14343f@jbarnes-piketon>
	 <20100304103929.6eb81d45@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	 <20100304105624.70fe845e@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
Date: Fri, 5 Mar 2010 05:25:34 +1000
Message-ID: <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> If marking the driver as staging doesn't allow them to break ABI when
>> they need to, then it seems like they'll have no choice but to either
>> remove the driver from upstream and only submit it when the ABI is
>> stable, or fork the driver and submit a new one only when the ABI is
>> stable.  Neither seem particularly attractive.
>
> The thing is, they clearly didn't even _try_ to make anything compatible.
> See how all the ioctl numbers were moved around.
>
> And if you can't make if backwards compatible, at least you should make it
> forwards-compatible. Is it even that? I don't know. I'm kind of afraid it
> isn't. The new libdrm required for it certainly hasn't been pushed to
> Fedora-12. Will it ever be? And if it is, can you still run an old kernel
> on it?
>
> All of these are always possible to do. We've been _very_ good at doing
> them in general. I'm complaining, because let's face it, what else can I
> do?
>
> And btw, I'd complain about breaking backwards compatibility even if it
> wasn't just my own machine. I can pretty much guarantee that I'm not going
> to be the only one hitting this issue.
>
> So practically speaking: what _do_ you suggest we do about all the
> regressions this will cause?

At the moment in Fedora we deal with this for our users, we have dependencies
between userspace and kernel space and we upgrade the bits when they upgrade
the kernels, its a pain in the ass, but its what we accepted we needed
to do to get
nouveau in front of people. We are currently maintain 3 nouveau APIs
across F11, F12
and F13.

The main reason the API was gutted was because it supported lots of
things that weren't
supportable going forward. User modesetting support was completely
removed and this
meant lots of the API was pointless.

Now I can ask Ben if he'd like to try and supply a libdrm that could
in  theory deal
with both as a favour, but I'm not expecting the nouveau project guys
to care, we pretty
much got ourselves into this corner, and we'll pretty much have to get
ourselves out.

The other option I can ask him to look at is a CONFIG_NOUVEAU_015 interface
which justs ifdefs around this for now, and in another release or two
we rip all that out.

Of course I can't ask him either of these until normal people who live
in Australia wake
up in 2-3 hrs, as opposed to me who is sitting in the dark trying not
to wake the baby.

Dave.
