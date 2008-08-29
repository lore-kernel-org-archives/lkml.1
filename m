Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYH2H1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYH2H1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYH2H10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:27:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:44726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbYH2H1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:27:25 -0400
Message-ID: <48B7A48B.8020405@kernel.org>
Date: Fri, 29 Aug 2008 09:26:03 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <48B751DA.5090906@kernel.org> <20080829065026.GC16462@cs181140183.pp.htv.fi>
In-Reply-To: <20080829065026.GC16462@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 07:27:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>> Yeah, I have to agree it's a bit too late but the exclusion between OSS
>> and more modern sound systems (be it ALSA or PA) still bugged me quite a
>> bit.  There always seems this one off app that wasn't quite there - be
>> it mpg123 for whatever reason I still enjoy to use from time to time,
> 
> mpg123 supports ALSA since 1998 (sic).

Heh.. I probably don't have the right plugin.  Oh... it has all the
plugins including pulse.  So, this one can be crossed off.

>> vmware which is a genuine pain in the ass to get working with LD_PRELOAD
>> tricks (hopefully 6.5 will finally use ALSA but wait we're all going PA
>> now...) or scorch-3D (and many other games) where aoss delivers horrible
>> sound after playing for a while.
> 
> Scorched3D gives me sound with native ALSA.
> 
> Is your libSDL not linked with libasound?

I'm not sure at all.  It was from openSUSE game repo back in 10.3
earlier this year and it only spoke OSS, but I bet if I try different
games in the current repo, I'll be able to find at least some which
still only work with OSS.

>> Anyways, the thing is that unlike what was originally expected, dropping
>> an major programming API doesn't really work too well even after six
>> years of trying.
> 
> Good ALSA emulation was a hot topic a few years ago when popular 
> software like Flash and Skype didn't support ALSA, but the use
> cases are becoming rare.
> 
> 2 out of your 3 examples above were software where native ALSA works,
> but your distributions seems to ship you a setup where you thought 
> OSS emulation was required.

Yeah, that's why I agree it's a bit too late but still better late than
never.  There are just some programs, be it commercial or ancient, which
don't work quite as well as it could.  Requiring update to ALSA took
painfully long years and we're still not in the clear yet.  Now should
we ask people to update to PA?

Then there's arch-um.  Yes, you can teach it to forward ALSA but then it
won't mux.  The only solution would be to link it against libalsa or
libpulse.

> Which distribution are you using whose makers seem to need
> a big cluebat?

openSUSE.  Not sure whether it deserves cluebat tho.

>> Maybe because OSS is still kicking on other unices.
> 
> Which Unix with a big userbase uses OSS as primary sound system?
> 
> OSS-only applications tend to be older Linux-only applications.
> 
> Cross-platform applications either ship half a dozen different sound 
> drivers (including ALSA), or more commonly use some library that offers
> one API no matter which sound system gets used.

Most major ones do, but there are programs and games which just haven't
fared off as well as more popular ones and thus just stopped being
updated and then there are commercial games which won't be updated in
any foreseeable future.  There are reasons why something as brand new as
pulse comes with something like padsp.

And it's not like CUSE adds whole lot to the kernel.  It mostly just
piggy backs on the existing FUSE.  Yeah, ioctl and poll are a bit
complex but with those and CUSE proper combined, it's way smaller than
the in-kernel ALSA OSS emulation which is somewhat painful to use these
days.

ossp is simply a better way to support /dev/dsp on modern systems and
bulk of it lives in userland (and I hope this can be the case for future
deprecations too).  If for nothing else, it'll enable us to do away with
three different emulations at the very least.  I mean we can't of course
do away with padsp and then some still only work with aoss and then we
need in-kernel ALSA OSS emulation as the final fallback when both fail.
 It's a big mess and ossp can basically OSS emulation as good as
in-kernel ALSA OSS w/ muxing.

Thanks.

-- 
tejun
