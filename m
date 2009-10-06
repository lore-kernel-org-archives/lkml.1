Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbZJFRBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbZJFRBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZJFRBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:01:39 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61072 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZJFRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=nWXXTnhiEJmVwc9QS6H4bpKw5AwfprCdD9jOvsBqjKfdu/Dof8Mi+lIcSFvVDJ1eSL
         AJL8h3RA2R5ciNZgZ1VqL7Nru8UHuxt9uzuSY4Inbkzj4Qezivmmytwb3I5VAMxu4ktz
         VzrzHkmjgxBhpJAEF6+6W1CgrunHRgySvB6Xc=
Message-ID: <4ACB77C8.9060007@gmail.com>
Date: Tue, 06 Oct 2009 13:00:56 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com> <4ACB46AD.8010405@gmail.com> <4ACB528D.6030408@gmail.com> <4ACB6F0E.4000407@redhat.com> <4ACB7794.5040308@gmail.com>
In-Reply-To: <4ACB7794.5040308@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA277F302C50BD3075C41324A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA277F302C50BD3075C41324A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Avi Kivity wrote:
>> On 10/06/2009 04:22 PM, Gregory Haskins wrote:
>>>>>>>> +
>>>>>>>> +static inline void
>>>>>>>> +_kvm_xinterface_release(struct kref *kref)
>>>>>>>> +{
>>>>>>>> +    struct kvm_xinterface *intf;
>>>>>>>> +    struct module *owner;
>>>>>>>> +
>>>>>>>> +    intf =3D container_of(kref, struct kvm_xinterface, kref);
>>>>>>>> +
>>>>>>>> +    owner =3D intf->owner;
>>>>>>>> +    rmb();
>>>>>>>>
>>>>>>>>
>>>>>>>>             =20
>>>>>>> Why rmb?
>>>>>>>
>>>>>>>           =20
>>>>>> the intf->ops->release() line may invalidate the intf pointer, so =
we
>>>>>> want to ensure that the read completes before the release() is cal=
led.
>>>>>>
>>>>>> TBH: I'm not 100% its needed, but I was being conservative.
>>>>>>
>>>>>>         =20
>>>>> rmb()s are only needed if an external agent can issue writes, other=
wise
>>>>> you'd need one after every statement.
>>>>>       =20
>>>> I was following lessons learned here:
>>>>
>>>> http://lkml.org/lkml/2009/7/7/175
>>>>
>>>> Perhaps mb() or barrier() are more appropriate than rmb()?  I'm CC'i=
ng
>>>> David Howells in case he has more insight.
>>>>     =20
>>> BTW: In case it is not clear, the rationale as I understand it is we
>>> worry about the case where one cpu reorders the read to be after the
>>> ->release(), and another cpu might grab the memory that was kfree()'d=

>>> within the ->release() and scribble something else on it before the r=
ead
>>> completes.
>>>
>>> I know rmb() typically needs to be paired with wmb() to be correct, s=
o
>>> you are probably right to say that the rmb() itself is not appropriat=
e.
>>>   This problem in general makes my head hurt, which is why I said I a=
m
>>> not 100% sure of what is required.  As David mentions, perhaps
>>> "smp_mb()" is more appropriate for this application.  I also speculat=
e
>>> barrier() may be all that we need.
>>>   =20
>> barrier() is the operation for a compiler barrier.  But it's unneeded
>> here - unless the compiler can prove that ->release(intf) will not
>> modify intf->owner it is not allowed to move the access afterwards.  A=
n
>> indirect function call is generally a barrier() since the compiler can=
't
>> assume memory has not been modified.
>>
>=20
> You're logic

gak.  or "your logic" even.

> seems reasonable to me.  I will defer to David, since he
> brought up the issue with the similar logic originally.
>=20
> Kind Regards,
> -Greg
>=20



--------------enigA277F302C50BD3075C41324A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrLd8gACgkQP5K2CMvXmqEvQwCgi1xB554e4BEkVAhERScFmtHz
408An0ewLL73g+ZHN+UE1pzlIbfwwJw5
=envK
-----END PGP SIGNATURE-----

--------------enigA277F302C50BD3075C41324A--
