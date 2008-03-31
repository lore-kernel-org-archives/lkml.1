Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYDALsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYDALsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYDALsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:48:05 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:45193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYDALsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:48:03 -0400
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>
In-Reply-To: <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
References: <20080330184259.GB21375@atjola.homenet>
	 <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EmMXLMfqXt3ymICB5xwi"
Date: Mon, 31 Mar 2008 22:21:10 +0200
Message-Id: <1206994870.5143.7.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EmMXLMfqXt3ymICB5xwi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-03-30 at 14:51 -0700, Linus Torvalds wrote:

> On Sun, 30 Mar 2008, Bj=C3=B6rn Steinbrink wrote:
> >
> > I can't reproduce the bug on my UP box and currently can't afford
> > crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> > guess it needs SMP to crash), so while this doesn't show any new
> > problems, I can't tell whether it actually fixes anything. Testers
> > welcome!

Odd, I can reproduce trivially on UP. The patch definitely helps.

> Ok, I applied this because I will do an -rc8 today or tomorrow, but I=20
> really really hope somebody can figure out what made this all start to=20
> trigger.

Unfortunately, I can't even bisect, I just tried compiling 2.6.25-rc1
and it failed to link because of __udivi3, __umodi3 and another one (or
similar). A quick look failed to tell me why I get that with -rc1 and
-rc2 but not -rc7.

Below is a simple test program. Run it on any event device, then rmmod
the module the device belongs to and abort the program with ctrl-c.

johannes

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/input.h>

int main (int argc, char **argv)
{
	int fd;

	if (argc < 2) {
		printf("Usage: grab /dev/input/eventX\n");
		printf("Where X =3D input device number\n");
		exit(1);
	}

	if ((fd =3D open(argv[argc - 1], O_RDONLY)) < 0) {
		perror("grab[open]");
		exit(1);
	}

	if (ioctl(fd, EVIOCGRAB, 1)) {
		perror("grab[EVIOCGRAB]");
		exit(1);
	}

	printf("interrupt to exit\n");

	while (1)
		sleep(1000);
}


--=-EmMXLMfqXt3ymICB5xwi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/FHtaVg1VMiehFYAQL8sQ/+NAqcpPdG5HeAo7KbyIIKBpGt3FVgUSmE
k8ezDp60emlwyKG33sYNfx+qOYkEZkTMMSUY0LHjBD3N0d1rGeB0LubB2yqoacxT
+y2yqUStRYejZZzErOXGeZRWiARYqNIOrlfLbPIbXOB28pgbwrAnO0bULgYxK7Sq
tXsF+p52oOmyV+C/SoCOpczzL84R3yxkJck/yWvMaAssI/1nr/yEaJ2IAYK9WpYc
Co+73aaoJKA8yt1qPAMosmCmZKJyfcutldxrO3WkoYrdqf+iKeZVaq6aPBRFfHOW
U+aD+NqlJJA126781e/1vGdUm3Io69zi8VnGT4/9YWL2EJUWUmKiDUVWPHMu7QaG
UaMGUoAb9NAT0IFyHfNqiWjkRxudXy/FB4abijnWg8gn5D1eyGPJ58KVkt1tWhZL
NknN1d9naGCkBYjy0Vtqey+Gh465DvLjZFtz8Y2184Ce/OkERCe1OEDsXiLt7tGx
AiYg5Nr4eFF1SQqXmRqvp8eKSj9y9RNvodSYuBagnoLhdaY7Suwku42CIsxfNZ7X
CUTi+v5sYa6WdDzpodvl5hb+gDDObU7stIobLbKkUk46XUqFM8zKA+0hDKjWgs64
RrtBmCBbkdDFKtCYSwDgnVvWLhfbfYaLpKiQn05e7ABaCmnxX8uPubQcqcJvryla
Ns0+vqMNxXE=
=2RG4
-----END PGP SIGNATURE-----

--=-EmMXLMfqXt3ymICB5xwi--

