Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZD2VKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZD2VKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZD2VKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:10:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZD2VKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:10:03 -0400
Subject: Re: Regression since 2.6.30-rc1 - Page allocation failures
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49F8C03D.6040909@lwfinger.net> (sfid-20090429_230225_847074_E5413886)
References: <49F8C03D.6040909@lwfinger.net>
	 (sfid-20090429_230225_847074_E5413886)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ydCRRDpPF75FS1BNa8Q5"
Date: Wed, 29 Apr 2009 23:09:32 +0200
Message-Id: <1241039372.4547.3.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ydCRRDpPF75FS1BNa8Q5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Larry,

> I have been getting a number of page allocation failures of late on my x8=
6_64
> system. The user-space app that hits the problem varies; however, there i=
s
> always a network connection. In addition, the failure is always of order =
1. For
> the instance reported below, git was updating a tree mounted on an NFS vo=
lume.
> The problem started with 2.6.30-rc1, but persists with -rc3.
>=20
> I have seen the problem with the b43 and p54usb wireless drivers. The use=
r-space
> apps include cc1, git components, and firefox; thus not all involve nfs.
>=20
> I will be happy to supply any further information.
>=20
> kernel: git: page allocation failure. order:1, mode:0x4020

> kernel:  [<ffffffffa0220711>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
...
> kernel: 427298 pages non-shared

It's a little curious that you have order:1 allocations here. I think
below the printout you showed you would see a line like
	phy0: failed to reallocate TX buffer
Is that there? Could you track down that message in the code (around
net/mac80211/tx.c line 1368) and add to it the following:

	"%d, %d, need %d, %d", skb->data_len, skb->len, head_need, tail_need

and then try to reproduce this problem please? With both p54 and b43 you
should only have packets far smaller than 4096 bytes so no order 1
allocation should be needed, afaict.

johannes

--=-ydCRRDpPF75FS1BNa8Q5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+MIJAAoJEKVg1VMiehFY1GUQAK00JDonUcLjtppdllD35iXE
liKFdRAI0o6oRru++Ui3PWyl5PwghRgwwIDXsLw+JTxsYEwykb4H0jgCjLmftgNv
oyKq6q3PvlMT8DFd5fda2cQHXo+VBfAxXicAGBEbr29z6ecSQsVeFEa1Fq0MNzfw
LzYAh9vtFQQ1XVTwdVeNXTuOq/04KW0BdzEg1JUaazsuDZ6STuz2M4y9p7bujM3F
vQi3+44f62zKNG7xVnHyzpYCJzrJctYAo1TQUExzdlbzmAPwQH9HrJV1qFXE1gIc
ioMPXrG27AlFY0fbIQu6mw6a8bVgIM9dn6DvN9j8KqwbWUzodIZgWLxULtt/G+uX
XaKqPgrDeQvABFvWa+uUZfzFXTEuMrbrcE717mifOeHL8PhzO+4xAgtgXQqQGWIp
IaB8Re/hZ99RisFKV7r7R9XUPqfe0hSA+HLoIeHNoo0Pr54ctM/5osFTCTpvBw4i
2iKqQNzZmfiBN32m8tQRLNmhjT/qFRRD4nepOCFcmoqeK1zBYgokqzcahIaxazHY
V6DYVlOT/xanZULPd6myu/COTJiklGtOdBNJ2CuAUmw/UhJKRW+ZezJ1/R+hg82A
GtEdNgrr21G8712uU93P5GEf/E0/G0nHCSlX+WbyP31v5GdBJj9PBn0dDGk7dP7b
jEV5NE/sZQE0rTtrWbDu
=4yeU
-----END PGP SIGNATURE-----

--=-ydCRRDpPF75FS1BNa8Q5--

