Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZEOODX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZEOODX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZEOODO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:03:14 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZEOODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:03:13 -0400
Subject: hibernate vs. WoL
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lSnM9faQs/OAlpHzdOBx"
Date: Fri, 15 May 2009 16:02:40 +0200
Message-Id: <1242396160.5799.92.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lSnM9faQs/OAlpHzdOBx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

According to pm.h one should enable wakup events in the suspend() and
poweroff() callbacks.

However, poweroff is not called for the 'shutdown' or 'restart'
hibernate methods. This seems problematic, since then with proper
drivers platforms that have no 'platform' suspend method then cannot WoL
or anything like that (well, for 'restart' that isn't very relevant).

The only way to hack around that seems to be to implement the
dev->driver->shutdown method, but I don't think that is intended? On the
other hand calling both ->shutdown and ->poweroff seems problematic.

Right now what I'm trying to do is preserve a wireless connection across
hibernate. This is possible by telling the AP that we're asleep, in
which case it will buffer frames for us (it may eventually kick us off
anyway, but that's ok, without telling it we're asleep I don't even
survive a 'reboot' method cycle).

Also, shouldn't it be possible to WoL while your machine is shut down?
How do you program that?

johannes

--=-lSnM9faQs/OAlpHzdOBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDXX8AAoJEODzc/N7+QmaGQsP/iRYUE/Yo9ieQxftVeNHbJfP
C5PIFtqIx/XDxXrPfLC/DlxZmfMwEpOqlkFlt9TEUaSdEu8DcDgmmJP0TlQrMeLp
0pJyh4VCmeP1YHMi77cUiskHW5KD1PFc/322I1mUg4AKUnofMaArF+ffN06MkUCH
dhGfJF8gmbLAd0DaiY3DWFBjdejxXFfUtRieISMkcM/VpKIGYK8SvRHnML9b3KDi
+xWU2B9qJGeXQX+2AhfqBz3aCSObzI9bJEpOmNyx057Q3LmXkP6H5i4K4RwBHGeX
pncqbfXgJF6Y/smBskUDtsJ9tDW1kAmSH7oYOn4fsQ/I6YE1QCyhDk7Aaa2BKvZc
nHlmFdtHSQ3DuhsfdtISAz6vC7Ph+Zk0i/02vzGHa1a/BfS4TbfAl6BiDtXI4ny7
hTH82ceeE472T31u7d60pKeMJC5RymZJ3YoL0/IL1QuWe5W7oiuYuY7at28FF5Mw
f5/sASFa15K9Pk/3rC2J3CfwuE7WbJ+gXMFjzEcybW4Kj2L+YASe7eYpptMtfXX7
pL/9zgdoyz+o5Y5kE9O/bFqffRDQnZmJPkFmAuYeDBhV3MCTp5gdthktVgQmJa5B
lmpWTllWuVxH5qnxzPaYdY10OJ/wuO7/aA3nf55eLUjbWZy6hrlb4VWB0oRYlXh1
ZII6Ynr5fEF9D3Wg/VdT
=716V
-----END PGP SIGNATURE-----

--=-lSnM9faQs/OAlpHzdOBx--

