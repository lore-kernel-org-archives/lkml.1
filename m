Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbZHRH5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbZHRH5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZHRH5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:57:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:1458 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZHRH5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q9CclX4rnGsF5YNe/Oww33UYC+kpMMjo6l3dEE8+ITVUb/waz0tsCeFJ2Zu/p+cgJg
         DABv98yWX/lylzkHwKpbHLEAvWEtynjlmUW0y8XlH145FVbvXiRG8V55g8S7pQ1U5Gaw
         M8a+mdHgYOs8rEfQ5RwQAKrF4PbK9GtkGuZRo=
Date: Tue, 18 Aug 2009 11:00:24 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090818080024.GA3164@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <1250498613.28336.68.camel@minggr.sh.intel.com>
 <20090817113059.GA3245@localdomain.by>
 <d3f22a0908170622x7dd9ce73m5c3ea86406cc9935@mail.gmail.com>
 <20090818071359.GA3713@localdomain.by>
 <1250579915.13743.8.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <1250579915.13743.8.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/18/09 15:18), Lin Ming wrote:
> On Tue, 2009-08-18 at 15:13 +0800, Sergey Senozhatsky wrote:
> > On (08/17/09 21:22), Lin Ming wrote:
> > > > rc6-git2
> > > > 25 successful reboots.
> > > >
> > > > I'll need some more time to test against rc5.
> > > >
> > > > /*should I also test DSDT in case region-debug.patch fixed the prob=
lem?*/
> > >=20
> > > Yes, please also help to test the custome DSDT.
> > > region-debug.patch is just a debug patch.
> > > We need to root cause the problem clearly and then work out a clean s=
olution.
> > >=20
> >=20
> > Hi, Lin
> > Looks like DSDT didn't solve the problem (oops on 4th reboot).
> >=20
> > So:
> > region-debug.patch	+
> > DSDT			-
> >=20
> > /* Is that possible? */
>=20
> Yes, that is possible.=20
> The same aml method is re-entered when interpreter lock is released.
> So you still see AE_ALREADY_EXISTS error with the custom DSDT, right?
>=20

No, here it is:
[    0.000000] ACPI: Override [DSDT-F3J00001], this is unsafe: tainting ker=
nel

Problem with AE_ALREADY_EXISTS is that that is quite rare.
I'll continue watching.

At the moment:
[    0.165424] ACPI: EC: Look up EC in DSDT
[    0.181759] ACPI: Interpreter enabled
[    0.181780] ACPI: (supports S0 S1 S3 S4 S5)
[    0.181831] ACPI: Using IOAPIC for interrupt routing
[    0.182022] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.193803] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    0.193822] PCI: updated MCFG configuration 0: base e0000000 segment 0 b=
uses 0 - 63
[    0.193840] PCI: Using MMCONFIG for extended config space
[    0.203749] ACPI: EC: GPE =3D 0x1c, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.203766] ACPI: EC: driver started in poll mode
[    0.206839] ACPI: No dock devices found.
[    0.207026] ACPI: PCI Root Bridge [PCI0] (0000:00)


	Sergey
--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqKX5gACgkQfKHnntdSXjTalgQAj6x9XzVHFLY1W3So5h28pHwr
8TChYA3LpkuI0g+WucKBy8Sun/qxP42eDXeKXQp8P4/qhHBmkXdwtX9Ro48DtzZa
Yqze7TPt3lBZEorwjRABYjjfRAxm27sm7jl5q9/XMWzEFVrUJa043I4P6TA1yI2+
+422x+M2bEx5K70ISVA=
=CSsR
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
