Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbZE1MMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbZE1MMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbZE1MM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:12:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35017 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041AbZE1MM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:12:26 -0400
Message-ID: <4A1E7FA0.8060300@novell.com>
Date: Thu, 28 May 2009 08:12:16 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
References: <20090526191010.20860.75372.stgit@dev.haskins.net>	 <20090526191539.20860.1385.stgit@dev.haskins.net>	 <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>	 <4A1D2DD8.2050709@redhat.com> <1243445144.16318.15.camel@blaa>	 <4A1D7AFD.40004@novell.com> <1243446484.4852.13.camel@blaa>	 <4A1DA653.4050109@gmail.com> <1243501772.4046.36.camel@blaa>
In-Reply-To: <1243501772.4046.36.camel@blaa>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCC91BF107986EC685B067D44"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCC91BF107986EC685B067D44
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mark McLoughlin wrote:
> On Wed, 2009-05-27 at 16:45 -0400, Gregory Haskins wrote:
>  =20
>> Mark McLoughlin wrote:
>>    =20
>>> The virtio ABI is fixed, so we couldn't e.g. have the guest use a coo=
kie
>>> to identify a queue - it's just going to continue using a per-device
>>> queue number.=20
>>>      =20
>> Actually, I was originally thinking this would be exposed as a virtio
>> FEATURE bit anyway, so there were no backwards-compat constraints.  Th=
at
>> said, we can possibly make it work in a backwards compat way, too.=20
>> IIRC, today virtio does a PIO cycle to a specific register with the
>> queue-id when it wants to signal guest->host, right?  What is the widt=
h
>> of the write?
>>    =20
>
> It's a 16-bit write.
>
> /* A 16-bit r/w queue notifier */
> #define VIRTIO_PCI_QUEUE_NOTIFY         16
>  =20

(Thanks)

>  =20
>>> So, if the cookie was also the trigger, we'd need an
>>> eventfd per device.
>>>  =20
>>>      =20
>> I'm having trouble parsing this one.  The cookie namespace is controll=
ed
>> by the userspace component that owns the corresponding IO address, so
>> there's no reason you can't make "queue-id =3D 0" use cookie =3D 0, or=

>> whatever.  That said, I still think a separation of the cookie and
>> trigger as suggested above is a good idea, so its probably moot to
>> discuss this point further.
>>    =20
>
> Ah, my mistake - I thought the cookie was returned to userspace when th=
e
> eventfd was signalled, but no ... userspace only gets an event counter
> value and the cookie is used during de-assignment to distinguish betwee=
n
> iosignalfds.
>
> Okay, so suppose you do assign multiple times at a given address -
> you're presumably going to use a different eventfd for each assignment?=

> If so, can't we match using both the address and eventfd at
> de-assignment and drop the cookie from the interface altogether?
>  =20

This is closer to how the original series worked, but Avi asked for a
data-match token and thus the cookie was born.  I think the rationale is
that we can't predict whether the same eventfd will be registered more
than once, and thus we need a way to further qualify it.  However, to
your point, I cannot think of a valid use case for having the same fd
registered to the same address more than once, so perhaps your fd/addr
tuple is sufficient and we can drop the cookie (or, really, rename it to
"trigger" ;)

Avi?

Regards,
-Greg


--------------enigCC91BF107986EC685B067D44
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoef6UACgkQlOSOBdgZUxmxTwCfX9nRJei5ayKm3jkCFIUm2eKP
hA0Ani1ZzmHGubbhGZqddjXayXJch18V
=b7H6
-----END PGP SIGNATURE-----

--------------enigCC91BF107986EC685B067D44--
