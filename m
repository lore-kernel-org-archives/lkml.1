Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbZCSUxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbZCSUxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbZCSUxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:53:17 -0400
Received: from b01.ext.isohunt.com ([208.71.112.51]:59019 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761288AbZCSUxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:53:16 -0400
Date: Thu, 19 Mar 2009 13:18:05 -0700
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: Re: rmmod/delete_module hangs forever
Message-ID: <20090319201805.GH3795@curie-int>
References: <20090314213947.GA9084@curie-int>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Content-Disposition: inline
In-Reply-To: <20090314213947.GA9084@curie-int>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 14, 2009 at 02:39:47PM -0700, Robin H. Johnson wrote:
> Strace gives me this fun in the end:
> delete_module("button", O_RDONLY|O_EXCL|O_NONBLOCK
> and it just sits there.
Ok, after much head-scratching and bisect-powered reboots I have
disproved for myself that this is a kernel issue.

Instead it's some weird interaction between certain BIOS settings on my
motherboard (ASUS P5Q Premium) and my SCSI controller (HP SC11Xe,
FusionMPT based) I use for tape specifically when there are no SCSI
devices on the bus. Skipping the mptspi module, or connecting a SCSI
device causes the problem to go away, ditto changing some settings in
the BIOS that cause IRQs to be allocated differently.

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Infra Guy
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAknCqH0ACgkQPpIsIjIzwizDGACgqoKE4ia3VWR/Q87CNbpaaIh1
6sAAniDaT5C7KUWQK64FcXJXfwCd3EI+
=/jAR
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--
