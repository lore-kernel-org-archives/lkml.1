Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbXJ3Tc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbXJ3Tc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbXJ3TX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:23:59 -0400
Received: from mx27.mail.ru ([194.67.23.23]:28035 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105AbXJ3TX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:23:57 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 - self-destructing sysfs attributes
Date: Tue, 30 Oct 2007 22:23:47 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9404079.ePk1f0kzjC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710302223.52508.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9404079.ePk1f0kzjC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I realized that in patch for ACPI battery I created perfect example of=20
self-destructing sysfs attributes. Basically, on every access to battery=20
properties we check battery status. If ACPI reports battery not present, we=
=20
remove sysfs power_supply object. I.e.

=2D> user space queries e.g. .../PNP0C0A:00/power_supply/BAT1/energy_now
  -> call acpi_battery_update
    -> battery gone
       -> call power_supply_unregister(.../PNP0C0A:00/power_supply)

I remember discussion about this but am not sure what final outcome is. So=
=20
questions

=2D is it legal in this form?
=2D what is the proper way to manage such situation?
=2D if I move (de-)registering of power_supply out of acpi_battery_update, =
is=20
extra locking (refcounting) required to keep attributes alive or sysfs will=
=20
ensure this?

TIA

=2Dandrey

--nextPart9404079.ePk1f0kzjC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJ4TER6LMutpd94wRAoqwAKC2WdNI2CUSN7u7a11MotVbHMeEygCgyln+
Wqs4RSYvgVouYyzHUBVY76g=
=P+4d
-----END PGP SIGNATURE-----

--nextPart9404079.ePk1f0kzjC--
