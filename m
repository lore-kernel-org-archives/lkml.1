Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbZFWLl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbZFWLl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZFWLlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:41:21 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39525 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZFWLlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:41:20 -0400
Message-ID: <4A40BF58.8060603@novell.com>
Date: Tue, 23 Jun 2009 07:41:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A40A5D5.4080208@redhat.com>
In-Reply-To: <4A40A5D5.4080208@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig06CC18C3DA4B8CBFB0FBFD8B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig06CC18C3DA4B8CBFB0FBFD8B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 06/22/2009 07:08 PM, Michael S. Tsirkin wrote:
>> On Mon, Jun 22, 2009 at 11:45:00AM -0400, Gregory Haskins wrote:
>>  =20
>>> Michael S. Tsirkin wrote:
>>>    =20
>>>> It seems that a lot of complexity and trickiness with iosignalfd is
>>>> handling the group/item relationship, which comes about because kvm
>>>> does
>>>> not currently let a device on the bus claim a write transaction
>>>> based on the
>>>> value written.  This could be greatly simplified if the value writte=
n
>>>> was passed to the in_range check for write operation.  We could then=

>>>> simply make each kvm_iosignalfd a device on the bus.
>>>>
>>>> What does everyone think of the following lightly tested patch?
>>>>
>>>>       =20
>>> Hi Michael,
>>>    Its interesting, but I am not convinced its necessary.  We
>>> created the
>>> group/item layout because iosignalfds are unique in that they are
>>> probably the only IO device that wants to do some kind of address
>>> aliasing.
>>>     =20
>>
>> We actually already have aliasing: is_write flag is used for this
>> purpose. Actually, it's possible to remove is_write by passing
>> a null pointer in write_val for reads. I like this a bit less as
>> the code generated is less compact ... Avi, what do you think?
>>   =20
>
> Greg, won't Michael's patch eliminate a big chunk from your iosignalfd
> patches?  Seems like a win to me.

Well, it really just moves that hunk from eventfd.c to kvm_main.c, where
I don't think anyone else will use it by iosignalfd.  But if that is
what everyone wants, I guess I have no choice.

>
>> One is enough :)
>> Seriously, do you see that this saves you all of RCU, linked lists and=

>> counters? You don't need to keep track of iofds, you don't need to
>> implement your own lookup logic - you just use the kvm device
>> and that's it.
>>
>>   =20
>
> Yup.
>



--------------enig06CC18C3DA4B8CBFB0FBFD8B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpAv1gACgkQlOSOBdgZUxnk6wCdGNnFMoVlUYKRubYwxwgtndKy
IIUAn3/R1yvq9LSPEx6OuRHj8QP07dF2
=Fxai
-----END PGP SIGNATURE-----

--------------enig06CC18C3DA4B8CBFB0FBFD8B--
