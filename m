Return-Path: <linux-kernel-owner+w=401wt.eu-S1761840AbZEGCGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840AbZEGCGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760036AbZEGCGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:06:25 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45557 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbZEGCGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:06:25 -0400
Message-ID: <4A024214.9090002@novell.com>
Date: Wed, 06 May 2009 22:06:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: viro@ZenIV.linux.org.uk, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com> <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig50538C0C44D22172060DE6CA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig50538C0C44D22172060DE6CA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Wed, 6 May 2009, Gregory Haskins wrote:
>
>  =20
>> I think we are ok in this regard (at least in v5) without the callback=
=2E=20
>> kvm holds irqfd, which holds eventfd.  In a normal situation, we will
>> have eventfd with 2 references.  If userspace closes the eventfd, it
>> will drop 1 of the 2 eventfd file references, but the object should
>> remain intact as long as kvm still holds it as well.  When the kvm-fd =
is
>> released, we will then decouple from the eventfd->wqh and drop the las=
t
>> fput(), officially freeing it.
>>
>> Likewise, if kvm is closed before the eventfd, we will simply decouple=

>> from the wqh and fput(eventfd), leaving the last reference held by
>> userspace until it closes as well.
>>
>> Let me know if you see any holes in that.
>>    =20
>
> Looks OK, modulo my knowledge of KVM internals.
>  =20

Thanks Davide,

If there isn't any more feedback on the series from Al, Avi,
etc...please formally submit your eventfd patch so this series is
available for Avi to pull in for inclusion when/if he deems it fit.

Thanks again,
-Greg



--------------enig50538C0C44D22172060DE6CA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoCQhQACgkQlOSOBdgZUxniAgCdHxsxrl3dQvOSxyw4tsJDU+z2
O60An15yMy+yVXbv2NGmYOejiuSWTWCs
=091X
-----END PGP SIGNATURE-----

--------------enig50538C0C44D22172060DE6CA--
