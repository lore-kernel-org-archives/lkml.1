Return-Path: <linux-kernel-owner+w=401wt.eu-S1750857AbXAXJxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857AbXAXJxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 04:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbXAXJxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 04:53:06 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41202 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXAXJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 04:53:05 -0500
Message-ID: <45B72C7A.90803@bull.net>
Date: Wed, 24 Jan 2007 10:52:58 +0100
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 5/5][AIO] - Add listio syscall support
References: <20070117104601.36b2ab18@frecb000686>	<20070117105554.346324b4@frecb000686> <20070123215318.beddfdf7.akpm@osdl.org>
In-Reply-To: <20070123215318.beddfdf7.akpm@osdl.org>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 10:53:50,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 10:53:52,
	Serialize complete at 24/01/2007 10:53:52
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig15900E2BD5ECAD1A61201609"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig15900E2BD5ECAD1A61201609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> On Wed, 17 Jan 2007 10:55:54 +0100
> S=E9bastien Dugu=E9 <sebastien.dugue@bull.net> wrote:
>=20
>> +struct lio_event *lio_create(struct sigevent __user *user_event,
>> +			int mode)
>> +{
>> +	int ret =3D 0;
>> +	struct lio_event *lio =3D NULL;
>> +
>> +	if (unlikely((mode =3D=3D LIO_NOWAIT) && !user_event))
>> +		return lio;
>> +
>> +	lio =3D kzalloc(sizeof(*lio), GFP_KERNEL);
>> +
>> +	if (!lio)
>> +		return ERR_PTR(-EAGAIN);
>> +
>=20
> Why EAGAIN and not ENOMEM?

According to the POSIX AIO specifications:

"ERRORS:
=2E..
[EAGAIN]
    The resources necessary to queue all the I/O requests were not availa=
ble. "

I think memory is "a resource necessary to queue all the I/O requests"...=


http://www.opengroup.org/onlinepubs/009695399/functions/lio_listio.html

Regards,
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
       "Any sufficiently advanced technology is
  indistinguishable from magic." - Arthur C. Clarke


--------------enig15900E2BD5ECAD1A61201609
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFFtyx+9Kffa9pFVzwRAl5LAKDHXpIVnu7tPsF3QMm4e/GDR7pxcACdEx1I
MA+iUx0ilN0oL6Ays60uhE4=
=1zkU
-----END PGP SIGNATURE-----

--------------enig15900E2BD5ECAD1A61201609--
