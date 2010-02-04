Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab0BDW0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:26:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58630 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326Ab0BDW0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:26:05 -0500
Date: Thu, 4 Feb 2010 22:25:22 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sven Joachim <svenjoac@gmx.de>, Greg KH <greg@kroah.com>,
       stable-review@kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
Message-ID: <20100204222522.GF20379@decadent.org.uk>
References: <1265245849.3362.1.camel@localhost> <1265256174.2952.11.camel@localhost> <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain> <1265272174.2952.20.camel@localhost> <20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de> <alpine.LFD.2.00.1002041102530.3707@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OtP8TOIcu2/MSuWQ"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002041102530.3707@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OtP8TOIcu2/MSuWQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-04 at 11:11 -0800, Linus Torvalds wrote:=20
>=20
> On Thu, 4 Feb 2010, Sven Joachim wrote:
> >=20
> > It seems they are all there, but on my system with 64-bit kernel and
> > 32-bit userland, 2.6.32.8-rc1 still panics in the way noticed by Ben.
>=20
> Ok. Greg - please skip these patches from stable for now. I'll try to=20
> figure out what's up.
>=20
> Sven/Ben: is /sbin/init (or wherever debian puts it) a regular ELF file?=
=20
> Shared libraries? Anything at all special about it? I wonder why it seems=
=20
> to have issues, when other 32-bit programs don't.

In a Debian initramfs, /init is a script interpreted by /bin/sh.

I've now tested i386 userland on an x86_64 kernel with all the relevant
patches on top of 2.6.32.7:

fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-sta=
ck.patch
split-flush_old_exec-into-two-functions.patch
sparc-tif_abi_pending-bit-removal.patch
x86-get-rid-of-the-insane-tif_abi_pending-bit.patch
fix-flush_old_exec-setup_new_exec-split.patch
powerpc-tif_abi_pending-bit-removal.patch

This works perfectly, so far as I can see.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.


--OtP8TOIcu2/MSuWQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIVAwUBS2tJUOe/yOyVhhEJAQo5bhAA0DMAoPf/wXnAV5Tz+4dy3Wd33vO2KloU
AiE8ol9RPMhQfdP/FibiprIo4TBPBKyd+4ne0xS992S+9ulLQW0jhTF0QifYe6J6
F55/dFFfBDCgbCE+sAddp56fYTVYvsDBt9UWoT4v0k+IUG7QJ2YdPN1WEGHmYjMm
8UUlIcvZtXMiYXLxJ3MBYnwY37dAL25+XiaNoSxZrqibHuX9x4jt56W4BRtn4yVh
p9g+u5kQNe+9bA05JsU1LiKUYRcyowEtFlZAKPr8XLtEQM30LTWPXQLpotkEJjj4
dmBR8giT0A3Qdpgc74ntLdSQyZYvNHhA9kA5X2fXae07vlru2CzYQs0UXK2/2ZLs
t3j732x+p6ParvN37a/S5OAkdCURhj2FuueijoI6sSapytnGL8bjkuGBgVvRL9Ne
3pwQdSa6/UpLMnScgSaPFkT1hdF5FWKgk7dGzrJ8U02UYLPVHMvl4muATxtxR5f7
4ssduppLjSgPJabKALZHj8rUyQY+ob1iot7Qt4QBvBo2Xbj7p1HXoxwitU4jP9Jt
Kus6d7nFfrsBmepqNYu8FVA2wbxEvIWEaCEe9i2bDW4yqGTylc0WfSm93LltsFAN
aQS63OstkoTNdLXrJ8TRZfw0c/P8SGEISkvip9y6rb471TY6m/pOnHpz08hVuq6+
ZHwDnxl4ldM=
=OU73
-----END PGP SIGNATURE-----

--OtP8TOIcu2/MSuWQ--
