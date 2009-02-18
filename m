Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZBRIiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZBRIiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 03:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZBRIhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 03:37:55 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:4801 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZBRIhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 03:37:55 -0500
Message-ID: <499BC8D5.9030005@imap.cc>
Date: Wed, 18 Feb 2009 09:37:41 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28.[45] boot failure: request_module: runaway loop modprobe
 binfmt-464c [SOLVED]
References: <499A7EE2.50108@imap.cc> <ac3eb2510902170201t696df348ka167c12ad5819494@mail.gmail.com>
In-Reply-To: <ac3eb2510902170201t696df348ka167c12ad5819494@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig81B807EFAD4863FA708C2D1F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig81B807EFAD4863FA708C2D1F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Feb 2009 11:01:51 +0100, Kay Sievers wrote:

>> request_module: runaway loop modprobe binfmt-464c
>> request_module: runaway loop modprobe binfmt-464c
>> request_module: runaway loop modprobe binfmt-464c
>> request_module: runaway loop modprobe binfmt-464c
>> request_module: runaway loop modprobe binfmt-464c
>=20
> Are you sure, that you don't have a 32/64 bit mismatch between the
> kernel and userspace? Like you miss 32-bit emulation in a 64-bit
> kernel, or your modprobe is 64-bit and you are trying to run it on a
> 32-bit kernel?

Aaaugh, never mind my previous reply, you were right on spot!
"make install" had picked up the wrong root partition when it
created the GRUB menu entry for the new kernel, so it actually
tried to boot an experimental 64 bit installation on a different
disk with my newly built 32 bit kernels. That'll teach me not to
choose too similar partition names.

Now to find out how "make install" creates its GRUB menu entries
and why it suddenly started to go wrong ...

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig81B807EFAD4863FA708C2D1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJm8jgQ3+did9BuFsRAkTAAJ9+aJODv2V41ADhkEX07uZvRrvCPgCeLzLr
Gw4JB1Xkk22tIbHEvvXo6gg=
=L3q2
-----END PGP SIGNATURE-----

--------------enig81B807EFAD4863FA708C2D1F--
