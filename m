Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbZJVPdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbZJVPdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbZJVPdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:33:14 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:42950 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbZJVPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=H0PX9f9k/izS+mAYwCqWNv3Mhpw+PowOC758kE5CWRz2aMYz7QSDFgJ2fQmCHBdqkh
         yQddC0lHrkCMmQAT4dnvmzzvzJxXVII/1QKtSVWge4wFiDs/MDz2LrY4T2OsghlW9cGW
         IPQ5XXJ/N+kuh6gAtiwtPeVPa1ZcnFKw75ZpY=
Message-ID: <4AE07B2F.2040508@gmail.com>
Date: Thu, 22 Oct 2009 11:33:03 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [KVM PATCH 1/2] KVM: Directly inject interrupts via irqfd
References: <20091021143042.14955.22470.stgit@dev.haskins.net> <20091021143453.14955.80578.stgit@dev.haskins.net> <20091021152621.GR29477@redhat.com> <4ADF2A1B.3010205@gmail.com> <20091021153640.GS29477@redhat.com> <4ADF2BDD.40706@gmail.com> <4AE07541.8060903@redhat.com> <4AE076E0.7030100@gmail.com> <4AE07814.6020906@redhat.com>
In-Reply-To: <4AE07814.6020906@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBE0F6C12684A324E5F4616DB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBE0F6C12684A324E5F4616DB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/22/2009 05:14 PM, Gregory Haskins wrote:
>> Yeah, I was thinking about that after I initially responded to Gleb.
>>
>> I am thinking something along these lines:
>>
>> Provide a function that lets you query a GSI for whether it supports
>> LOCKLESS or not.  Then we can either do one of two things:
>>
>> 1) Check for the LOCKLESS attribute at irqfd registration, fail if not=

>> present
>>   =20
>=20
> This is the most practical path and leads to the smallest code.  Howeve=
r
> it has the deficiency of exposing internal implementation details to
> userspace.  In theory userspace could use msi and edge-triggered
> pic/ioapic interrupts equally well, it shouldn't have to know that we
> didn't bother to lockfree ioapic/pic.
>=20
>> 2) Cache the LOCKLESS attribute in the irqfd structure, and either go
>> direct or defer to a workqueue depending on the flag.
>>   =20
>=20
> While this leads to larger code, it is more consistent.
>=20

Yeah, I think you are right.  Consider these two patches retracted, and
I will rewrite it with this concept in place.

Kind Regards,
-Greg


--------------enigBE0F6C12684A324E5F4616DB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrgey8ACgkQP5K2CMvXmqFVlACfWe0ZVNURu+I8jtJkRBS2w91T
bxYAnA4cV+jB8541HR0vzs0RQLQ9hgIn
=QfaY
-----END PGP SIGNATURE-----

--------------enigBE0F6C12684A324E5F4616DB--
