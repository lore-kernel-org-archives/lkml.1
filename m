Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbXJ2VUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbXJ2VUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXJ2VUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:20:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48946 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbXJ2VUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:20:09 -0400
X-Sasl-enc: 7cTMKjQb7HhulvZaOqWBFIrr5tPsUrcOMszt3f+CP5Z5 1193692807
Message-ID: <47264E93.2040009@imap.cc>
Date: Mon, 29 Oct 2007 22:20:19 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net,
       Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <kkeil@suse.de>,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [linux-usb-devel] [PATCH 1/2] usb_gigaset: suspend support
References: <Pine.LNX.4.44L0.0710291509060.11831-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0710291509060.11831-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig45BEDA61EBDE85816BFF77E1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig45BEDA61EBDE85816BFF77E1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 29.10.2007 20:10 schrieb Alan Stern:
> On Mon, 29 Oct 2007, Tilman Schmidt wrote:
>=20
>> From: Tilman Schmidt <tilman@imap.cc>
>>
>> Add basic suspend/resume support to the usb_gigaset driver.
>=20
>> @@ -117,6 +122,11 @@ static struct usb_driver gigaset_usb_dri
>>  	.probe =3D	gigaset_probe,
>>  	.disconnect =3D	gigaset_disconnect,
>>  	.id_table =3D	gigaset_table,
>> +	.suspend =3D	gigaset_suspend,
>> +	.resume =3D	gigaset_resume,
>> +	.reset_resume =3D	gigaset_resume,
>> +	.pre_reset =3D	gigaset_suspend,
>> +	.post_reset =3D	gigaset_resume,
>>  };
>=20
> Does this really compile?  The .pre_reset and .suspend members are=20
> pointers to functions with different prototypes; I don't see how you=20
> can assign the same function to both pointers.

Oops, you're right. Yes, it does compile, but with a warning
"initialization from incompatible pointer type" which I
foolishly ignored.

I'll produce a corrected version promptly.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig45BEDA61EBDE85816BFF77E1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHJk6hMdB4Whm86/kRAh9UAJ42pW5+NVJVE3g7Ej1zEg3WUhXmCACbB/4+
eKAwKRpnw/fQWyi7D9EfevY=
=ZFlx
-----END PGP SIGNATURE-----

--------------enig45BEDA61EBDE85816BFF77E1--
