Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbXAVS0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbXAVS0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 13:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932221AbXAVS0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 13:26:05 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41757 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932219AbXAVS0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 13:26:04 -0500
X-Sasl-enc: j52KAUYjINh6UNfTTrXywyxfxO70hkkJVOq8CW5ebIwX 1169490361
Message-ID: <45B502CE.1040500@imap.cc>
Date: Mon, 22 Jan 2007 19:30:38 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>
Subject: Re: i810fb fails to load
References: <20070111222627.66bb75ab.akpm@osdl.org>	<45AAC244.8060607@imap.cc> <20070114162235.4c8d241f.akpm@osdl.org> <45B4BF50.9010105@tungstengraphics.com>
In-Reply-To: <45B4BF50.9010105@tungstengraphics.com>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF5C69C2B78136CD764C050A5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF5C69C2B78136CD764C050A5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 22.01.2007 14:42 schrieb Thomas Hellstr=F6m:
>>> On Mon, 15 Jan 2007 00:52:36 +0100 Tilman Schmidt <tilman@imap.cc> wr=
ote:
>>> With kernel 2.6.20-rc4-mm1 and all hotfixes, i810fb fails to load on =
my
>>> Dell Optiplex GX110. [...]
>>  =20
> Can you try the attached patch to see if that fixes the problem.

Yes, that patch fixes it.

Thanks
Tilman

> -----------------------------------------------------------------------=
-
>=20
> diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
> index 91c1f36..6ef0960 100644
> --- a/drivers/char/agp/generic.c
> +++ b/drivers/char/agp/generic.c
> @@ -190,6 +190,7 @@ struct agp_memory *agp_create_memory(int
>  		return NULL;
>  	}
>  	new->num_scratch_pages =3D scratch_pages;
> +	new->type =3D AGP_NORMAL_MEMORY;
>  	return new;
>  }
>  EXPORT_SYMBOL(agp_create_memory);
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.=
c
> index b8896c8..5a0713c 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -260,6 +260,7 @@ static int intel_i810_insert_entries(str
>  		readl(intel_i810_private.registers+I810_PTE_BASE+((i-1)*4));
>  		break;
>  	case AGP_PHYS_MEMORY:
> +	case AGP_NORMAL_MEMORY:
>  		if (!mem->is_flushed)
>  			global_cache_flush();
>  		for (i =3D 0, j =3D pg_start; i < mem->page_count; i++, j++) {

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigF5C69C2B78136CD764C050A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFtQLPMdB4Whm86/kRAmPEAJ4pQCV1vtBQTHCUUFXHrPlakUJaVACfSTE2
7n0NMkd5q0AKx361gERgB0k=
=xAy5
-----END PGP SIGNATURE-----

--------------enigF5C69C2B78136CD764C050A5--
