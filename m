Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZFRWrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZFRWrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZFRWr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:47:29 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35345 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbZFRWr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:29 -0400
Message-ID: <4A3AC3F6.8070402@novell.com>
Date: Thu, 18 Jun 2009 18:47:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com> <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com> <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com> <4A39415C.9060803@novell.com> <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com> <4A39649C.4020602@novell.com> <alpine.DEB.1.10.0906171457000.7891@makko.or.mcafeemobile.com> <4A3A48AB.2080206@novell.com> <alpine.DEB.1.10.0906181011140.32646@makko.or.mcafeemobile.com> <4A3A8FBC.10905@novell.com> <alpine.DEB.1.10.0906181500350.32646@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906181500350.32646@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF84FCBB5B142CD83B0C69845"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF84FCBB5B142CD83B0C69845
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Thu, 18 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Davide Libenzi wrote:
>>    =20
>>> On Thu, 18 Jun 2009, Gregory Haskins wrote:
>>>
>>>  =20
>>>      =20
>>>> Actually there is only one (the tx-thread) aside from the eventfd
>>>> imposed workqueue one.  Incidentally, I would love to get rid of the=

>>>> other thread too, so I am not just picking on eventfd ;).  The other=
 is
>>>> a lot harder since it has to update the virtio-ring and may need to =
page
>>>> in guest memory to do so.
>>>>    =20
>>>>        =20
>>> No, there is the interface rx softirq too, that makes two.
>>>      =20
>> Actually, I believe you are mistaken.  It normally executes the softir=
q
>> in interrupt context, not a thread.
>>
>> But I digress.  Lets just shelve the SRCU conversation for another day=
=2E=20
>> It was my bad for introducing it now prematurely to solve a mostly
>> unrelated problem: the module-reference thing.  I didn't realize the
>> SRCU change would be so controversial, and I didn't think to split
>> things apart as I have done today.
>>
>> But the fact is: I do not see any way to actually use your referencele=
ss
>> POLLHUP release code in a race free way without doing something like I=

>> propose in 3/4, 4/4.   Lets keep the discussion focused on that for no=
w,
>> if we could.
>>    =20
>
> OK, since I got literally swamped by the amount of talks and patches ov=
er=20
> this theoretically simple topic, would you mind  1) posting the global =

> patch over eventfd  2) describe exactly what races are you talking abou=
t=20
> 3) explain why this should be any concern of eventfd at all?
>
>
>  =20
Yes, I can do that.  Thanks Davide,

-Greg



--------------enigF84FCBB5B142CD83B0C69845
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko6w/YACgkQlOSOBdgZUxnanwCfeTGC0kMezSt5VSUa4Hxg4mUf
N8IAmwZxSU4XGKrcTqXVH+Qaxuw1UyXN
=Zu08
-----END PGP SIGNATURE-----

--------------enigF84FCBB5B142CD83B0C69845--
