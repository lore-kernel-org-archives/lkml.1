Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0CEUjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:39:07 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:55734 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0CEUjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:39:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TXk8zHOx1uLvZXm0f7XvDo7Q/NoHJnxWw6eCt/sQXtNuETPVDXKsVcS9VoTT4qfcrw
         p83UTtZw2Aa/rILJRI6k6Rx+eJos82It0mG62T6oMneuqr81/Gmy73d4MQA04hmCd7s6
         eHHMBVBMaiQiXhhI1loyj6Xo+/+XOnK2OJq1A=
MIME-Version: 1.0
In-Reply-To: <877hpq36sj.fsf@pollan.anholt.net>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	 <20100304185002.GA23532@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	 <20100304190450.GA23807@srcf.ucam.org> <4B900AB2.1020603@garzik.org>
	 <20100305122129.0c99adf3@lxorguk.ukuu.org.uk>
	 <877hpq36sj.fsf@pollan.anholt.net>
Date: Fri, 5 Mar 2010 21:39:01 +0100
Message-ID: <ff13bc9a1003051239w6816e789m70bea7e34820d858@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So overall, I'd say that we spent about a month of developer time
> at least between jbarnes, ickle, and myself, on extending the execbuf
> interface to add a flag saying "dear kernel, please don't do this bit of
> work on this buffer, because I don't need it and it makes things slow."

Perhaps then, we should break ABI compatibility _more_ often to speed
up development, but also have awesome mechanisms to make it painless
for the user.

Such as:
1. Automatic side by side userspace installation, as Linus proposed
2. Kernel "make install" refusing to proceed if it finds that
userspace is not updated, and giving instructions on how to update
userspace
3. Distributions packaging the new ABI X/Mesa drivers and libdrm even
for stable distributions
4. Kernel "make install" offering to automatically install said
distribution packages if it detects a supported distribution
5. Ability to drop new versions of drivers/gpu/drm in an older kernel
tree and have it compile (within reasonable limits)

In particular, for people with (slightly) old kernels, it should be
much easier to make updated DRM trees still work with older kernels,
than attempting to make updated userspace work with older kernel
modules.
This also actually gives them the benefits of the new code.

And for people with really old kernels, it's not different from any
other hardware device, which requires a kernel upgrade to have better
support.

Then, for instance, Linus would just have seen the following upon
running make install:
This kernel requires the Nouveau userspace version 0.0.16, which you
don't have installed.
Fedora 12 has been detected.
Invoke yum to install the <rpmnames> RPMs required for it? [y/n]
_or_
Ubuntu 9.10 has been detected
Invoke apt-get to install the <debnames> packages required for it? [y/n]

If the user says no, or the distribution is unknown, instructions on
how to download and compile the source would be presented.

Once you setup this system, you can freely break the ABI with no
significant user discomfort by just raising the version number.
This also potentially applies to stuff other than DRM (e.g. perf, kvm,
iptables, udev, filesystem-specific tools/APIs, various device
configuration systems, and so on).

The really stable APIs/ABIs should not be the (undocumented) kernel
ones, but Xlib and OpenGL, which actually have formal specifications.
Perhaps eventually Gallium could join them as a stable API closer to
the hardware, but that's a long way off.
