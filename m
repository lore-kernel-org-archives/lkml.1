Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbZEFNSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbZEFNSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZEFNRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:17:49 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43571 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZEFNRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:17:47 -0400
Message-ID: <4A018DF2.6010301@novell.com>
Date: Wed, 06 May 2009 09:17:38 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org>
In-Reply-To: <20090506072212.GV3036@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig03409896EE9ACA4014921DE9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig03409896EE9ACA4014921DE9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Chris Wright wrote:
> * Gregory Haskins (ghaskins@novell.com) wrote:
>  =20
>> Chris Wright wrote:
>>    =20
>>> But a free-form hypercall(unsigned long nr, unsigned long *args, size=
_t count)
>>> means hypercall number and arg list must be the same in order for cod=
e
>>> to call hypercall() in a hypervisor agnostic way.
>>>      =20
>> Yes, and that is exactly the intention.  I think its perhaps the point=

>> you are missing.
>>    =20
>
> Yes, I was reading this as purely any hypercall, but it seems a bit
> more like:
>  pv_io_ops->iomap()
>  pv_io_ops->ioread()
>  pv_io_ops->iowrite()
>  =20

Right.

> <snip>
>  =20
>> Today, there is no equivelent of a platform agnostic "iowrite32()" for=

>> hypercalls so the driver would look like the pseudocode above except
>> substitute with kvm_hypercall(), lguest_hypercall(), etc.  The proposa=
l
>> is to allow the hypervisor to assign a dynamic vector to resources in
>> the backend and convey this vector to the guest (such as in PCI
>> config-space as mentioned in my example use-case).  The provides the
>> "address negotiation" function that would normally be done for somethi=
ng
>> like a pio port-address.   The hypervisor agnostic driver can then use=

>> this globally recognized address-token coupled with other device-priva=
te
>> ABI parameters to communicate with the device.  This can all occur
>> without the core hypervisor needing to understand the details beyond t=
he
>> addressing.
>>    =20
>
> VF drivers can also have this issue (and typically use mmio).
> I at least have a better idea what your proposal is, thanks for
> explanation.  Are you able to demonstrate concrete benefit with it yet
> (improved latency numbers for example)?
>  =20

I had a test-harness/numbers for this kind of thing, but its a bit
crufty since its from ~1.5 years ago.  I will dig it up, update it, and
generate/post new numbers.

Thanks Chris,
-Greg



--------------enig03409896EE9ACA4014921DE9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoBjfIACgkQlOSOBdgZUxlBkACfa34bmCmX02A6/wjjyOAd93Pk
m9kAnAjSZv8wpWi6TsI9te8qiy7nym4s
=bFzj
-----END PGP SIGNATURE-----

--------------enig03409896EE9ACA4014921DE9--
