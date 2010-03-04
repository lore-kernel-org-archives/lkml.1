Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0CDX2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:28:21 -0500
Received: from mail-iw0-f175.google.com ([209.85.223.175]:35048 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab0CDX2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:28:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UrDImddjYYQ/V0FPhzuHKhiZ+D8iRzCIj9QjeWKcwVPVhrcdxQQ8afyOt7nMd7+2eq
         rgtO4TcOhRy+4S2+hHyS6/LuyjpNo+MM25M6gw8uDZXTrwXMyfENMEIDaWwAlguXJ05Y
         xLZQyEiYUmLlkygdxUbUKpLattFeXKdOGcEU8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041507070.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
	 <20100304192524.GA24253@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>
	 <20100304195302.GA24856@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
	 <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>
	 <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>
	 <21d7e9971003041503p726ecbebi4b0b97854c5824de@mail.gmail.com>
	 <alpine.LFD.2.00.1003041507070.3751@localhost.localdomain>
Date: Fri, 5 Mar 2010 09:28:18 +1000
Message-ID: <21d7e9971003041528h174cc65fibb7856a3b7bbd2ed@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Its nouveau project not X not DRM, stop generalising the situation.
>
> Is it really just nouveau? I've not looked, but I bet the intel driver and
> the radeon driver have _exactly_ the same "oh, I'm the wrong version, I
> will now kill myself" behavior.
>
> I certainly seem to remember some similar issues with the intel driver
> long long ago.
>
> What would happen if I changed DRIVER_PATCHLEVEL to 1 for the i915 driver?
> Would it try to handle it gracefully? Or are we in the same situation that
> the intel driver guys can never fix anything fundamental without doing a
> whole flag day?

Patchlevel never changed in intel, but if you changed the MINOR back to 1 then
shit would break, exactly like any userspace shared library.

It'll fall over in userspace, because userspace has minimum versioning
requirements
same as if you change all the udev interfaces back 6 years nothing
boots anymore,
or you remove the wireless interfaces or xattrs from ext3. I thin

The standard DRM versioning interface is

MAJOR - don't change this ever except for second coming. Radeon KMS
is the only driver to have bumped this interface version, and we still
support the 1.0.0
if you turn off modesetting. Mach64 bumped it once but we never
upstreamed either
version.

MINOR - optionally bump this when you add a new API, new feature, new chipset,
now we generally just add a new GETPARAM, which the userspace can check for and
do the correct thing.

PATCHLEVEL - ideally bump this for small non-user visible changes, in practice
nobody touches this ever. Nouveau have "abused" this to provide pre
1.0.0 version
number, when they release version 1.0.0 they are expected to follow standard drm
versioning rules.

Now just like in userspace, if you add features to the minor number,
userspace driver
will come to depend on these features being there. If you dropped the
intel minor
to 1.1 it would crap itself all over the place, same as if you
starting trying to ship glibc2.0
on a glibc2.1 distro. We have never worried about new userspaces
running on really
old kernels, because generally 3-4 years has been good enough for distros.

This is a nouveau problem not a drm problem.

Dave.
