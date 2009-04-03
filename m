Return-Path: <linux-kernel-owner+w=401wt.eu-S1763620AbZDCL1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763620AbZDCL1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761725AbZDCL0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:26:52 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50813 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbZDCL0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:26:51 -0400
Message-ID: <49D5F2FA.9040107@novell.com>
Date: Fri, 03 Apr 2009 07:28:58 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <49D5EBE1.8030200@redhat.com>
In-Reply-To: <49D5EBE1.8030200@redhat.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3648B391CE68DF47139AF7E9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3648B391CE68DF47139AF7E9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gerd Hoffmann wrote:
> Avi Kivity wrote:
>  =20
>> There is no choice.  Exiting from the guest to the kernel to userspace=

>> is prohibitively expensive, you can't do that on every packet.
>>    =20
>
> I didn't look at virtio-net very closely yet.  I wonder why the
> notification is that a big issue though.  It is easy to keep the number=

> of notifications low without increasing latency:
>
> Check shared ring status when stuffing a request.  If there are request=
s
> not (yet) consumed by the other end there is no need to send a
> notification.  That scheme can even span multiple rings (nics with rx
> and tx for example).
>  =20

FWIW: I employ this scheme.  The shm-signal construct has a "dirty" and
"pending" flag (all on the same cacheline, which may or may not address
Andi's later point).  The first time you dirty the shm, it sets both
flags.  The consumer side has to clear "pending" before any subsequent
signals are sent.  Normally the consumer side will also clear "enabled"
(as part of the bidir napi thing) to further disable signals.

-Greg




--------------enig3648B391CE68DF47139AF7E9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknV8voACgkQlOSOBdgZUxkKHwCeNvxwcuTz9HTrbrUTS4gWQa9P
nHQAn2/rDyJr/HRmdxYJC9url+izu/lI
=gaNi
-----END PGP SIGNATURE-----

--------------enig3648B391CE68DF47139AF7E9--
