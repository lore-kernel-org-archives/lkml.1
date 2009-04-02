Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbZDBM2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbZDBM2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZDBM2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:28:33 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51013 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZDBM2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:28:32 -0400
Message-ID: <49D4AFF7.1050603@novell.com>
Date: Thu, 02 Apr 2009 08:30:47 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <20090402091639.GA30126@gondor.apana.org.au> <49D484F5.2000400@redhat.com> <20090402092936.GA30333@gondor.apana.org.au> <49D487A6.407@redhat.com> <49D49C1F.6030306@novell.com> <49D4A89E.5090407@redhat.com>
In-Reply-To: <49D4A89E.5090407@redhat.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE0BFBB5CBC84E288E51B5F0F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE0BFBB5CBC84E288E51B5F0F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>
> =20
>
>>> Why does a kernel solution not need to know when a packet is
>>> transmitted?
>>>
>>>    =20
>>
>> You do not need to know when the packet is copied (which I currently
>> do).  You only need it for zero-copy (of which I would like to support=
,
>> but as I understand it there are problems with the reliability of prop=
er
>> callback (i.e. skb->destructor).
>>
>> Its "fire and forget" :)
>>  =20
>
> It's more of a "schedule and forget" which I think brings you the
> win.  The host disables notifications and schedules the actual tx work
> (rx from the host's perspective).  So now the guest and host continue
> producing and consuming packets in parallel.  So long as the guest is
> faster (due to the host being throttled?), notifications continue to
> be disabled.
Yep, when the "producer::consumer" ratio is > 1, we mitigate signaling.=20
When its < 1, we signal roughly once per packet.

>
> If you changed your rx_isr() to process the packets immediately
> instead of scheduling, I think throughput would drop dramatically.
Right, that is the point. :) This is that "soft asic" thing I was
talking about yesterday.

-Greg



--------------enigE0BFBB5CBC84E288E51B5F0F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknUr/gACgkQlOSOBdgZUxl/+gCePKyvShVBT4++tDDPh+Sfe81t
QYwAn1FzLp21E/D6vvcHDQVVKnv1o3VQ
=Z49L
-----END PGP SIGNATURE-----

--------------enigE0BFBB5CBC84E288E51B5F0F--
