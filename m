Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbXGDWeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbXGDWeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXGDWeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:34:13 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:59994 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968AbXGDWeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:34:12 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Thu, 5 Jul 2007 08:34:17 +1000
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200706302230.19040.rjw@sisk.pl> <20070704212907.GA3213@elf.ucw.cz>
In-Reply-To: <20070704212907.GA3213@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2893916.ujJ5CPrF6u";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707050834.17747.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2893916.ujJ5CPrF6u
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 07:29:07 Pavel Machek wrote:
> Here's the version that uses just one variable, relative to Nigel's
> patch. Hmm, and it also closes nasty trap for the user in
> acpi_sleep_setup; order of parameters actually mattered there,
> acpi_sleep=3Ds3_bios,s3_mode doing something different from
> acpi_sleep=3Ds3_mode,s3_bios .  It actually works here.

Good catch.

> Will you fold it into  patch28, or should I create a changelog?
> Testing welcome :-).

I really dislike the overloading of acpi video flags in this way. You yours=
elf=20
have said in the past that new functionality should use /sys instead=20
of /proc, and here you are overloading an existing variable for the sake of=
=20
expediency. Please, stick with a new /sys/power entry.

Documentation is also an issue. Your patch should update the kernel_paramet=
ers=20
file so users can know how to get the beeping to happen. It would be nice i=
f=20
it mentioned the proc entry too.

[...]

> @@ -80,9 +82,11 @@ static int __init acpi_sleep_setup(char=20
> =20
>  __setup("acpi_sleep=3D", acpi_sleep_setup);
> =20
> +/* Ouch, we want to delete this. We already have better version in=20
userspace, in=20
> +   s2ram from suspend.sf.net project */

Do we? This version has advantages in not requiring any userspace app and i=
n=20
being able to work even if you can't yet get as far as having userspace=20
working. [Reads more] Oh, do you mean a better way of setting this paramete=
r=20
(ie requiring the userspace app and then having it echo $VALUE=20
> /proc/sys/kernel/acpi_video_flags? Considering we're not going to suspend=
=20
to ram during init scripts, we have a way of setting/resetting it post-boot=
=20
with or without s2m and the flag doesn't therefore need to be command line=
=20
option, I can go with that. Does it need a patch to mark it as deprecated?

[...]

> @@ -124,7 +124,7 @@ real_save_cr3:	.long 0
>  real_save_cr4:	.long 0
>  real_magic:	.long 0
>  video_mode:	.long 0
> -video_flags:	.long 0
> +realmode_flags:	.long 0
>  beep_flags:	.long 0
>  real_efer_save_restore:	.long 0
>  real_save_efer_edx: 	.long 0

Beep_flags should be removed too if you're sticking with /proc.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart2893916.ujJ5CPrF6u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjCBpN0y+n1M3mo0RAoLFAKCRO7ja5n5B3N3baAfo+M4YDi/glACg0GDV
V4ti6PmnrJbMbH4gZQE1jNQ=
=Vt+z
-----END PGP SIGNATURE-----

--nextPart2893916.ujJ5CPrF6u--
