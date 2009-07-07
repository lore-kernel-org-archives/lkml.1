Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbZGGNbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbZGGNbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbZGGNar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:30:47 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38185 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148AbZGGNap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:30:45 -0400
Message-ID: <4A534DFE.8000205@novell.com>
Date: Tue, 07 Jul 2009 09:30:38 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A53372E.6090509@redhat.com> <20090707122250.GC3647@redhat.com> <4A533F45.90609@redhat.com> <20090707125148.GE3647@redhat.com> <4A53460B.8090401@novell.com> <20090707132136.GB7578@redhat.com>
In-Reply-To: <20090707132136.GB7578@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD6597BEAD969F6842F03849E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD6597BEAD969F6842F03849E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jul 07, 2009 at 08:56:43AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Tue, Jul 07, 2009 at 03:27:49PM +0300, Avi Kivity wrote:
>>>  =20
>>>      =20
>>>> On 07/07/2009 03:22 PM, Michael S. Tsirkin wrote:
>>>>    =20
>>>>        =20
>>>>> On Tue, Jul 07, 2009 at 02:53:18PM +0300, Avi Kivity wrote:
>>>>>   =20
>>>>>      =20
>>>>>          =20
>>>>>>>> +		/* address-range must be precise for a hit */
>>>>>>>>
>>>>>>>>         =20
>>>>>>>>            =20
>>>>>>>>                =20
>>>>>>> So there's apparently no way to specify that
>>>>>>> you want 1,2, or 4 byte writes at address X?
>>>>>>>
>>>>>>>       =20
>>>>>>>          =20
>>>>>>>              =20
>>>>>> Why would you want that?
>>>>>>     =20
>>>>>>        =20
>>>>>>            =20
>>>>> Donnu. Why would anyone want to catch 8 byte writes at all?
>>>>>   =20
>>>>>      =20
>>>>>          =20
>>>> One of the natural write sizes.
>>>>
>>>>    =20
>>>>        =20
>>>>> Seriously, why add artificial limitations?
>>>>> IMO, addr=3D0,len=3D1 and addr=3D0,len=3D2 should not conflict.
>>>>>
>>>>>   =20
>>>>>      =20
>>>>>          =20
>>>> They should not conflict, but a two byte write need not hit a one by=
te =20
>>>> registration.
>>>>    =20
>>>>        =20
>>> Yes. That's exactly what I'm saying. I think it should be possible to=

>>> create 2 fds:
>>>
>>> addr =3D 0
>>> len =3D 1
>>> addr =3D 0
>>> len =3D 2
>>> and at most one will ever trigger.
>>>
>>> But current code will not let you create the second one.
>>>
>>>  =20
>>>      =20
>> Note that this was by design to keep the code simple since we don't ha=
ve
>> a (known) use case for overlap.  At the very least, you have to addres=
s
>> how data subsets are handled.  But do we really need that functionalit=
y?
>>
>> -Greg
>>
>>    =20
>
> Hey, forget about overlap. Overlap does not exist as a concept.  You no=
w
> spend a lot of effort to detect it. Kill all that code, and just do
> this on assignment:
>
> list_for_each(...)
> 	if (rhs->add =3D=3D lhs->addr && rhs->len =3D=3D lhs->len &&
> 	    (rhs->wildcard || lhs->wildcard || rhs->data =3D=3D lhs->data))
> 		return -EEXIST;
>
>  =20
I like it.  Will do for v10.

Thanks Michael,
-Greg


--------------enigD6597BEAD969F6842F03849E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpTTf4ACgkQlOSOBdgZUxn17ACfdQgv+PV06y0JuirzK2mexdfV
UeQAnAs8IExg3jKUyOTIa+LIQyBSeEeg
=EZ6Z
-----END PGP SIGNATURE-----

--------------enigD6597BEAD969F6842F03849E--
