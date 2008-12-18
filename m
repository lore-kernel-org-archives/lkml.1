Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYLRWMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYLRWMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYLRWMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:12:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:11123 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYLRWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:12:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=BPOCUAqLb6i4GSRRDewYqbzQcvRdjhB3kDpqcG2kNir/ZMkAkhJaLaH6+2X8zaWSda
         U3FpZoiEtWcXKoQfrf3lSfjl2wIyh5TbXRCyzXAyItdtBFbF1xmzOmeBdXpK2GfbrGxN
         0h3G554ZYeiJFDAA9EQgUdDvhebyDxrFO2Ris=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Subject: Re: linux-next: Tree for December 17 (Radeon DRM BUG)
Date: Thu, 18 Dec 2008 23:09:23 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081218; KDE/4.1.3; i686; ; )
Cc: Dave Airlie <airlied@gmail.com>, Kevin Winchester <kjwinchester@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20081217232536.0b18f4a7.sfr@canb.auug.org.au> <200812182000.41727.bzolnier@gmail.com> <1229633355.5650.4.camel@optimus>
In-Reply-To: <1229633355.5650.4.camel@optimus>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812182309.23254.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tOn Thursday 18 December 2008, Dave Airlie wrote:
> On Thu, 2008-12-18 at 20:00 +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 18 December 2008, Dave Airlie wrote:
> > > On Thu, Dec 18, 2008 at 10:14 AM, Kevin Winchester
> > > <kjwinchester@gmail.com> wrote:
> > > > Stephen Rothwell wrote:
> > > >>
> > > >> Hi all,
> > > >>
> > > >>
> > > >
> > > > I get the following BUG in the radeon drm code with today's linux-next when
> > > > I run "startx".  I have not built or tested linux-next in a while, but the
> > > > problem definitely does not occur in mainline.
> > 
> > [...]
> > 
> > This reminds me that drm tree in linux-next still results in BSOD (Black
> > Screen Of Death) on starting X for me (as reported on Saturday [1]).
> > 
> > Actually there is more to it as I discovered that my custom X radeon driver
> > (which is xorg-x11-drv-ati-6.9.0-61.fc10.i386 with "radeon: no need for this
> > anymore" from radeon-gem-cs change reverted, please see [2] for my previous
> > monologue) works fine while following stock driver versions:
> > 
> > 	xorg-x11-drv-ati-6.8.0-19.fc9.i386
> > 	xorg-x11-drv-ati-6.9.0-61.fc10.i386
> > 	xorg-x11-drv-ati-6.9.0-62.fc10.i386
> > 
> > result in BSOD.  OTOH they all work with next-20081128 (modulo hangs with
> > fc10 ones when "radeon: no need for this anymore" change is not reverted).
> > 
> > [ BTW xorg-x11-drv-ati-6.9.0-62.fc10.i386 still causes hangs when used with
> >   non-Fedora kernels and Fedora/kms kernel still has performance problems ]
> > 
> > IOW there are a lot of compatibility issues in recent drm/radeon changes.
> > 
> > Dave, could you please start looking into these problems?  I'm sure that we
> > all want recent drm changes + kms in 2.6.29 but given tight schedule and the
> > way things are looking right now I'm quite sceptical...
> > 
> > [1] http://lkml.org/lkml/2008/12/13/76
> > [2] http://lkml.org/lkml/2008/12/13/77
> > 
> 
> Bart,
> 
> please file bugs in RH bugzilla for Fedora issues. Fedora is shipping
> drivers that aren't upstream, and I'm attempting to resolve the issues
> as they arise. However not having a bug to track stuff in means it just
> goes far enough out of my inbox that I forget about it.

OK, I'll try to put all issues into RH bugzilla once I find some time. 

[ OTOH the hang issue mentioned above happens only with vanilla kernels,
  Fedora kernels are not affected because they ship KMS.  Anyway, you
  could have just told me that you prefer to have a RH bugzilla bug for
  it two weeks ago (and indeed KMS performance issue should have been
  handled through bugzilla -- however this one is of lower priority). ]

> The revert isn't a fix for -ati, and I haven't seen any reports of
> performance problems with profiles attached in my bugzilla.

"isn't a fix" is a brave statement since it makes a difference between hang
within minutes and rock stable operation (sure the revert itself may not be
a proper fix but it works and is a good starting point).  I spend quite some
time narrowing down the bug and this is not exactly the reaction I expected.

[ Well, I can fix/workaround the issues that I encounter quite quickly and I
  don't really have to put extra time into narrowing them down so they can be
  fixed in upstream distro if distro people don't see a value in such work. ]

> I'm booting drm-next on more various radeon hw today to see what I can
> reproduce, most of the kms changes for 2.6.29 are nothing to do with
> radeon at all, we are only upstreaming KMS for Intel hw, so I'm not sure
> what the sceptical bit is about. Its much more likely this is

F9 -> F10 upgrade has been a nightmare for me thanks to radeon/kms
changes (which are still Fedora specific stuff and it is good to hear
that they will not be upstreamed now).

On top of it drm-next tree has been broken for me since next-20081203
(yes, that is two weeks period!).

It could be just my luck and things may be working perfectly for 99.9%
of other people but are you still surprised that I'm sceptical?

> multi-master changes before KMS that are interacting badly.

Yes, multi-master changes are to blame but currently KMS patch depends on
them (though maybe it could be made independent -- I don't know this).

If you want me to try some debugging I will be happy to help but please
start taking more serious approach, and if you don't have the idea where
the problem is or don't have time to work on it currently please just
drop the broken changes from drm-next tree for now.

Thanks,
Bart
