Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZDXQaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZDXQaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZDXQ3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:29:55 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45825 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbZDXQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:29:54 -0400
Message-ID: <49F1E8EF.6030601@novell.com>
Date: Fri, 24 Apr 2009 12:29:35 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH 2/3] eventfd: add a notifier mechanism
References: <20090423150910.14094.73708.stgit@dev.haskins.net> <20090423151436.14094.35875.stgit@dev.haskins.net> <alpine.DEB.1.10.0904230922180.18603@makko.or.mcafeemobile.com> <49F09B78.7000403@novell.com> <alpine.DEB.1.10.0904231500570.18603@makko.or.mcafeemobile.com> <49F0E7B4.90702@novell.com> <alpine.DEB.1.10.0904231942000.18603@makko.or.mcafeemobile.com> <49F13C0B.6040408@novell.com> <alpine.DEB.1.10.0904240911280.13272@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0904240911280.13272@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB36AA7CD530D27997EFAE3D7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB36AA7CD530D27997EFAE3D7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Fri, 24 Apr 2009, Gregory Haskins wrote:
>
>  =20
>> Davide Libenzi wrote:
>>    =20
>>> On Thu, 23 Apr 2009, Gregory Haskins wrote:
>>>
>>>  =20
>>>      =20
>>>>> Take a look at init_waitqueue_func_entry(), in particula at that "f=
unc"=20
>>>>> parameter. Then look at how __wake_up_common() does its thing.
>>>>> You don't need to be "waiting" for our wakeup system to work. Callb=
acks=20
>>>>> works just fine, otherwise things like epoll could not work at all.=

>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> Yeah, I was looking at that this afternoon after you mentioned it.  =
That
>>>> makes sense.
>>>>
>>>> As of right now the wqh is embedded in the eventfd, accessible only =
by
>>>> the .read() vtable entry.  In order to do this as you suggest, I ima=
gine
>>>> I need to slightly modify the eventfd interface to allow waiters oth=
er
>>>> than the embedded readers to join the wait-queue.  How would you lik=
e to
>>>> see that interface look?
>>>>    =20
>>>>        =20
>>> Actually, you need no changes in eventfd, since you can use its poll(=
)=20
>>> directly, by dropping a callback entry.
>>> Take a look at how epoll does it in ep_insert()...
>>>  =20
>>>      =20
>> Ah!  I just tried your suggestion and it was simple and it works.  Tha=
t
>> is brilliant.
>>
>> I will post a follow-up v2 that drops patch 2/3.  Thanks, Davide.
>>    =20
>
> I assume you're in control of the file/fd lifetime, so that the file*=20
> cannot vanish while you've your wait_queue dropped inside its=20
> wait_queue_head, isn't it?
>  =20
I've addressed this issue by holding the file via eventfd_fget(), but
your review to make sure I got it right would be appreciated.

-Greg



--------------enigB36AA7CD530D27997EFAE3D7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknx6O8ACgkQlOSOBdgZUxlRyACZASRgDiNP8RYUmBLEQPVFESo9
hA8AnRHDwv6DNeHeIgZ5FS+0QV1u5UOM
=866M
-----END PGP SIGNATURE-----

--------------enigB36AA7CD530D27997EFAE3D7--
