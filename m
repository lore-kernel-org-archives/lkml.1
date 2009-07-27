Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbZG0RQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbZG0RQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZG0RQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:16:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:13277 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZG0RQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type;
        b=rfhNDLI9FE9qv3epiRUqoj70gdKmnmtISyv/MytFi3Lhb7N33smUZSeJ+Gp5x5171L
         AwKDGQFKHz9ceMnrYogjL7kNAK/Kx5CMRQ3SxRmC5lozILvVVWeBRyMMOuDWGDC0Xaxb
         dhVHsO5RE9ur5Ivo8y8Gqb7iSZRb5s1fsIpfc=
Message-ID: <4A6DE0DC.2070207@gmail.com>
Date: Mon, 27 Jul 2009 13:16:12 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>
Subject: [regression] sched_getaffinity fails with EINVAL in 2.6.31-rc4
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8EF4046C3C6F8707843ABBA2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8EF4046C3C6F8707843ABBA2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I am not sure when this started, but noticed that sched_getaffinity is
not working in -rc4.

[pid  6254] sched_getaffinity(0, 128, 0x7f80586b1fe0) =3D -1 EINVAL
(Invalid argument)

Here is a simple program for reproduction:

#include <sched.h>

int main(void)
{
	cpu_set_t mask;
	int ret;

	ret =3D sched_getaffinity(0, sizeof(mask), &mask);
	if (ret < 0)
		perror("getaffinity");

	return ret;
}

If I get time, I will bisect this later today.

Regards,
-Greg


--------------enig8EF4046C3C6F8707843ABBA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkpt4NwACgkQP5K2CMvXmqHtDACfesMe+MYITuRmZfg/iR1ktoVW
BEMAnRam4uxRkjD4X4k/o5VpmW0XVVih
=HGh2
-----END PGP SIGNATURE-----

--------------enig8EF4046C3C6F8707843ABBA2--
