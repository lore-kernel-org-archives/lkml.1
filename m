Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZJ1Nat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZJ1Nat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZJ1Nas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:30:48 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:53720 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZJ1Nar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=S31rEitaWgzaH6JHYiGU3rthyZ34HcgwlImQ00lxfhxRTd3hVkzLPyAgyural4Pqtf
         AmZQWKBOIHKAfbUv5oa8815bhss28VaZvvQTejdvBxlYvhrSK7mh4+bYMQR/Y7xbldSk
         dLRzFI9ETF1Qqdn+dtPVdnZdY+rVqj8KR1CsI=
Message-ID: <4AE84786.6090306@gmail.com>
Date: Wed, 28 Oct 2009 09:30:46 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [Alacrityvm-devel] [KVM PATCH v2 1/2] KVM: export lockless GSI
 attribute
References: <20091023023512.3891.65889.stgit@dev.haskins.net>	<20091023023845.3891.36857.stgit@dev.haskins.net> <4AE460F4.2090905@redhat.com> <4AE5A336.4010801@gmail.com> <4AE5C26A.9000400@gmail.com> <4AE81710.1080103@redhat.com> <4AE844FA.4070408@gmail.com> <4AE846D6.6020505@redhat.com>
In-Reply-To: <4AE846D6.6020505@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig87773DB358049177C322A71A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig87773DB358049177C322A71A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/28/2009 03:19 PM, Gregory Haskins wrote:
>>> Yes, and it also contains the work_struct.
>>>
>>> What if we make the work_struct (and any additional state) part of th=
e
>>> set_atomic() argument list?  Does it simplify things?
>>>     =20
>> Hmmm, that might not, but we could do a kmalloc(GFP_ATOMIC) for such
>> parameters.  Considering this is just a safety net, perhaps this would=

>> work fine.
>>   =20
>=20
> Can't you simply pass the same work_struct from irqfd as we use now?

Well, yes, of course, but I am not sure that buys us much in terms of
generalizing the code.  Unless I am misunderstanding, that would still
leave the impetus of the init/sync/cleanup to the irqfd code, at which
point we might as well just leave it entirely in irqfd anyway.  Or am I
misunderstanding you?

>=20
>>>> So while generalizing this perhaps makes sense at some point,
>>>> especially
>>>> if irqfd-like interfaces get added, it probably doesn't make a ton o=
f
>>>> sense to expend energy on it ATM.  It is basically a generalization =
of
>>>> the irqfd deferrment code.  Lets just wait until we have a user beyo=
nd
>>>> irqfd for now.  Sound acceptable?
>>>>
>>>>       =20
>>> I'll look at v3, but would really like to disentangle this.
>>>     =20
>> Ok, I will see what I can do.  I need at least a v4 to get rid of the
>> dependency on the now defunct v3:1/3 patch per yesterdays discussion.
>>   =20
>=20
> There's another alternative - make ioapic and pic irq-safe by switching=

> irq locking to spinlocks and using spin_lock_irqsave().
>=20
> I've long opposed this since the ioapic loops on all vcpus when
> injecting some irqs and this will increase irqoff times with large
> guests.  But we don't have large guests now, and we need irq-safe
> injection in three places now:
>=20
> - irqfd
> - pit - we now signal vcpu0 to handle the injection, but this has its
> problems
> - device assignment
>=20
> so it may be better to have irq-safe injection, and deal with the loop
> later (would be good to have an idea how exactly).

Ok, perhaps I should just hold off on this series for now, then.  I can
submit the original "assume atomic safe" once the path is fully lockless.=


-Greg

>=20



--------------enig87773DB358049177C322A71A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkroR4YACgkQP5K2CMvXmqFEcgCaA95RZOEbV108Pp9QfvqCXQa4
B7cAnRtNePX5INkEy1A4y0Jqrwya2QTO
=St2P
-----END PGP SIGNATURE-----

--------------enig87773DB358049177C322A71A--
