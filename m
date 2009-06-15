Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZFOMSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZFOMSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZFOMSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:18:43 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:56845 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbZFOMSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:18:43 -0400
Date: Mon, 15 Jun 2009 14:18:35 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: "Li, Jiebing" <jiebing.li@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Subject: Re: [PATCH 0/1] MMC: SDIO driver for Intel Moorestown  platform
Message-ID: <20090615141835.6206b36b@mjolnir.ossman.eu>
In-Reply-To: <95608CFE3D0C064B8468DB61F8403BE036C19F9C0D@PDSMSX501.ccr.corp.intel.com>
References: <95608CFE3D0C064B8468DB61F8403BE036C19F9C0D@PDSMSX501.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25857-1245068322-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25857-1245068322-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Jun 2009 20:05:14 +0800
"Li, Jiebing" <jiebing.li@intel.com> wrote:

>=20
> Hi Pierre and all,
>=20
> Here's a SDIO driver code patch for Intel Moorestown platform. Per your r=
esponse of my code submission last month, I modified the code and hope that=
 you could spare time to review this patch, which is used for SDIO card pow=
er management. It's very important for MID products like Moorestown, as pow=
er saving is the key point for such embedded products.
>=20

First off, you need to split up your changes into several patches, one
for each feature. I refuse to review a patch that contains several
changes like that. Look at other commits in the kernel tree and how
they separate each functional change into its own patch.

> Last time you asked me the use cases for the code. The following is my st=
atement:
>=20
> 1. sdio_bus_suspend()/sdui_bus_resume() and mmc_sdio_suspend()/mmc_sdio_r=
esume():
> Currently SDIO bus driver doesn't have suspend/resume interface, We need =
this to suspend the functions one by one and then the whole card when the p=
latform is put in S3/S4/S5 states.
>=20

This should happen anyway as the host controller's suspend functions
are called when there is a system wide PM state change. As the MMC bus
powers down, the SDIO devices will get removed. What extra
functionality is it you need in this area?

> 2. sdio_external_suspend_device()/sdio_external_resume_device():
> Also, similar to USB, we would like to be able to selectively suspend a p=
articular function using sysfs interface for power management scheme (non-A=
CPI) if the function is not in use.=20

Like Matthew pointed out, this is not desirable. The drivers should be
intelligent enough to determine when to enter low power states by
themselves.

I think you need to have a high-level discussion with Matthew and
Rafael first on how we want the PM to be performed before I can approve
any such changes.

> 3. sdio_reset_device():
> It comes to solve a scenario where there is a hang in the Host Interface =
HW, (i.e. the driver cannot access the device).  In this case the function =
driver can detect that something is broken (using some sw watchdog for exam=
ple), but it cannot reset its function (host interface is broken).=20
>=20

I assume you're talking about the SDIO card here, not the host
controller as the host controller driver should fairly easily detect
when it has locked up.

The idea is sensible, but I'll have to see a proper patch before I can
make any comments on your approach.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25857-1245068322-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko2PB8ACgkQ7b8eESbyJLhnTwCg4msS8R34OMVkGaqm+5KLtkzC
4AUAn0VRUdUCMDOnKRrcjMrz9QD38Ybj
=DmhJ
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25857-1245068322-0001-2--
