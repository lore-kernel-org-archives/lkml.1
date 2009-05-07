Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbZEGTab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbZEGTab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762677AbZEGT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:29:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:52326 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762297AbZEGT3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=BK2Mxkjuf79ZWIo4fmU7frhaUNj7D1Uqa3EJIwn4jPVJOehM4/nTyQE+2CV5OM5IpQ
         8hEqH9NKjDmzOxuYZ+TYpnzTOgo1/POu6k8AGH+hN7vJ6GB0xHvCmPqrsEWW1Drns47K
         +BAW+cdw18EIb880GnwT/qXwVHF3zGFsj6RFE=
Message-ID: <4A033685.7070802@gmail.com>
Date: Thu, 07 May 2009 15:29:09 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <20090507190751.GE3036@sequoia.sous-sol.org> <4A033281.8050002@novell.com> <20090507192145.GF3036@sequoia.sous-sol.org>
In-Reply-To: <20090507192145.GF3036@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE7818B05FD44ACAA959CA00B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE7818B05FD44ACAA959CA00B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Chris Wright wrote:
> * Gregory Haskins (ghaskins@novell.com) wrote:
>  =20
>> Chris Wright wrote:
>>    =20
>>> * Avi Kivity (avi@redhat.com) wrote:
>>>      =20
>>>> Gregory Haskins wrote:
>>>>        =20
>>>>> Cool,  I will code this up and submit it.  While Im at it, Ill run =
it
>>>>> through the "nullio" ringer, too. ;)  It would be cool to see the
>>>>> pv-mmio hit that 2.07us number.  I can't think of any reason why th=
is
>>>>> will not be the case.
>>>>>      =20
>>>>>          =20
>>>> Don't - it's broken.  It will also catch device assignment mmio and =
=20
>>>> hypercall them.
>>>>        =20
>>> Not necessarily.  It just needs to be creative w/ IO_COND
>>>      =20
>> Hi Chris,
>>    Could you elaborate?  How would you know which pages to hypercall a=
nd
>> which to let PF?
>>    =20
>
> Was just thinking of some ugly mangling of the addr (I'm not entirely
> sure what would work best).
>  =20
Right, I get the part about flagging the address and then keying off
that flag in IO_COND (like we do for PIO vs MMIO).

What I am not clear on is how you would know to flag the address to
begin with.

Here's a thought: "PV" drivers can flag the IO (e.g. virtio-pci knows it
would never be a real device).  This means we route any io requests from
virtio-pci though pv_io_ops->mmio(), but not unflagged addresses.  This
is not as slick as boosting *everyones* mmio speed as Avi's original
idea would have, but it is perhaps a good tradeoff between the entirely
new namespace created by my original dynhc() proposal and leaving them
all PF based.

This way, its just like using my dynhc() proposal except the mmio-addr
is the substitute address-token (instead of the dynhc-vector).=20
Additionally, if you do not PV the kernel the IO_COND/pv_io_op is
ignored and it just slow-paths through the PF as it does today.  Dynhc()
would be dependent  on pv_ops.

Thoughts?

-Greg


--------------enigE7818B05FD44ACAA959CA00B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDNoUACgkQP5K2CMvXmqESjwCgikylBWnEx4xx1SUG1Jk4Ps8X
n/AAnjciYtATm5pxBVL0epDkcnwEafkO
=p5tz
-----END PGP SIGNATURE-----

--------------enigE7818B05FD44ACAA959CA00B--
