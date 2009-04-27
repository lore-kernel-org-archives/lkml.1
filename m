Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZD0K6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZD0K6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZD0K6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:58:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58593 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbZD0K6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:58:40 -0400
Message-ID: <49F58FD6.907@novell.com>
Date: Mon, 27 Apr 2009 06:58:30 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com>
In-Reply-To: <49F58A8C.7090808@novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig58ECD2E49F6F8D9D664781E4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig58ECD2E49F6F8D9D664781E4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Avi Kivity wrote:
>  =20
>>
>> One day we'll have lockless injection and we'll want to drop this.  I
>> guess if we create the fd ourselves we can make it work, but I don't
>> see how we can do this with eventfd.
>>
>>    =20
>
> Hmm...this is a good point.  There probably is no way to use eventfd
> "off the shelf" in a way that doesn't cause this callback to be in a
> critical section.  Should we just worry about switching away from
> eventfd when this occurs, or should I implement a custom anon-fd now?
>  =20

Something else to consider:  eventfd supports calling eventfd_signal()
from interrupt context, so
even if the callback were not invoked from a preempt/irq off CS due to
the wqh->lock, the context may still be a CS anyway.  Now, userspace and
vbus based injection do not need to worry about this, but I wonder if
this is a  desirable attribute for some other source (device-assignment
perhaps)?

If so, is there a way to design the lockless-injection code such that
its still friendly to irq-context, or is this a mode that we would never
want to support anyway?  I think this would be a good thing to have at
least to maintain compatibility with the existing eventfd interface,
which has its own advantages.

-Greg



--------------enig58ECD2E49F6F8D9D664781E4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn1j9YACgkQlOSOBdgZUxkh+QCghB/XuAQYRUWbKahBECPvmTKx
UaEAniumFwylJSVhwzR6R8dQO72fBDYc
=i+G1
-----END PGP SIGNATURE-----

--------------enig58ECD2E49F6F8D9D664781E4--
