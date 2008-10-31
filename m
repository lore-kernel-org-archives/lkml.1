Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382AbYJaKf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbYJaKf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 06:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYJaKfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 06:35:19 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYJaKfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 06:35:16 -0400
Subject: Re: [RFC] B+Tree library
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081026124643.GA1328@logfs.org>
References: <20081026124643.GA1328@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hr1sxVM82v7go7P6laxw"
Date: Fri, 31 Oct 2008 11:35:14 +0100
Message-Id: <1225449314.3535.23.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Hr1sxVM82v7go7P6laxw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[looks like this hitting LWN means everyone suddenly found it...]

> The one aspect where my implementation is actually nice is in allowing
> variable key length.  Btree keys are interpreted as an array of unsigned
> long.  So by passing the correct geometry to the core functions, it is
> possible to handle 32bit, 64bit or 128bit btrees, which logfs uses.  If
> so desired, any other weird data format can be used as well (Zach, are
> you reading this?).

Would there be an easy way to use 48-bit keys? Or variable length keys?

> So would something like this be merged once some users are identified?
> Would it be useful for anything but logfs?  Or am I plain nuts?

I could imagine using it instead of the hash-table for stations and APs
in the wireless code, stations are identified by the MAC address (48
bit) and APs (BSSs) are identified by their BSSID+SSID (or mesh ID), so
variable length. Currently we use a hash table with 256 slots which is
quite large for the typical case of mostly less than a hundred entries.

> This implementation is extremely simple.  It splits nodes when they
> overflow.  It does not move elements to neighboring nodes.  It does not
> try fancy 2:3 splits.  It does not even merge nodes when they shrink,
> making degenerate cases possible.  And it requires callers to do
> tree-global locking.  In effect, it will be hard to find anything less
> sophisticated.

I think the wireless case would probably want to have real shrinking
because it's well possible that you're moving, with your laptop, from an
area with a large number of APs to say your home out in the countryside
that only has your single AP.

johannes

--=-Hr1sxVM82v7go7P6laxw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCt9dAAoJEKVg1VMiehFY9QoP/R9udkbeo3fWJOQSxMUr4NiX
W/ThNrj0ivfSu14QE+b3gJ5ke/PMcdXtexphOxCIoUir4tJGWQlydGX9XB9D69aq
ZemKzirar8MaP6JO830yeSzrW0G1xkTGbkgPwMaqaaM1NtR7NNpqqPrZmFdqdzAa
KW54MmAX12oc8pF6J/Vq4BLwovS7Nua+mQasnB15Cn8d/RLnZA+QEtoqbKbXD6Zw
pg4Smg/yIKO9wUCaGeZY7kOFLVqBBbkjVFCt+mvEWCD/NEbjY1oAWwSdVGQ6FWyE
6QicrY++xlr6VlCDR3Z5bCRvO1poPEXrrvuIaziaKXbrPHJFnYW3AXVoXTq67y+e
K+pa0hFl9aeBLBXwqkNpFL3+O77XXQElgndEbQTXE6t2UuIHygCA2YdvWkeB7i1f
eteyguwn1tXrl8PK9HESj7PpOpIFGqyHd39m8juMWUN9ZQgNtcYVjstq2vTtYfJU
3D+qEjtjIwFzP5rKUBExTrEWmA0QGyD47zgjYEJs+dZgTOupB9UEdyuLWoBcXgj8
PmrZnp2J0GIn0PBE1dfRd5sUk9dpIrRsKjrzkIArtYNV9cyolLo/b3aW6hTHBb9h
2niKTsd1mICVV87C0b8ZBdBPM1Od2RvLuqISzm79jk2IIpbv3wkrGZZnhk7bxXuX
6aeQaiaZTPcmqo3MxauY
=3Hdl
-----END PGP SIGNATURE-----

--=-Hr1sxVM82v7go7P6laxw--

