Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbZFYPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbZFYPpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZFYPpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:45:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44332 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZFYPpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:45:34 -0400
Message-ID: <4A439B90.1030109@novell.com>
Date: Thu, 25 Jun 2009 11:45:20 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
References: <20090623150008.GA21059@redhat.com> <4A4184C3.6060503@novell.com> <20090624084901.GB22865@redhat.com> <20090625110812.GA6487@redhat.com>
In-Reply-To: <20090625110812.GA6487@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE1A3917C6159630C9832B6C1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE1A3917C6159630C9832B6C1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, Jun 24, 2009 at 11:49:01AM +0300, Michael S. Tsirkin wrote:
>  =20
>> On Tue, Jun 23, 2009 at 09:43:31PM -0400, Gregory Haskins wrote:
>>    =20
>>> Michael S. Tsirkin wrote:
>>>      =20
>>>> Remove in_range from kvm_io_device and ask read/write callbacks, if
>>>> supplied, to perform range checks internally. This allows aliasing
>>>> (mostly for in-kernel virtio), as well as better error handling by
>>>> making it possible to pass errors up to userspace. And it's enough t=
o
>>>> look at the diffstat to see that it's a better API anyway.
>>>>
>>>> While we are at it, document locking rules for kvm_io_device.
>>>>  =20
>>>>        =20
>>> Hi Michael,
>>>
>>> I just tried to apply this to kvm.git/master, and it blew up really
>>> badly.  What tree should I be using?
>>>      =20
>> Ugh, this is against 2.6.30. I'll post kvm.git version soon.
>>
>>    =20
>
> I went ahead and tried to rebase it, to find that it conflicts with
> recent patch 35b3038961f94e83557944ae0d30c8fa0b5012cf merged in kvm.git=
:
> 'KVM: switch irq injection/acking data structures to irq_lock'
> which now does this:
> 	lock
> 	find
> 	unlock
> 	write
>
> I thought for a while that it might make sense to start small and just
> add in_range parameter for starters ...
> However, I just realised that this only works because devices are not
> added or removed dynamically.
>
> The long term fix is to switch to SRCU for bus management.  But if we
> need to do this for iosignalfd anyway, in_range removal becomes possibl=
e
> again.
>
> Short term it might be also possible to go back to keeping kvm lock
> across both find and read - since the lock is taken, we don't
> really win anything currently if we drop the lock earlier.
>
> Comments?
>  =20

I just took another look.  Things are quite messy and I don't know what
the optimal order of merging is.  Go ahead with your remove-inrange and
srcu plan and I will just defer submitting the iosignalfd related series
till you are happy with the new layout.

Thanks Michael,
-Greg



--------------enigE1A3917C6159630C9832B6C1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpDm5AACgkQlOSOBdgZUxmy4ACffdCP1GFQGpNf36rPOcQtww2B
bxgAnR2FoIZaTauAaDzcWg1+Km0Py2/p
=qshn
-----END PGP SIGNATURE-----

--------------enigE1A3917C6159630C9832B6C1--
