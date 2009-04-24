Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZDXEM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZDXEM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZDXEMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:12:08 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40038 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZDXEMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:12:07 -0400
Message-ID: <49F13C0B.6040408@novell.com>
Date: Fri, 24 Apr 2009 00:11:55 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH 2/3] eventfd: add a notifier mechanism
References: <20090423150910.14094.73708.stgit@dev.haskins.net> <20090423151436.14094.35875.stgit@dev.haskins.net> <alpine.DEB.1.10.0904230922180.18603@makko.or.mcafeemobile.com> <49F09B78.7000403@novell.com> <alpine.DEB.1.10.0904231500570.18603@makko.or.mcafeemobile.com> <49F0E7B4.90702@novell.com> <alpine.DEB.1.10.0904231942000.18603@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0904231942000.18603@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig02818AE869B24F3261E15094"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig02818AE869B24F3261E15094
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Thu, 23 Apr 2009, Gregory Haskins wrote:
>
>  =20
>>> Take a look at init_waitqueue_func_entry(), in particula at that "fun=
c"=20
>>> parameter. Then look at how __wake_up_common() does its thing.
>>> You don't need to be "waiting" for our wakeup system to work. Callbac=
ks=20
>>> works just fine, otherwise things like epoll could not work at all.
>>>  =20
>>>      =20
>> Yeah, I was looking at that this afternoon after you mentioned it.  Th=
at
>> makes sense.
>>
>> As of right now the wqh is embedded in the eventfd, accessible only by=

>> the .read() vtable entry.  In order to do this as you suggest, I imagi=
ne
>> I need to slightly modify the eventfd interface to allow waiters other=

>> than the embedded readers to join the wait-queue.  How would you like =
to
>> see that interface look?
>>    =20
>
> Actually, you need no changes in eventfd, since you can use its poll() =

> directly, by dropping a callback entry.
> Take a look at how epoll does it in ep_insert()...
>  =20
Ah!  I just tried your suggestion and it was simple and it works.  That
is brilliant.

I will post a follow-up v2 that drops patch 2/3.  Thanks, Davide.

-Greg




--------------enig02818AE869B24F3261E15094
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknxPAsACgkQlOSOBdgZUxlDcACgjt6mekP+bIcoVHjubFlWiHja
/e4An21rBhroqofC9PG2SYBY3309Q5B4
=zn1B
-----END PGP SIGNATURE-----

--------------enig02818AE869B24F3261E15094--
