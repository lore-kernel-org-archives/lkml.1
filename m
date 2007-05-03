Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbXECHS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbXECHS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXECHS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:18:29 -0400
Received: from lugor.de ([212.112.242.222]:33505 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752654AbXECHS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:18:27 -0400
From: Christian Hesse <mail@earthworm.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: build system: no module target ending with slash?
Date: Thu, 3 May 2007 09:17:15 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, James Ketrenos <jketreno@linux.intel.com>
References: <200705030043.49208.mail@earthworm.de> <20070503042511.GB12644@uranus.ravnborg.org> <20070503061533.GA13399@uranus.ravnborg.org>
In-Reply-To: <20070503061533.GA13399@uranus.ravnborg.org>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1436080.j5VPoaYkFf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705030917.19630.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Thu, 03 May 2007 09:18:21 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1436080.j5VPoaYkFf
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 03 May 2007, Sam Ravnborg wrote:
> On Thu, May 03, 2007 at 06:25:11AM +0200, Sam Ravnborg wrote:
> > On Thu, May 03, 2007 at 12:43:43AM +0200, Christian Hesse wrote:
> > > Hi James, hi everybody,
> > >
> > > playing with iwlwifi I try to patch it into the kernel and to build it
> > > from there. But I have a problem with the build system.
> > >
> > > The file drivers/net/wireless/mac80211/Makefile contains one single
> > > line:
> > >
> > > obj-$(CONFIG_IWLWIFI)   +=3D iwlwifi/
> > >
> > > When CONFIG_IWLWIFI=3Dm in scripts/Makefile.lib line 29 the target is
> > > filtered as it ends with a slash. That results in
> > > drivers/net/wireless/mac80211/built-in.o not being built and the build
> > > process breaks with an error. What is the correct way to handle this?
> > > Why are targets ending with a slash filtered?
> >
> > Looks buggy. I will take a look tonight.
>
> After some coffee...
>
> Line 29 in Kbuild.include find all modules and a directory is not a modul=
e.
> In line 26 in same file the directory iwlwifi is included in the list
> of directories to visit.
> So there is something else going on.

In scripts/Kbuild.include line 26 is empty and line 29 is a comment... Do I=
=20
look at the wrong place?

I still believe in my version: built-in.o is built if any of $(obj-y) $(obj=
=2Dm)=20
$(obj-n) $(obj-) $(lib-target) contains anything in scripts/Makefile.build=
=20
line 77. As scripts/Makefile.lib line 29 filters the only target the object=
=20
file is not built.

> Anywhere I can get access to the combined source or could you try to post
> the full Makefile.

I just generated a patch [0] against vanilla 2.6.21 with latest mac80211 an=
d=20
iwlwifi from git. Get my config [1] and you should get my error.

[0] http://www.eworm.de/tmp/iwlwifi.patch.bz2
[1] http://www.eworm.de/tmp/config-iwlwifi-2.6.21
=2D-=20
Regards,
Chris

--nextPart1436080.j5VPoaYkFf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGOYx/lZfG2c8gdSURAkYjAKDG75pXRnxXENwm3zABew0UlJ0GewCbBNu9
9InQdHqNOY3/v5YhbExRWHg=
=2g6C
-----END PGP SIGNATURE-----

--nextPart1436080.j5VPoaYkFf--
