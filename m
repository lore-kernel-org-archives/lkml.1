Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbZDBKxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbZDBKxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZDBKw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:52:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42748 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZDBKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:52:58 -0400
Message-ID: <49D49986.3060303@novell.com>
Date: Thu, 02 Apr 2009 06:55:02 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com>
In-Reply-To: <49D47F11.6070400@redhat.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9EC615CCDBFFD2F0EE2BE6AE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9EC615CCDBFFD2F0EE2BE6AE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Herbert Xu wrote:
>> Avi Kivity <avi@redhat.com> wrote:
>> =20
>>> virtio is already non-kvm-specific (lguest uses it) and
>>> non-pci-specific (s390 uses it).
>>>    =20
>>
>> I think Greg's work shows that putting the backend in the kernel
>> can dramatically reduce the cost of a single guest->host transaction.
>> I'm sure the same thing would work for virtio too.
>>  =20
>
> Virtio suffers because we've had no notification of when a packet is
> actually submitted.  With the notification, the only difference should
> be in the cost of a kernel->user switch, which is nowhere nearly as
> dramatic.
>
>>> If you have a good exit mitigation scheme you can cut exits by a
>>> factor of 100; so the userspace exit costs are cut by the same
>>> factor.  If you have good copyless networking APIs you can cut the
>>> cost of copies to zero (well, to the cost of get_user_pages_fast(),
>>> but a kernel solution needs that too).
>>>    =20
>>
>> Given the choice of having to mitigate or not having the problem
>> in the first place, guess what I would prefer :)
>>  =20
>
> There is no choice.  Exiting from the guest to the kernel to userspace
> is prohibitively expensive, you can't do that on every packet.
>

Now you are making my point ;)  This is part of the cost of your
signaling path, and it directly adds to your latency time.   You can't
buffer packets here if the guest is only going to send one and wait for
a response and expect that to perform well.  And this is precisely what
drove me to look at avoiding going back to userspace in the first place.

-Greg


--------------enig9EC615CCDBFFD2F0EE2BE6AE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEUEARECAAYFAknUmYYACgkQlOSOBdgZUxmMgACeLMlND6zrunICKdEh8eYYNWT5
lWYAlRQdVZmljPb7HjZ6FFmCSDqapa4=
=mTtV
-----END PGP SIGNATURE-----

--------------enig9EC615CCDBFFD2F0EE2BE6AE--
