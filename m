Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609Ab0ABOEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab0ABOEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 09:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477Ab0ABOEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 09:04:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58234 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab0ABOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 09:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=Q0jsTVJxpbW8FYIC89gCyaFmvAsLP/1Dgef5FCc7vfKvekxzLK2U14r1E1lTAkIayd
         4y6WQwH4n8PnZbN5y0oXAwVLAt58PJkzVikL7lYsVwhXqNgoN32b487FIF1CEzsrG8JD
         1l8CgvQXYX4FrXnQKTp6/fKAFR8nB4jc+ArOo=
Message-ID: <4B3F5264.7000008@gmail.com>
Date: Sat, 02 Jan 2010 15:04:20 +0100
From: Daniel Borkmann <danborkmann@googlemail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace notification from module
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
In-Reply-To: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD35EA0892E837536AD04B19E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD35EA0892E837536AD04B19E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Bart=C5=82omiej,

Bart=C5=82omiej Zimo=C5=84 wrote:
> Dnia 2 stycznia 2010 13:36 	Daniel Borkmann <llug.dan@googlemail.com> n=
apisa=C5=82(a):
> I will explain more what i'm going to do.
> The idea is simple. Kernel before suspend/resume sends notification to =

> registered kernel objects. So i have written small module to register
> there and want now pass these data to /dev/file. It is 1byte so not a b=
ig deal.
>=20
> I'm searching now for notification about new byte in buffer, as it is a=
lmost=20
> clear for async: http://www.xml.com/ldd/chapter/book/ch05.html#t4
> but for sync still haven't find.

This sounds very interesting... a "hack" could be the following:

Register your pids to the kernel module, e.g. via ioctl, and if the
(intra-kernel) notification will be delivered to your module you just
send a signal to your registered processes via kill_proc_info(). Guess
this is at least better than polling a file or sth similar.

I guess netlink could be the "cleaner" solution, but with more overhead?!=


Cheers,
Daniel


--------------enigD35EA0892E837536AD04B19E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAks/UmQACgkQ5AxJm1m3CC/KlgCgkmOfUgofUQQXSnrCB6atJL7e
4IQAnimDjQZLf++CzmGsfCn8jcakpqGq
=Fhfa
-----END PGP SIGNATURE-----

--------------enigD35EA0892E837536AD04B19E--
