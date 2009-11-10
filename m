Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZKJSgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZKJSgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZKJSgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:36:25 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:40019 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZKJSgY (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Tue, 10 Nov 2009 13:36:24 -0500
Message-ID: <4AF9B2A7.3050802@novell.com>
Date: Tue, 10 Nov 2009 13:36:23 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: alacrityvm-devel@lists.sourceforge.net, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
References: <20091002141407.30224.54207.stgit@dev.haskins.net> <20091110115335.GC6989@redhat.com> <4AF919020200005A000586A9@sinclair.provo.novell.com> <20091110131722.GA19645@redhat.com> <4AF9747E.8020408@novell.com> <20091110143652.GB19645@redhat.com> <4AF98A8C.9040201@novell.com> <20091110173644.GA8888@redhat.com>
In-Reply-To: <20091110173644.GA8888@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB2B9E5A35E204B9783F24BB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB2B9E5A35E204B9783F24BB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Nov 10, 2009 at 10:45:16AM -0500, Gregory Haskins wrote:
>> I am not a stack expert, but I was under the impression that we use th=
is
>> model for userspace pages today as well using the wmem callbacks in
>> skb->destructor().  If so, I do not see how you could do something lik=
e
>> detach a page from a pskb and still expect to have a proper event that=

>> delineates the io-completion to the higher layers.
>=20
> I think linux only cares about that for accounting purposes (stuff like=

> socket sndbuff size). If someone takes over the page, the socket can
> stop worrying about it.

Only if there isn't zero-copy.

>=20
>> So the questions are:
>>
>> 1) do we in fact map userspace pages to pskbs today?
>=20
> I don't think so.

What about things like sendfile()?  There has to be *some* way to
synchronize with the io-completion event,  I would think.  Whatever that
is, I'd like to tap into it.

>>> which pages?
>>
>> You said that there are paths that get_page() out of shinfo without
>> holding a shinfo reference.
>=20
> Without zero copy, application does not care about these,
> they have been allocated by kernel.

Agreed in the non-zero copy case.  I am not yet convinced that we do not
do zero copy in some form, however. Ill have to dig through the code
when I get a chance to confirm.

Kind Regards,
-Greg




--------------enigEB2B9E5A35E204B9783F24BB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkr5sqcACgkQP5K2CMvXmqF2XQCdF7LXp6idmL9vL8hnzJkuDM3u
q2UAn3nAnI5fvwUIETPuDXljmYCip8rZ
=VUGd
-----END PGP SIGNATURE-----

--------------enigEB2B9E5A35E204B9783F24BB--
