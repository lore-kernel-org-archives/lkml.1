Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZJ1NUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZJ1NUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZJ1NT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:19:59 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:48643 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZJ1NT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=r5xeGirdWQTdL95/9matXH0sh3y8SIfaIaVBQsmsNwT3Ks04ShJ0c68ixCqhzT9c+5
         0royYeZlZPddTWAsAOQVYrXK48Ca5UCgYOgqRGA9JI7SkGos/Yv1Y00bdIp/hSjBFfQ6
         t2J/MUfNkgqqerPOA6/mgr6gPe/KmYGMk1vQ0=
Message-ID: <4AE844FA.4070408@gmail.com>
Date: Wed, 28 Oct 2009 09:19:54 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [Alacrityvm-devel] [KVM PATCH v2 1/2] KVM: export lockless GSI
 attribute
References: <20091023023512.3891.65889.stgit@dev.haskins.net>	<20091023023845.3891.36857.stgit@dev.haskins.net> <4AE460F4.2090905@redhat.com> <4AE5A336.4010801@gmail.com> <4AE5C26A.9000400@gmail.com> <4AE81710.1080103@redhat.com>
In-Reply-To: <4AE81710.1080103@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBCCB9C62ECE66C2D1977AE6D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBCCB9C62ECE66C2D1977AE6D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/26/2009 05:38 PM, Gregory Haskins wrote:
>>>> Instead of a lockless attribute, how about a ->set_atomic() method. =

>>>> For
>>>> msi this can be the same as ->set(), for non-msi it can be a functio=
n
>>>> that schedules the work (which will eventually call ->set()).
>>>>
>>>> The benefit is that we make a decision only once, when preparing the=

>>>> routing entry, and install that decision in the routing entry
>>>> instead of
>>>> making it again and again later.
>>>>       =20
>>> Yeah, I like this idea.  I think we can also get rid of the custom
>>> workqueue if we do this as well, TBD.
>>>     =20
>> So I looked into this.  It isn't straight forward because you need to
>> retain some kind of state across the deferment on a per-request basis
>> (not per-GSI).  Today, this state is neatly tracked into the irqfd
>> object itself (e.g. it knows to toggle the GSI).
>>   =20
>=20
> Yes, and it also contains the work_struct.
>=20
> What if we make the work_struct (and any additional state) part of the
> set_atomic() argument list?  Does it simplify things?

Hmmm, that might not, but we could do a kmalloc(GFP_ATOMIC) for such
parameters.  Considering this is just a safety net, perhaps this would
work fine.

>=20
>> So while generalizing this perhaps makes sense at some point, especial=
ly
>> if irqfd-like interfaces get added, it probably doesn't make a ton of
>> sense to expend energy on it ATM.  It is basically a generalization of=

>> the irqfd deferrment code.  Lets just wait until we have a user beyond=

>> irqfd for now.  Sound acceptable?
>>   =20
>=20
> I'll look at v3, but would really like to disentangle this.

Ok, I will see what I can do.  I need at least a v4 to get rid of the
dependency on the now defunct v3:1/3 patch per yesterdays discussion.

Kind Regards,
-Greg


--------------enigBCCB9C62ECE66C2D1977AE6D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkroRPoACgkQP5K2CMvXmqESvgCeKDKCD2U0IkxPzb4TWlm3ov8J
sDYAn3OV5rbvGQ6oV0QmV20SbeOYfDp6
=FG05
-----END PGP SIGNATURE-----

--------------enigBCCB9C62ECE66C2D1977AE6D--
