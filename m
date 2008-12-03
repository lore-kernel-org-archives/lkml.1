Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYLCRXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYLCRXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYLCRXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:23:07 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:43608 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYLCRXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:23:06 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alex Chiang <achiang@hp.com>
Subject: Re: Problems with fakephp
Date: Wed, 3 Dec 2008 18:22:55 +0100
User-Agent: KMail/1.9.10
Cc: Trent Piepho <xyzzy@speakeasy.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci" <linux-pci@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de
References: <20081126074808.GE6539@plum> <Pine.LNX.4.58.0812021729560.2943@shell2.speakeasy.net> <20081203043804.GA26130@ldl.fc.hp.com>
In-Reply-To: <20081203043804.GA26130@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1452199.HNnna02B7h";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812031822.57197.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1452199.HNnna02B7h
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alex Chiang wrote:
> * Trent Piepho <xyzzy@speakeasy.org>:
> > On Mon, 1 Dec 2008, Alex Chiang wrote:
> > > I think there are now enough ideas in this thread that they're
> > > starting to get confusing.
> > >
> > > 	1) Function vs. device removal
> > > 	2) User interface
> > > 	3) Existing fakephp bugs
> > >
> > > For (1), do you need function level hotplug? Or will you be able
> > > to get away with device level?
> >
> > While I have some hardware the can use function level hotplug (secondary
> > functions can be controlled by registers in the primary function), it's
> > not something *I* make use of.  But function level hotplug has been the=
re
> > for years so it seems like a regression to remove that ability and break
> > the existing interface.
>
> That seems reasonable.
>
> > I guess my first though is should be there a new interface, as part of
> > the pci core rather than pci hotplug, for adding/removing devices from
> > Linux's view?  By devices I mean in the Linux "struct device" sense, so
> > PCI functions.
> >
> > I think that seems reasonable.  fakephp isn't the best interface.  My
> > patch to add "remove" to pci-sysfs ended up being very simple, unless
> > there's a serious flaw in it I've overlooked.
>
> I think we should definitely merge your 'remove' attribute patch
> for PCI functions. That should be independent of the rest of our
> discussion.
>
> It will probably help the SR-IOV folks too.
>
> > So once we have that the question becomes how to keep some compatibility
> > with the old fakephp interface.  Either a new legacy compat module like
> > I've done or by fixing fakephp.
> >
> > I'm more inclined to have the new legacy compat module:
> >
> > - It's quite a bit simpler than fakephp so far.
> > - It already works better than fakephp ever did.  fakephp can't do
> > recursive bridge removal and won't co-exist well with a new pci core
> > remove/add interface.
> > - Fakephp's use of devices as "slots" appears to be fundamentally at od=
ds
> > with the hotplug core.  It's just going to cause problems in the future.
> > The new compat module doesn't use hotplug at all, so it shouldn't get in
> > the way.
>
> Maybe we should just replace fakephp wholesale with your new
> driver?
>
> Or coming at it from another angle, I don't see what benefit
> we'll have from keeping both fakephp and your driver. And if
> fakephp is as broken as you describe, then it will only cause
> more confusion if a user loads both fakephp and legacy_fakephp.
>
> If the user removes a bridge via the correct legacy_fakephp
> interface, fakephp won't notice, and we'll just have a broken
> mess on our hands.
>
> It would be better to have just one, correctly working fakephp,
> even if the implementation is 100% different and truly not even a
> "real" hotplug driver.
>
> I think the way forward is:
>
> 	- merge in the function level hotplug patch

Sorry that I don't get the point. To PCI Hotplug core or to fakephp?

> 	- wholesale replacement of fakephp with new fakephp
> 	- schedule new fakephp for deprecation
                   ^^^

I don't think so.

> 	- encourage anyone who wants function level hotplug to
> 	  use the 'remove' attribute
>
> Thoughts? Jesse, Willy, Eike, Greg?

Oh yes, let's start using dummyphp ;) That one already handled the rescan l=
ong=20
ago. But I think it's a bit outdated at the moment, I haven't touched it fo=
r=20
month. Looks like I need to bring it back to live.

Eike

--nextPart1452199.HNnna02B7h
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk2wHEACgkQXKSJPmm5/E7LlACeLYnw3Ee2r/nPAJ+SnHiBil9J
P4gAn2u39bUIlLg8ndSdZZ53O1qi727Y
=SguZ
-----END PGP SIGNATURE-----

--nextPart1452199.HNnna02B7h--
