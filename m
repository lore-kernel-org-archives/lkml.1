Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbYAGWCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbYAGWCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYAGWCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:02:37 -0500
Received: from ozlabs.org ([203.10.76.45]:44060 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYAGWCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:02:36 -0500
Subject: Re: [RFC] PCIE ASPM support
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <1199340944.1642.26.camel@sli10-desk.sh.intel.com>
References: <1199340944.1642.26.camel@sli10-desk.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6xp9A3lq5H/S+SRV7w1x"
Date: Tue, 08 Jan 2008 09:02:35 +1100
Message-Id: <1199743355.7518.2.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6xp9A3lq5H/S+SRV7w1x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-01-03 at 14:15 +0800, Shaohua Li wrote:
> PCI Express ASPM defines a protocol for PCI Express components in the D0
> state to reduce Link power by placing their Links into a low power state
> and instructing the other end of the Link to do likewise. This
> capability allows hardware-autonomous, dynamic Link power reduction
> beyond what is achievable by software-only controlled power management.
> However, The device should be configured by software appropriately.
> Enabling ASPM will save power, but will introduce device latency.
>=20
> This patch adds ASPM support in Linux. It introduces a global policy for
> ASPM, a sysfs file /sys/module/pcie_aspm/parameters/policy can control
> it. The interface can be used as a boot option too. Currently we have
> below setting:
> 	-default, BIOS default setting
> 	-powersave, highest power saving mode, enable all available ASPM state
> and clock power management
> 	-performance, highest performance, disable ASPM and clock power
> management
> By default, the 'default' policy is used currently.
>=20
> In my test, power difference between powersave mode and performance mode
> is about 1.3w in a system with 3 PCIE links.
>=20
> please review, any comments will be appreciated.
>=20
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Minor nit, but you do a lot of these:

+	return ((struct link_state *)pdev->link_state)->bios_aspm_state;
+	return ((struct link_state *)pdev->link_state)->bios_clk_state;
+	((struct link_state*)pdev->link_state)->clk_pm_enabled =3D !!enable;
+	((struct link_state*)pdev->link_state)->clk_pm_capable =3D capable;
+	((struct link_state*)pdev->link_state)->clk_pm_enabled =3D enabled;
+	((struct link_state*)pdev->link_state)->bios_clk_state =3D enabled;
+	((struct link_state *)pdev->link_state)->enabled_state =3D state;
+	if (((struct link_state *)pdev->link_state)->support_state =3D=3D 0)
+	if (((struct link_state *)pdev->link_state)->enabled_state =3D=3D state)
+	((struct link_state *)pdev->link_state)->enabled_state);

Which is a little hard on the eye.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-6xp9A3lq5H/S+SRV7w1x
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHgqF7dSjSd0sB4dIRAjHRAJ9p3KHteA3dPt2HHs0iAvEgGJgFYgCgiFEG
ylt4LrqnDGto9uvjL9km0ww=
=4aGY
-----END PGP SIGNATURE-----

--=-6xp9A3lq5H/S+SRV7w1x--

