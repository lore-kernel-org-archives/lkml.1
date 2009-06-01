Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZFAMPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZFAMPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 08:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZFAMPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 08:15:01 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53832 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZFAMPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 08:15:00 -0400
Message-ID: <4A23C642.7010002@novell.com>
Date: Mon, 01 Jun 2009 08:14:58 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Mark McLoughlin <markmc@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
References: <20090526191010.20860.75372.stgit@dev.haskins.net>	 <20090526191539.20860.1385.stgit@dev.haskins.net>	 <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>	 <4A1D2DD8.2050709@redhat.com> <1243445144.16318.15.camel@blaa>	 <4A1D7AFD.40004@novell.com> <1243446484.4852.13.camel@blaa>	 <4A1DA653.4050109@gmail.com> <1243501772.4046.36.camel@blaa> <4A1E7FA0.8060300@novell.com> <4A2249C5.5000809@redhat.com>
In-Reply-To: <4A2249C5.5000809@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA2DDC7D7670C6491DFD5279F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA2DDC7D7670C6491DFD5279F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> This is closer to how the original series worked, but Avi asked for a
>> data-match token and thus the cookie was born.  I think the rationale =
is
>> that we can't predict whether the same eventfd will be registered more=

>> than once, and thus we need a way to further qualify it.  However, to
>> your point, I cannot think of a valid use case for having the same fd
>> registered to the same address more than once, so perhaps your fd/addr=

>> tuple is sufficient and we can drop the cookie (or, really, rename it =
to
>> "trigger" ;)
>>
>> Avi?
>>  =20
>
> This is just how virtio works.  To kick ring N of device X, it writes
> N to a port specific to X.
>
> If we lose N, then we don't know which ring was kicked and have to
> check them all.
>
> May we can rename cookie to data_match to make it explicit.  If the
> data doesn't match, the eventfd isn't kicked.
>
> (Mark, same as we have arbitrary ring->MSI mappings (allowing one MSI
> to notify multiple rings), perhaps we should have the same capability
> for the other direction?  So the guest could kick mulitple rings with
> one write, or just one ring, according to personal preference.
>
I think we are all on the same page here, actually (more or less).  I
think the confusion was my own when you initially asked for a data-match
token, and I gave you "cookie".  "cookie" as I implemented it was really
only used to match up the eventfd during de-assign, not the actual
signal event.  I think what you are talking about here is the same as
what Mark and I have been calling "trigger".  I agree that we need this
interface to be able to properly sort something like virtio, and I will
be including this in the next release.

OTOH, what I was proposing above is that my misguided attempt at
"cookie" for deassign is redundant with simply looking at the
eventfd/addr tuple.  We can simply key off of those items to match up
the iosignalfd to close, and therefore lets get rid of the cookie field.

Sorry for the confusion.  Let me know if you still think this isn't right=
=2E

-Greg


--------------enigA2DDC7D7670C6491DFD5279F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkojxkIACgkQlOSOBdgZUxknLACeK3mBSbEfAxoelRRmw3EIbgWB
UMIAnidYFGKLnD3xmUxAXdqpq+1ALrnb
=He0U
-----END PGP SIGNATURE-----

--------------enigA2DDC7D7670C6491DFD5279F--
