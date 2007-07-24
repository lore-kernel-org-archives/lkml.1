Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXGXUtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXGXUtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXGXUs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:48:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51943 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbXGXUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:48:56 -0400
X-Sasl-enc: 3Mpc2rULGK9prOapaJTb2IfIKMivSv7AJgGXuOJcSywa 1185310135
Message-ID: <46A665AB.9010207@imap.cc>
Date: Tue, 24 Jul 2007 22:48:43 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Olaf Hering <olh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: 2.6.22-git17 boot failure
References: <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <20070724091018.GA26724@one.firstfloor.org> <20070724095614.GB625@suse.de> <46A64019.4010508@imap.cc> <46A64CD5.2030800@goop.org> <20070724191231.GA359@one.firstfloor.org>
In-Reply-To: <20070724191231.GA359@one.firstfloor.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC759D47B3141EC055BA35F22"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC759D47B3141EC055BA35F22
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 24.07.2007 21:12 schrieb Andi Kleen:
> On Tue, Jul 24, 2007 at 12:02:45PM -0700, Jeremy Fitzhardinge wrote:
>> Phew, I was getting worried there for a minute.  Does the install scri=
pt
>> check for CONFIG_XEN in the kernel config or something?
>=20
> Yes 10.2 mkinitrd does. But it still should work because a dom0
> kernel would obviously need all the drivers. A paravirt ops
> kernel native is like a dom0 variant.

Apparently not, given that the generated init script is mistaking
a native environment for a domU instead of a dom0.

In fact, when running 2.6.23-rc1 natively, no matter if compiled
with or without Xen support, the directory /proc/xen doesn't even
exist:

ts@xenon:~> uname -a
Linux xenon 2.6.23-rc1-testing #6 SMP PREEMPT Mon Jul 23 22:23:41 CEST 20=
07 i686 i686 i386 GNU/Linux
ts@xenon:~> ls -l /proc/xen/
ls: cannot access /proc/xen/: No such file or directory
ts@xenon:~>

The same holds for the non-Xen Suse kernel:

ts@xenon:~> uname -a
Linux xenon 2.6.18.8-0.5-default #1 SMP Fri Jun 22 12:17:53 UTC 2007 i686=
 i686 i386 GNU/Linux
ts@xenon:~> ls -l /proc/xen/
ls: cannot access /proc/xen/: No such file or directory
ts@xenon:~>

But when running Xen with the Opensuse Xen kernel as Dom0:

ts@xenon:~> uname -a
Linux xenon 2.6.18.8-0.5-xen #1 SMP Fri Jun 22 12:17:53 UTC 2007 i686 i68=
6 i386 GNU/Linux
ts@xenon:~> ls -l /proc/xen/
total 0
-rw-r--r-- 1 root root 0 Jul 24 22:08 balloon
-r-------- 1 root root 0 Jul 24 22:08 capabilities
-r-------- 1 root root 0 Jul 24 22:01 privcmd
-r-------- 1 root root 0 Jul 24 22:08 xenbus
-rw------- 1 root root 0 Jul 24 22:01 xsd_kva
-r-------- 1 root root 0 Jul 24 22:08 xsd_port
ts@xenon:~> sudo cat /proc/xen/capabilities
root's password:
control_d
ts@xenon:~>

OTOH, the Opensuse Xen kernel vmlinuz-2.6.18.8-0.5-xen cannot even
be booted natively because GRUB complains immediately:
  Error 13: Invalid or unsupported executable format
Conversely, the Xen loader flatly refuses to load a self-compiled,
Xen enabled 2.6.23-rc1 kernel as dom0, complaining:
  DOM0 image is not an Xen-compatible Elf image.
So I guess the point is moot, because you cannot use the same image
as dom0 and natively, anyway.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigC759D47B3141EC055BA35F22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGpmW1MdB4Whm86/kRApBdAJ9cy/JjgY4GF16+uj6rcyiwSsJESQCffJ2N
icPDC76KEv3qxCQOyZLVSzk=
=dtgA
-----END PGP SIGNATURE-----

--------------enigC759D47B3141EC055BA35F22--
