Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXJBEHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXJBEHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 00:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXJBEHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 00:07:45 -0400
Received: from mx27.mail.ru ([194.67.23.64]:5407 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbXJBEHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 00:07:45 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPICA: hw: Don't carry spinlock over suspend
Date: Tue, 2 Oct 2007 08:07:36 +0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1430908.ZjkePZXmro";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710020807.41325.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1430908.ZjkePZXmro
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> On Sunday, 30 September 2007 20:39, Alexey Starikovskiy wrote:
> > ACPI uses acpi_get_register() in order to get into suspend.
> > This function is guarded by acpi_gbl_hardware_lock, which will be carri=
ed
> > into resume phase.
> > At resume interrupts are enabled and first ACPI interrupt deadlocks on
> > this lock.
>
> Ouch.  That might have bitten quite some people, I guess.
>
> > Solution seems to be to not lock register read, as there are no
> > concurrent activity at this point.
> >
> > Reference: http://bugzilla.kernel.org/show_bug.cgi?id=3D7499
> >
> > Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>
> Do you think it's -stable material?

As someone who *has* been bitten by this bug - by all means.

I'd like to emphasize one more point - we were able to debug it only becaus=
e=20
old kernel at least displayed debug messages. Current kernel deadlocks=20
absolutely dead (pun intended). No output to console, no indication what=20
happens. I consider this regression. If at all possible, we should make sur=
e=20
that console output is available as early as possible.

--nextPart1430908.ZjkePZXmro
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHAcQIR6LMutpd94wRApkLAKCHk2/Wr9BQRbuExiyXNPjSvFrrWACfXUM1
dhjBrNRh3tnl9D497S+bEFc=
=2QT6
-----END PGP SIGNATURE-----

--nextPart1430908.ZjkePZXmro--
