Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYKYXG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYKYXG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYKYXGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:06:17 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:8441 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbYKYXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:06:16 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stable Kernel <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Daniel =?ISO-8859-1?Q?Schr=F6der?= <mail@dschroeder.info>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <492C6D8D.3040600@goop.org>
References: <492C6D8D.3040600@goop.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WUETlNST/7pHafnP81fT"
Date: Tue, 25 Nov 2008 23:06:04 +0000
Message-Id: <1227654364.27529.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Change 5c371b31be3203 in stable breaks Xen
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=ZoTF2kc00DsA:10 a=4hNQKufdvHsA:10 a=-iBCxecDcbXoD0AhjgIA:9 a=uKNhkpDQSXKMFsBScXLCZaa791cA:4 a=M5KUBopVHV4A:10 a=MSl-tDqOz04A:10 a=6O0IECtVFhoA:10 a=LY0hPdMaydYA:10 a=FMqOlKt45ESqddCpvHsA:9 a=AeDLoNsQZDUQ--koXouns71wWfEA:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WUETlNST/7pHafnP81fT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-25 at 13:26 -0800, Jeremy Fitzhardinge wrote:
> I have a report of Xen breaking between 2.6.27.5 and .6.  I bisected
> it=20
> down to change:
>=20
> commit 5c371b31be32033b0a4a993431484da8a2305369
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Mon Sep 22 02:52:26 2008 -0700
>=20
>     x86: fix CONFIG_X86_RESERVE_LOW_64K=3Dy
>   =20
>     commit 2216d199b1430d1c0affb1498a9ebdbd9c0de439 upstream

Looks like 5dc64a3442b98eaa0e3730c35fcf00cf962a93e7 might be needed in
stable too?
       =20
        commit 5dc64a3442b98eaa0e3730c35fcf00cf962a93e7
        Author: Ian Campbell <Ian.Campbell@citrix.com>
        Date:   Fri Oct 10 11:27:38 2008 +0100
       =20
            xen: do not reserve 2 pages of padding between hypervisor and f=
ixmap.
           =20
            When reserving space for the hypervisor the Xen paravirt backen=
d adds
            an extra two pages (this was carried forward from the 2.6.18-xe=
n tree
            which had them "for safety"). Depending on various CONFIG optio=
ns this
            can cause the boot time fixmaps to span multiple PMDs which is =
not
            supported and triggers a WARN in early_ioremap_init().
           =20
            This was exposed by 2216d199b1430d1c0affb1498a9ebdbd9c0de439 wh=
ich
            moved the dmi table parsing earlier.
                x86: fix CONFIG_X86_RESERVE_LOW_64K=3Dy
           =20
                The bad_bios_dmi_table() quirk never triggered because we d=
o DMI setup
                too late. Move it a bit earlier.
           =20
            There is no real reason to reserve these two extra pages and th=
e
            fixmap already incorporates FIX_HOLE which serves the same
            purpose. None of the other callers of reserve_top_address do th=
is.


--=20
Ian Campbell

Moonchild without an opinion? Satan is skating to work tomorrow!
		-- Brett Manz

--=-WUETlNST/7pHafnP81fT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkshNwACgkQM0+0qS9rzVl4yQCgn+in+Of6lW82Y5evo4g67ttu
TXMAniwUUQIXs0rdkDG0wvMoaPqE4vGC
=evWl
-----END PGP SIGNATURE-----

--=-WUETlNST/7pHafnP81fT--

