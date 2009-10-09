Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbZJIQO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbZJIQO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933799AbZJIQO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:14:59 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782AbZJIQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:14:57 -0400
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091009090601.73de5dc6.randy.dunlap@oracle.com>
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com>
	 <1254949672-24022-1-git-send-email-linville@tuxdriver.com>
	 <4ACD0E5A.7060106@oracle.com> <1254954842.3713.7.camel@johannes.local>
	 <4ACD1C3D.3030506@oracle.com> <1254957256.3713.10.camel@johannes.local>
	 <20091007171235.d40f0cc2.randy.dunlap@oracle.com>
	 <1254995282.3713.18.camel@johannes.local>
	 <20091008080615.09c8b803.randy.dunlap@oracle.com>
	 <1255026563.3713.28.camel@johannes.local>
	 <20091009090601.73de5dc6.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CPyelya3Wm8vFfQVuIU3"
Date: Fri, 09 Oct 2009 18:14:06 +0200
Message-Id: <1255104846.4095.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CPyelya3Wm8vFfQVuIU3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-09 at 09:06 -0700, Randy Dunlap wrote:

> >  menuconfig WLAN
> >  	bool "Wireless LAN"
> >  	depends on !S390
> > +	select WIRELESS
> >  	default y
> >  	---help---
> >  	  This section contains all the pre 802.11 and 802.11 wireless
>=20
>=20
> I suppose that's OK, although I prefer "depends" rather than "select".

I tend to as well, but in this case the WIRELESS itself is just an
option that makes other options invisible, it's not used elsewhere, and
as such I think this is ok -- why hide the wireless drivers unless the
user first selects the wireless core options?

OTOH, you already need to select cfg80211/mac80211 for most drivers, so
I suppose "depends on WIRELESS" would be ok too.

> I tracked down one of the problems that I was seeing:
>=20
> net/wireless/wext-priv.c:206: error: implicit declaration of function 'ca=
ll_commit_handler'
>=20
> with:
> # CONFIG_WIRELESS is not set
> CONFIG_WIRELESS_EXT=3Dy
> CONFIG_WEXT_PRIV=3Dy
>=20
> This is being caused by several drivers in drivers/staging/ doing
> 	select WEXT_PRIV
> without using either enough dependencies or even more (ugly) selects.
> (or just because kconfig isn't sufficient)

Hah, staging/, well, that's kinda hard to solve I guess. Except by
fixing all the staging/ drivers to depend on WIRELESS too, like the
patch would do for the regular drivers.

I think you can get the same effect now with the non-staging drivers.
I'll submit this patch formally and ask John to include it, and staging/
can just depend on WIRELESS.

johannes

--=-CPyelya3Wm8vFfQVuIU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKz2FLAAoJEODzc/N7+QmaD3MP/1Cg/Gy/r4aXIAi8orWeUOZe
1EIbAPLYlSxKjsS+kGi7Kk3e3//chtXkddb6Qrg7FEy/m2e1funPxIxF1gaG5h30
EQFEbP4PdVzAIFX/wgRRj3t6qeTmhR2Fu4b6z88mDhZUUNGGheRkZqb1t50zGcVz
GM5dZ6uKctvA3l5T/tIzm9HwNER3hHFVl/nRwys3zJ7/8LAbfyIyfjQuWt3ubbdy
QQ6edwi6pBAtG8NoEY55S5hFFgqFcAMjdu9PC4ufNd/AOkgdUO6+SlzTrK52y1W6
XM80bHLL+pxxq0khJlIrFSDd4oPCyic5bhn3FhbtnKhth8MTG0HLRhvFiri/Pobo
Fa7trbR1gLK5nVr34z/6vXDIXW83i3nbst7N9aC00RqPs2BwC/w0CRTZ9yMzh37d
ygYtGBxjndrblaVRfvgNhWJxOlRtEQYiRumcuA/phmxtiR7IrMpzzy7cl9+0q4Ss
SORpL6C/VKoxiysAQ4Q0bw7Ybc/5Ll0WMX0QmH737RU7sgvtatuef0MZtW/Oa/yP
uMnTO/CO5s/7TEQOnbu7OGvBqz77bmMjSuqb8ZAe0mn3ym7H9ZvzJ/Dl4MuF0cH8
NZdoi9FahPl/aPFc1sQjB3CYF9jRHQLIMovOT6Ew4j2tENE1jSI/K7GOxhMWRXFT
+7NGlr9WZ7E+8YIRn2xr
=6iu+
-----END PGP SIGNATURE-----

--=-CPyelya3Wm8vFfQVuIU3--

