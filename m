Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZFYNTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZFYNTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZFYNTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:19:38 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36785 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZFYNTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:19:37 -0400
Message-ID: <4A43795D.1080501@novell.com>
Date: Thu, 25 Jun 2009 09:19:25 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
References: <20090623150008.GA21059@redhat.com> <4A4184C3.6060503@novell.com> <20090624084901.GB22865@redhat.com> <20090625110812.GA6487@redhat.com> <4A435F28.3000301@novell.com> <20090625115403.GA7079@redhat.com> <4A4368A4.8030401@novell.com> <20090625123757.GA7121@redhat.com> <4A437564.6060308@novell.com> <20090625131633.GA7221@redhat.com>
In-Reply-To: <20090625131633.GA7221@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3E9AC9D57ACF7783ECDD3563"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3E9AC9D57ACF7783ECDD3563
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 25, 2009 at 09:02:28AM -0400, Gregory Haskins wrote:
>  =20
>>> Here's what I have in mind:
>>> kvm does
>>> 	lock
>>> 	dev =3D find
>>> 	unlock
>>>
>>> 	<---------- at this point group device is removed
>>>
>>> 	write access to device that has been removed
>>>
>>>
>>>  =20
>>>      =20
>> Hmm...you are right.  This looks like it was introduced with that rece=
nt
>> locking patch you cited.  Well, I can still fix it now easily by putti=
ng
>> an rcu-read-lock around the access.  Longer term we should move to
>> srcu.  Thoughts?
>>
>> -Greg
>>
>>    =20
>
>
> Some callbacks take kvm mutex lock. So it seems rcu won't work,
> we need srcu.
>
>  =20

Indeed.  I will put something together.

We should consider merging the io_bus cleanup I have for deregister
support ASAP as well.

-Greg


--------------enig3E9AC9D57ACF7783ECDD3563
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpDeV0ACgkQlOSOBdgZUxl8vQCfataqWJS2pHo62psffad0vmQM
6NQAn0+9fnfmgBylO9nPfbwFWXsfkOEQ
=Lta8
-----END PGP SIGNATURE-----

--------------enig3E9AC9D57ACF7783ECDD3563--
