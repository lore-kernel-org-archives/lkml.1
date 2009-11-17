Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZKQMdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZKQMdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZKQMdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:33:46 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:53161 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZKQMdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:33:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=biuq7CBkhZsPm8ZI3OQ6+xR6HrilQTXF9Dk2pw4qmow+5x4Ta2bTkArILuZevre/tG
         4n0rSUvXYDW5YGbs+I42fp9ke3D+dIdoj3UpGZ/ZlWaXwZ6yuDoFTWFLdEbobl6HPE1H
         25CEg4iGZWZopjdJ3n/MgS4xGcZ+nT+8vZhwk=
Message-ID: <4B02982B.9070004@gmail.com>
Date: Tue, 17 Nov 2009 07:33:47 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: David Miller <davem@davemloft.net>, ghaskins@novell.com, mst@redhat.com,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
References: <4AF98A8C.9040201@novell.com> <20091114011229.GA18580@gondor.apana.org.au> <4AFE08EF.2030308@gmail.com> <20091113.190438.78469912.davem@davemloft.net> <4B016041.5030000@gmail.com> <20091117010238.GA10029@gondor.apana.org.au>
In-Reply-To: <20091117010238.GA10029@gondor.apana.org.au>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig14FCFE4AEA081A13D5F2A978"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig14FCFE4AEA081A13D5F2A978
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Herbert Xu wrote:
> On Mon, Nov 16, 2009 at 09:22:57AM -0500, Gregory Haskins wrote:
>> But really, this is somewhat orthogonal to the original problem, so le=
t
>> me see if we can bring it back on topic.  Michael stated that this pat=
ch
>> in question may be problematic because there are places in the stack
>> that can get_page() without also maintaining a reference to the shinfo=

>> object.  Evgeniy seems to say the opposite.  I am not sure who is righ=
t,
>> or if I misunderstood one or both of them.  Any thoughts?
>=20
> There are loads of places where this can happen.  Start with
> pskb_expand_head.

Indeed, I see your point.  Looks like we can potentially solve that with
an extra level of indirection.  E.g. skb->shinfo->owner, with a
ref-count+callback.  Thoughts?

Kind Regards,
-Greg



--------------enig14FCFE4AEA081A13D5F2A978
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksCmCsACgkQP5K2CMvXmqEBHACfZqq+/JO3jy6r51tAidUP8S5E
pA4AnjnBVnGhT8F4l3nYH9QiG5P6AK0L
=Pu3Q
-----END PGP SIGNATURE-----

--------------enig14FCFE4AEA081A13D5F2A978--
