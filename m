Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbXKAURc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbXKAURc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 16:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXKAURF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 16:17:05 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57526 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755417AbXKAURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 16:17:01 -0400
X-Sasl-enc: OdnHI4hMrVsUvR4hRXdElCN2xABfE2fLPE1qYQ5m70GK 1193948219
Message-ID: <472A3452.9060003@imap.cc>
Date: Thu, 01 Nov 2007 21:17:22 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Hansjoerg Lipp <hjlipp@web.de>,
       Karsten Keil <kkeil@suse.de>, i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [linux-usb-devel] [PATCH 1/2] usb_gigaset: suspend support
References: <20071029185311.4C955FC04C@xenon.ts.pxnet.com> <200710300952.44232.oliver@neukum.org>
In-Reply-To: <200710300952.44232.oliver@neukum.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE42CC1EA230A965F2B02BCFB"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE42CC1EA230A965F2B02BCFB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 30.10.2007 09:52 schrieb Oliver Neukum:
> Am Montag 29 Oktober 2007 schrieb Tilman Schmidt:

>> --- a/drivers/isdn/gigaset/usb-gigaset.c	2007-10-23 01:48:12.000000000=
 +0200
>> +++ b/drivers/isdn/gigaset/usb-gigaset.c	2007-10-24 00:47:32.000000000=
 +0200
>> @@ -847,6 +859,63 @@ static void gigaset_disconnect(struct us
>>  	gigaset_unassign(cs);
>>  }
>> =20
>> +/* gigaset_suspend
>> + * This function is called before the USB connection is suspended or =
reset.
>> + */
>> +static int gigaset_suspend(struct usb_interface *intf, pm_message_t m=
essage)
>> +{
>> +	struct cardstate *cs;
>> +	struct usb_cardstate *ucs;
>> +	int rc;
>> +
>> +	if ((cs =3D usb_get_intfdata(intf)) =3D=3D NULL ||
>> +	    (ucs =3D cs->hw.usb) =3D=3D NULL) {
>> +		err("%s: no cardstate", __func__);
>> +		return -EFAULT;
>> +	}
>> +
>> +	//FIXME stop common module activities? ISDN_STAT_STOP? block open()?=

>> +
>> +	/* stop submitting bulk URBs */
>> +	tasklet_disable(&cs->write_tasklet);
>> +
>> +	/* kill pending read URB */
>> +	usb_kill_urb(ucs->read_urb);
>=20
> no pending write URB?

There shouldn't be. A read URB is always posted in case the device
sends anything, even while the device is idle, but a write URB is
only submitted if there's actual activity. But you're right, it's
safer to add a "usb_kill_urb(ucs->bulk_out_urb);" here just in case.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigE42CC1EA230A965F2B02BCFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHKjRZMdB4Whm86/kRAk6DAJkBAY32HDtFmi6Oq6o/OgFL8k+ccgCfbtYp
qe1mmrWX6BjqSDDCaMHCESQ=
=ssKX
-----END PGP SIGNATURE-----

--------------enigE42CC1EA230A965F2B02BCFB--
