Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbZHQL1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbZHQL1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZHQL1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:27:40 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:24116 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720AbZHQL1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UwD0cI9lF2kgBx6EirtO5kf/iB9GDxZKZN0SQJ5+C9S92O/KcR5sn77SzM5jKFGsD+
         N46eoTLi3nxi1akKFaYMHf4rGeg3JXkrQ3HP2ts5T8oLgtc+CpnoDQogTi+pAJtDzSNK
         tetZmhrZuhJa+6WtImjBCEDTEnUtvp6Z07Bhc=
Date: Mon, 17 Aug 2009 14:30:59 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090817113059.GA3245@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <1250498613.28336.68.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <1250498613.28336.68.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/17/09 16:43), Lin Ming wrote:
> On Thu, 2009-08-13 at 04:10 +0800, Sergey Senozhatsky wrote:
> > [    0.205668] ACPI Error (dswload-0790): [PCFG] Namespace lookup failu=
re, AE_ALREADY_EXISTS
> > [    0.205899] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/ca=
talog 20090521 psloop-227
> > [    0.206124] ACPI Error (psparse-0537): Method parse/execution failed=
 [\_SB_.RBPE] (Node f7017678), AE_ALREADY_EXISTS
> > [    0.206417] ACPI: Marking method RBPE as Serialized because of AE_AL=
READY_EXISTS error
> > [    0.206773] ACPI Error (psparse-0537): Method parse/execution failed=
 [\_SB_.PCI0.P0P4.XCRD._STA] (Node f7015648), AE_ALREADY_EXISTS
> > [    0.207070] ACPI: Marking method _STA as Serialized because of AE_AL=
READY_EXISTS error
> > [    0.207326] ACPI Error (uteval-0256): Method execution failed [\_SB_=
=2EPCI0.P0P4.XCRD._STA] (Node f7015648), AE_ALREADY_EXISTS
> > [    0.213503] ACPI Error: Could not map memory at 0000000000000000, si=
ze 0 20090521 exregion-173
> > [    0.213734] ACPI Exception: AE_NO_MEMORY, Returned by Handler for [S=
ystemMemory] 20090521 evregion-424
> > [    0.213963] ACPI Error (psparse-0537): Method parse/execution failed=
 [\_SB_.RBPE] (Node f7017678), AE_NO_MEMORY
> > [    0.214286] ACPI Error (psparse-0537): Method parse/execution failed=
 [\_GPE._L01] (Node f701d198), AE_NO_MEMORY
> > [    0.214616] ACPI Exception: AE_NO_MEMORY, while evaluating GPE metho=
d [_L01] 20090521 evgpe-568
> > [    0.216428] PCI: MCFG area at e0000000 reserved in ACPI motherboard =
resources
> > [    0.216523] PCI: updated MCFG configuration 0: base e0000000 segment=
 0 buses 0 - 63
> > [    0.216627] PCI: Using MMCONFIG for extended config space
>=20
> Hi, Sergey
>
Hi, Lin
=20
> 2. Debug kernel patch
>=20
> Currently, we exit the interpreter when setup region, because it may
> execute control methods, such as _REG.
>=20
> The attached debug kernel patch (region-debug.patch) don't exit the
> interpreter if the region is temporary, namely, it is defined inside a
> method.
>=20

rc6-git2
25 successful reboots.

I'll need some more time to test against rc5.

/*should I also test DSDT in case region-debug.patch fixed the problem?*/

	Sergey

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqJP3MACgkQfKHnntdSXjQ2/AP9EnHEEkKG4m0t3HvSvB3GHBZo
2iWnIfhoUtopCtYmH1Q59miTQOcDEvCkJ1t4+lnFpO2Z6KmtlLJGfmRd1yvqKiGR
dgjjLI1h+34fGDvoimUNArANVFMdv26BZGytQgT6x8Jp82Pa4Cwx9dn6tsvSgJX0
0AIn+1WX16VrRSEoy5M=
=f1hc
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
