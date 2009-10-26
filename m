Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZJZX7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZJZX7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZJZX7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:59:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35052 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755140AbZJZX7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:59:31 -0400
X-Sasl-enc: bLGq+kgXVsfWYKjdpC+Wct3mvsptk5QP2AQzaD+F82r5 1256601575
Message-ID: <4AE637D8.60809@imap.cc>
Date: Tue, 27 Oct 2009 00:59:20 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>,
       Hansjoerg Lipp <hjlipp@web.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 6/9] ser_gigaset: checkpatch cleanup
References: <20091023-patch-gigaset-00.tilman@imap.cc>	 <20091023-patch-gigaset-06.tilman@imap.cc> <1256518486.14711.13.camel@Joe-Laptop.home>
In-Reply-To: <1256518486.14711.13.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC7318A2EB132C5AF41629AE4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC7318A2EB132C5AF41629AE4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 26.10.2009 01:54 schrieb Joe Perches:
> On Sun, 2009-10-25 at 20:30 +0100, Tilman Schmidt wrote:
>> Duly uglified as demanded by checkpatch.pl.
>> diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset=
/ser-gigaset.c
>> index 3071a52..ac3409e 100644
>> --- a/drivers/isdn/gigaset/ser-gigaset.c
>> +++ b/drivers/isdn/gigaset/ser-gigaset.c
>> @@ -164,9 +164,15 @@ static void gigaset_modem_fill(unsigned long data=
)
>>  {
>>  	struct cardstate *cs =3D (struct cardstate *) data;
>>  	struct bc_state *bcs;
>> +	struct sk_buff *nextskb;
>>  	int sent =3D 0;
>> =20
>> -	if (!cs || !(bcs =3D cs->bcs)) {
>> +	if (!cs) {
>> +		gig_dbg(DEBUG_OUTPUT, "%s: no cardstate", __func__);
>> +		return;
>> +	}
>> +	bcs =3D cs->bcs;
>> +	if (!bcs) {
>>  		gig_dbg(DEBUG_OUTPUT, "%s: no cardstate", __func__);
>>  		return;
>> 	}
>=20
> perhaps:
> 	if (!cs || !cs->bcs) {
> 		gig_dbg(DEBUG_OUTPUT, "%s: no cardstate", __func__);
> 		return;
> 	}
> 	bcs =3D cs->bcs;

That would evaluate cs->bcs twice, and is also, in my experience,
significantly more prone to easily overlooked typos which result in
checking a different pointer in the if statement than the one that's
actually used in the subsequent assignment.

>> @@ -404,16 +412,20 @@ static void gigaset_device_release(struct device=
 *dev)
>>  static int gigaset_initcshw(struct cardstate *cs)
>>  {
>>  	int rc;
>> +	struct ser_cardstate *scs;
>> =20
>> -	if (!(cs->hw.ser =3D kzalloc(sizeof(struct ser_cardstate), GFP_KERNE=
L))) {
>> +	scs =3D kzalloc(sizeof(struct ser_cardstate), GFP_KERNEL);
>> +	if (!scs) {
>>  		pr_err("out of memory\n");
>>  		return 0;
>>  	}
>> +	cs->hw.ser =3D scs;
>=20
> Why not no temporary and just:
>=20
> 	cs->hw.ser =3D kzalloc...
> 	if (!cs->hw.ser)

For the same reasons as above.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enigC7318A2EB132C5AF41629AE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK5jfjQ3+did9BuFsRAjmMAJ9ORjJbExperJA9ziAKm8VXgYPcBwCglL4T
qfHgmwL9a/LZMkq5xZK0+eY=
=MDz5
-----END PGP SIGNATURE-----

--------------enigC7318A2EB132C5AF41629AE4--
