Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658Ab0AGTHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab0AGTHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546Ab0AGTHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:07:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:45141 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0AGTG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=eMQzlEfvepvuuxuNSwi96/Y0Tkh1OJxixuJHl88nOo06HYVUb4XmdetP/A9ArO8g5g
         QDzJAEG/NHXavA9L5m8BZD9XjIhdq4BkteJSreYDCCFgdbpzpzIxE5MS1Qu0/irMgoBp
         /mamjIw3ZR40CbbH3HSid59WNyhgiu0OKdNLc=
Message-ID: <4B4630C0.6090206@gmail.com>
Date: Thu, 07 Jan 2010 20:06:40 +0100
From: Daniel Borkmann <danborkmann@googlemail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mpm@selenic.com, danborkmann@googlemail.com, linux-kernel@vger.kernel.org,
       jmoyer@redhat.com, netdev@vger.kernel.org, netdev@oss.sgi.com
Subject: Re: [PATCH] netpoll: allow execution of multiple rx_hooks per interface
References: <4B44F895.9080205@gmail.com>	<1262836445.29868.227.camel@calx> <20100107.010201.51693251.davem@davemloft.net>
In-Reply-To: <20100107.010201.51693251.davem@davemloft.net>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB6AA20E24023CD39C718DB07"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB6AA20E24023CD39C718DB07
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

David Miller wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Wed, 06 Jan 2010 21:54:05 -0600
>=20
>> Please inline patches so they can be reviewed easily in reply.
>>
>>
>> -       struct netpoll *np =3D npi->rx_np;
>> +       struct netpoll **np =3D &npi->rx_np;
>> =20
>> -       if (!np)
>> +       if (!(*np))
>>
>> This makes everything horrible. Can you avoid the double indirection?
>> Using a list head might be a good answer.
>>
>=20
> Agreed on all counts.
>=20

Agreed on the double indirection, I'll fix it.

I've already considered the list_head structure, but then I was the opini=
on
that a double linked list might not be necessary for this, so I did it th=
at
way ... (compare: kernel notifier by Alan Cox). If you insist on that I'l=
l
fix it of course ;)

Best regards,
Daniel

P.s.: Sorry Matt for not CCing. I mainly took those addresses from Jeffs =
post.


--------------enigB6AA20E24023CD39C718DB07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAktGMMAACgkQ5AxJm1m3CC8G2ACdFsW7iqKqdCfc9q5Dc0Q+BPfA
IB0AoI+6DPWww3DX8LRfWeOV4vm7es85
=QDrK
-----END PGP SIGNATURE-----

--------------enigB6AA20E24023CD39C718DB07--
