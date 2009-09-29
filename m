Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZI2UK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZI2UK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZI2UK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:10:29 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:55458 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZI2UK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:10:28 -0400
Date: Tue, 29 Sep 2009 17:10:28 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
Message-ID: <20090929201027.GQ18847@vespa.holoscopio.com>
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com> <20090929130522.ecf4d5ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2lX4GznBIrto1wi"
Content-Disposition: inline
In-Reply-To: <20090929130522.ecf4d5ec.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2lX4GznBIrto1wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2009 at 01:05:22PM -0700, Andrew Morton wrote:
> On Mon, 28 Sep 2009 22:38:00 -0300
> Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
>=20
> > This add supports for devices like keyboard, backlight, tablet and
> > accelerometer.
> >=20
> > This work is supported by International Syst S/A.
> >=20
>=20
> I need to have a big whine about the coding style.
>=20
> > +static acpi_status cmpc_start_accel(acpi_handle handle)
> > +{
> > +	union acpi_object param[2];
> > +	struct acpi_object_list input;
> > +	acpi_status status;
> > +	param[0].type =3D ACPI_TYPE_INTEGER;
> > +	param[0].integer.value =3D 0x3;
> > +	param[1].type =3D ACPI_TYPE_INTEGER;
> > +	input.count =3D 2;
> > +	input.pointer =3D param;
> > +	status =3D acpi_evaluate_object(handle, "ACMD", &input, NULL);
> > +	return status;
> > +}
>=20
> To the jaded kernel developer's eye, this is quite hard to read.  Every
> function here squishes the declarations of the locals up against the
> start of the code.  It's a small thing, but this:
>=20
> static acpi_status cmpc_start_accel(acpi_handle handle)
> {
> 	union acpi_object param[2];
> 	struct acpi_object_list input;
> 	acpi_status status;
>=20
> 	param[0].type =3D ACPI_TYPE_INTEGER;
> 	param[0].integer.value =3D 0x3;
> 	param[1].type =3D ACPI_TYPE_INTEGER;
> 	input.count =3D 2;
> 	input.pointer =3D param;
> 	status =3D acpi_evaluate_object(handle, "ACMD", &input, NULL);
> 	return status;
> }
>=20
> puts a smile on our faces.
>=20

Will put this into consideration on the second version. Thanks, Andrew.

> >
> > ...
> >
> > +static ssize_t cmpc_accel_sense_store(struct device *dev,
> > +				      struct device_attribute *attr,
> > +				      const char *buf, size_t count)
> > +{
> > +	struct acpi_device *acpi;
> > +	int sense;
> > +	acpi =3D to_acpi_device(dev);
> > +	if (sscanf(buf, "%d", &sense) <=3D 0)
> > +		return -EINVAL;
> > +	cmpc_accel_set_sense(acpi->handle, sense);
> > +	return strnlen(buf, count);
> > +}
>=20
> This will treat input of the form "42foo" as a valid decimal number.=20
> That's a bit sloppy.  Can we use strict_strtoul() here?
>=20

Sure! The second version is coming soon. Thanks again.

Best regards,
Cascardo.

--s2lX4GznBIrto1wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrCabMACgkQyTpryRcqtS1GPgCZAV0uxPOAcEQWmAQJNx9mBtic
49MAn1KzulCZ4wG+erPcEkVx1DZ12xkB
=TTIQ
-----END PGP SIGNATURE-----

--s2lX4GznBIrto1wi--
