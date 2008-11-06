Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYKFPx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYKFPx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYKFPxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:53:21 -0500
Received: from mx40.mail.ru ([194.67.23.36]:57422 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbYKFPxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:53:20 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
Date: Thu, 6 Nov 2008 18:53:05 +0300
User-Agent: KMail/1.9.10
Cc: Eduardo Habkost <ehabkost@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com> <20081106143021.GD13023@elte.hu> <20081106150610.GA1644@elte.hu>
In-Reply-To: <20081106150610.GA1644@elte.hu>
MIME-Version: 1.0
Message-Id: <200811061853.08003.arvidjaar@mail.ru>
Content-Type: multipart/signed;
  boundary="nextPart3611024.4Tzsott5ad";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3611024.4Tzsott5ad
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[I had to trim direct recipients as my provider would refuse deliver
claiming it is spam]

On Thursday 06 November 2008, Ingo Molnar wrote:
>=20
> * Ingo Molnar <mingo@elte.hu> wrote:
>=20
> > > Andrey Borzenkov's patch, for example, adds a new DMI entry=20
> > > because reboot=3Dacpi breaks his keyboard (even without KVM, I=20
> > > guess). Andrey, was that the case?
> >=20
> > hm, IIRC the problem was KVM in his case too.
>=20
> actually, Andrey's problem seems to be unrelated. So i've queued up=20
> the revert below in tip/x86/urgent for v2.6.28. Thanks guys!
>=20

Yes, I do not use KVM. Actually my CPU (PIII) does not even support
virtualization.

> 	Ingo
>=20
> ---------------->
> From 8d00450d296dedec9ada38d43b83e79cca6fd5a3 Mon Sep 17 00:00:00 2001
> From: Eduardo Habkost <ehabkost@redhat.com>
> Date: Tue, 4 Nov 2008 12:52:44 -0200
> Subject: [PATCH] Revert "x86: default to reboot via ACPI"
>=20
> This reverts commit c7ffa6c26277b403920e2255d10df849bd613380.
>=20
> the assumptio of this change was that this would not break
> any existing machine. Andrey Borzenkov reported troubles with
> the ACPI reboot method: the system would hang on reboot, necessiating
> a power cycle. Probably more systems are affected as well.
>=20

To be precise - system reboots but keyboard is non-functional after that.
Power off is required to clear this condition.

I am fine with either way (revert or DMI). But if problem which ACPI
reboot fixed (or worked around) is not solved differently I think
reverting to old way is better.

> Also, there are patches queued up for v2.6.29 to disable virtualization
> on emergency_restart() - which was the original motivation of
> this change.
>=20
> Reported-by: Andrey Borzenkov <arvidjaar@mail.ru>
> Bisected-by: Andrey Borzenkov <arvidjaar@mail.ru>
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> Acked-by: Avi Kivity <avi@redhat.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/reboot.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index f4c93f1..724adfc 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -29,11 +29,7 @@ EXPORT_SYMBOL(pm_power_off);
> =20
>  static const struct desc_ptr no_idt =3D {};
>  static int reboot_mode;
> -/*
> - * Keyboard reset and triple fault may result in INIT, not RESET, which
> - * doesn't work when we're in vmx root mode.  Try ACPI first.
> - */
> -enum reboot_type reboot_type =3D BOOT_ACPI;
> +enum reboot_type reboot_type =3D BOOT_KBD;
>  int reboot_force;
> =20
>  #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
>=20
>=20



--nextPart3611024.4Tzsott5ad
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkTEuMACgkQR6LMutpd94yH5QCgrM8x9e9RfhnpwYr8marXgSR3
86wAnigAsx3VuR4y/r8Gk0glOdm06Tu/
=Idq1
-----END PGP SIGNATURE-----

--nextPart3611024.4Tzsott5ad--
