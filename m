Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZFUSjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZFUSjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 14:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZFUSjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 14:39:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51781 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZFUSjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 14:39:39 -0400
Message-ID: <4A3E7E63.1070407@novell.com>
Date: Sun, 21 Jun 2009 14:39:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com> <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBE5B8AE91813711906E45C28"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBE5B8AE91813711906E45C28
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Sat, 20 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Davide Libenzi wrote:
>>    =20
>>> On Sat, 20 Jun 2009, Davide Libenzi wrote:
>>>
>>>  =20
>>>      =20
>>>> On Sat, 20 Jun 2009, Davide Libenzi wrote:
>>>>
>>>>    =20
>>>>        =20
>>>>> How about the one below?
>>>>>      =20
>>>>>          =20
>>>> Maybe with an interface that can be undone w/out a file* :)
>>>>    =20
>>>>        =20
>>> This is another alternative, based on a low-carb diet of your notifie=
r=20
>>> patch.
>>>  =20
>>>      =20
>> Ah, I should always check if I have more mail before responding to a n=
ow
>> stale patch ;)
>>    =20
>
> Here. I changed the eventfd_pollcb_register() prototype to return the f=
ull=20
> registeration time event mask, instead of the POLLIN explicit check.
> Let's give this one some more thought before I push it to Andrew.
>  =20

This looks great, Davide.  I am fairly certain I can now solve the races
and even implement Michael's DEASSIGN feature with this patch in place.=20
I will actually fire it up tomorrow when I am back in the office and
give it a spin, but I do not spy any more races via visual inspection.

Kind Regards,
-Greg

PS: I was wrong with my previous statement about requiring an embeddable
object (eventfd_notifier for me, eventfd_pollcb for you).  I think you
can technically solve this issue minimally by merely locking the POLLHUP
and exposing the kref.  However, I think that leads to an more awkward
interface (e.g. we already have eventfd_fget() plus we add a new one
like eventfd_refget(), which might confuse users), so I prefer what you
did here.  Just thought I would throw that out there in case you would
prefer to change even fewer lines.



--------------enigBE5B8AE91813711906E45C28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko+fmMACgkQlOSOBdgZUxmFaACgifLr2x7NM83KkLmQnrixEMJr
Bl4An37+nFxZk8yXOcTX7n23YVsYV4ga
=BxJX
-----END PGP SIGNATURE-----

--------------enigBE5B8AE91813711906E45C28--
