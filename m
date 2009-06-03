Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZFCTyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZFCTyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZFCTxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:53:54 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35744 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbZFCTxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:53:53 -0400
Message-ID: <4A26D4CC.4040504@novell.com>
Date: Wed, 03 Jun 2009 15:53:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: davidel@xmailserver.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] epoll - send POLLHUP on ->release
References: <alpine.DEB.1.10.0906031153471.18001@makko.or.mcafeemobile.com>	<4A26CCFA.7050105@novell.com> <20090603122739.c53b1d1f.akpm@linux-foundation.org>
In-Reply-To: <20090603122739.c53b1d1f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD7724F9E5E1D0D8A7A9F9DA3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD7724F9E5E1D0D8A7A9F9DA3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> On Wed, 03 Jun 2009 15:20:26 -0400
> Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>> Davide Libenzi wrote:
>>    =20
>>> The following patch allows waiters to be notified about the eventfd f=
ile*=20
>>> going away, and give them a change to unregister from the wait queue.=

>>> This is turn allows eventfd users to use the eventfd file* w/out=20
>>> holding a live reference to it.
>>> After the eventfd user callbacks returns, any usage of the eventfd fi=
le*=20
>>> should be dropped. The eventfd user callback can acquire sleepy locks=
=20
>>> since it is invoked lockless.
>>>
>>>
>>>
>>> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
>>>  =20
>>>      =20
>> Tested-by: Gregory Haskins <ghaskins@novell.com>
>>    =20
>
> Confused.  Did you test this with some new kernel patch, or with some
> existing kernel code?
>
>  =20
Hi Andrew,

Davide created this patch in response to a problem we were trying to
solve in kvm.git.  I took this patch in question, and combined it with a
proposed patch for KVM and tested it out.  You can find the thread here:

http://lkml.org/lkml/2009/6/2/276

I built a test harness and verified that calling close() on an eventfd
does indeed generate a POLLHUP wakeup, and that my code properly cleans
up when it gets the POLLHUP

Acceptance of my kvm optimization is predicated on Davide's patch going
in first, so I asked him to submit it formally.  I figured I should
chime in my findings in case it matters for upstream acceptance.=20
(Apologies if this is not the normal/acceptable "tested-by"
protocol...tested-by tag noob here ;)


> If the latter, what code are we talking about here and what was the tes=
t
> case and what went wrong when using the current mainline
> implementation?
>
>  =20

Its not what went wrong per se.  Its more of a case of eliminating the
need for an awkward work-around I had to do when eventfd didn't provide
a release notification.  You can find the details in my patch 2/2
header, available here for your convenience:

http://lkml.org/lkml/2009/6/2/278

Regards,
-Greg


--------------enigD7724F9E5E1D0D8A7A9F9DA3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkom1NAACgkQlOSOBdgZUxn+zACggy8ndf7njKPYDqPi820GPmpq
jd8AnRYF13UKj/wXC6a/Yn6CE3GJ5Xp2
=kRSA
-----END PGP SIGNATURE-----

--------------enigD7724F9E5E1D0D8A7A9F9DA3--
