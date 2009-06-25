Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZFYNCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZFYNCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZFYNCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:02:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41867 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZFYNCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:02:39 -0400
Message-ID: <4A437564.6060308@novell.com>
Date: Thu, 25 Jun 2009 09:02:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
References: <20090623150008.GA21059@redhat.com> <4A4184C3.6060503@novell.com> <20090624084901.GB22865@redhat.com> <20090625110812.GA6487@redhat.com> <4A435F28.3000301@novell.com> <20090625115403.GA7079@redhat.com> <4A4368A4.8030401@novell.com> <20090625123757.GA7121@redhat.com>
In-Reply-To: <20090625123757.GA7121@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD80BF65C9BD3FCEC9AFEE797"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD80BF65C9BD3FCEC9AFEE797
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 25, 2009 at 08:08:04AM -0400, Gregory Haskins wrote:
>  =20
>> The patch has been in circulation for weeks, is well tested/reviewed
>> (and I hope its considered well written), and I want to get on with my=

>> life ;).
>>    =20
>
> Hey, I feel your pain, I've been reviewing these ..
>
>  =20
>> Your proposal doesn't change the user->kern ABI, so any
>> consolidation will be just an internal change to the kernel code only.=
=20
>> People can start using the interface today to build things, and we can=

>> fix up the internal code later once your proposals have had a chance t=
o
>> be shaped after review, etc (which I know from experience can take a
>> while and change radically though the course ;).
>>
>> IOW: The only thing waiting does is hide the history of the edit, sinc=
e
>> whatever change is proposed is invariably the same amount of work for =
me
>> to convert it over.  Its purely a question of whether its folded into
>> the history or visible as two change records.  Based on that. I don't
>> see any problem with it just going in now.  Its certainly ready from m=
y
>> perspective.
>>
>> So I guess the question is: What's your objection?
>>    =20
>
> No objections, only comments ;)
>  =20

:)
>  =20
>> (BTW: I am talking about the yet unpublished "v9" which addresses all
>> your other comments sans the io_bus interface changes.
>>    =20
>
> I thought we agreed on the io_bus approach. What changed?
>  =20

Oh yeah, nothing changed.  I still totally agree with what you want to
do.  I am just thinking that you are proposing some relatively
non-trivial changes that will take another few weeks to get reviewed and
accepted, whereas iosignalfd is more or less ready to go aside from
integrating with this change.  Its an additional maintenance burden on
my part to live out of tree so I aim to minimize that since I can't see
much benefit in waiting.  However, it's not a huge deal either way, reall=
y.

>  =20
>>  Will push out
>> later today)
>>    =20
>
> BTW, is the group removal race handled there somehow?
> Here's what I have in mind:
> kvm does
> 	lock
> 	dev =3D find
> 	unlock
>
> 	<---------- at this point group device is removed
>
> 	write access to device that has been removed
>
>
>  =20

Hmm...you are right.  This looks like it was introduced with that recent
locking patch you cited.  Well, I can still fix it now easily by putting
an rcu-read-lock around the access.  Longer term we should move to
srcu.  Thoughts?

-Greg


--------------enigD80BF65C9BD3FCEC9AFEE797
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpDdWQACgkQlOSOBdgZUxkK+QCggjPlBrpFp/VrYTs+jxGmQUAo
1lEAn1gSzhtEeVbUvIK3puBPMvWckkQC
=GDfE
-----END PGP SIGNATURE-----

--------------enigD80BF65C9BD3FCEC9AFEE797--
