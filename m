Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZC1McU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZC1McU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 08:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZC1McJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 08:32:09 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:60488 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbZC1McH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 08:32:07 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-08.arcor-online.net 956462AEE3A
From: Prakash Punnoor <prakash@punnoor.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
Date: Sat, 28 Mar 2009 13:34:44 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29; KDE/4.2.1; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <49C45115.2090101@kernel.org> <20090326161001.526354ed@hobbes>
In-Reply-To: <20090326161001.526354ed@hobbes>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2706378.Nz2EWNZbBu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903281334.51490.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2706378.Nz2EWNZbBu
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Freitag 27 M=E4rz 2009 00:10:01 Jesse Barnes wrote:
> On Fri, 20 Mar 2009 19:29:41 -0700
>
> Yinghai Lu <yinghai@kernel.org> wrote:
> > Impact: fix bug
> >
> > Prakash reported that his c51-mcp51 system ondie sound card doesn't
> > work MSI but if he hack out the HT-MSI on mcp51, the MSI will work
> > well with sound card.
> >
> > this patch rework the nv_msi_ht_cap_quirk()
> > and will only try to avoid to enable ht_msi on device following that
> > root dev, and don't touch that root dev
> >
> > v3: will enable c51...
> > v4: will enable c51 kind of without leaf too.
> > v5: update to mainline
> >
> > Reported-by: Prakash Punnoor <prakash@punnoor.de>
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Applied, thanks.  Prakash if you get a chance can you try testing my
> linux-next branch (or just linux-next in general tomorrow) to make sure
> this is still ok for you?
>
> Thanks,

=46inally I am able to test the linux-next branch of pci tree after Jesse g=
ave=20
some help with git.(Is it correct that the kernel calls itself 2.6.28-rc8? =
I=20
looked into quirks.c and it seems to be correctly patched.) Unfortunately i=
t=20
doesn't seem to work for me (and I am wondering why as the old v4 version=20
seemed to work ontop of one of the 2.6.29-rc versions):

dmesg|grep HT
pci 0000:00:00.0: Found disabled HT MSI Mapping
pci 0000:00:03.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Found disabled HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Found disabled HT MSI Mapping
pci 0000:00:0f.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Found disabled HT MSI Mapping
pci 0000:00:10.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Found disabled HT MSI Mapping
pci 0000:00:10.1: Enabling HT MSI Mapping

Device 09.0 doesn't get enabled (good) but 00.0 also not (bad). Then my Int=
el=20
HDA cannot use MSI.

Regards,

Prakash


--nextPart2706378.Nz2EWNZbBu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAknOGWsACgkQxU2n/+9+t5hmFgCgvUo1Hy2y7okZAN2+z+f2cZfh
dM4An2PSPRO0j+llMY8FoKUcaQAzIieO
=tQTe
-----END PGP SIGNATURE-----

--nextPart2706378.Nz2EWNZbBu--
