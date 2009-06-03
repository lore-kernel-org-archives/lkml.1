Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZFCLeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZFCLeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbZFCLe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:34:28 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:37117 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZFCLe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:34:28 -0400
Message-ID: <4A265FBD.3080108@novell.com>
Date: Wed, 03 Jun 2009 07:34:21 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com> <4A254FD7.5090302@novell.com> <20090602162021.GB6827@redhat.com> <4A255484.6060401@novell.com> <20090602165949.GD6827@redhat.com> <4A256431.2080101@novell.com> <20090603063956.GA8134@redhat.com>
In-Reply-To: <20090603063956.GA8134@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig49573CFFCEED5084AB43BF0A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig49573CFFCEED5084AB43BF0A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 02, 2009 at 01:41:05PM -0400, Gregory Haskins wrote:
>  =20
>>> And having close not clean up the state unless you do an ioctl first =
is
>>> very messy IMO - I don't think you'll find any such examples in kerne=
l.
>>>
>>>  =20
>>>      =20
>> I agree, and that is why I am advocating this POLLHUP solution.  It wa=
s
>> only this other way to begin with because the technology didn't exist
>> until Davide showed me the light.
>>
>> Problem with your request is that I already looked into what is
>> essentially a bi-directional reference problem (for a different reason=
)
>> when I started the POLLHUP series.  Its messy to do this in a way that=

>> doesn't negatively impact the fast path (introducing locking, etc) or
>> make my head explode making sure it doesn't race.  Afaict, we would ne=
ed
>> to solve this problem to do what you are proposing (patches welcome).
>>
>> If this hybrid decoupled-deassign + unified-close is indeed an importa=
nt
>> feature set, I suggest that we still consider this POLLHUP series for
>> inclusion, and then someone can re-introduce DEASSIGN support in the
>> future as a CAP bit extension.  That way we at least get the desirable=

>> close() properties that we both seem in favor of, and get this advance=
d
>> use case when we need it (and can figure out the locking design).
>>
>>    =20
>
> FWIW, I took a look and yes, it is non-trivial.
> I concur, we can always add the deassign ioctl later.
>
>
>
>  =20

Sounds good, Michael.  Thanks!

-Greg


--------------enig49573CFFCEED5084AB43BF0A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkomX8IACgkQlOSOBdgZUxnXKQCffOAJZLTSB6k8VMoOJnLWmw8s
UHsAn3/AXzrHbW80oI/ha43+/GsJZpT2
=IQIs
-----END PGP SIGNATURE-----

--------------enig49573CFFCEED5084AB43BF0A--
