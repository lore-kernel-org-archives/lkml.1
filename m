Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZFYMI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZFYMI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZFYMIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:08:19 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44940 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZFYMIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:08:18 -0400
Message-ID: <4A4368A4.8030401@novell.com>
Date: Thu, 25 Jun 2009 08:08:04 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
References: <20090623150008.GA21059@redhat.com> <4A4184C3.6060503@novell.com> <20090624084901.GB22865@redhat.com> <20090625110812.GA6487@redhat.com> <4A435F28.3000301@novell.com> <20090625115403.GA7079@redhat.com>
In-Reply-To: <20090625115403.GA7079@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5ADB63E82FF2DE60D8AB5565"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5ADB63E82FF2DE60D8AB5565
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 25, 2009 at 07:27:36AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Wed, Jun 24, 2009 at 11:49:01AM +0300, Michael S. Tsirkin wrote:
>>>  =20
>>>      =20
>>>> On Tue, Jun 23, 2009 at 09:43:31PM -0400, Gregory Haskins wrote:
>>>>    =20
>>>>        =20
>>>>> Michael S. Tsirkin wrote:
>>>>>      =20
>>>>>          =20
>>>>>> Remove in_range from kvm_io_device and ask read/write callbacks, i=
f
>>>>>> supplied, to perform range checks internally. This allows aliasing=

>>>>>> (mostly for in-kernel virtio), as well as better error handling by=

>>>>>> making it possible to pass errors up to userspace. And it's enough=
 to
>>>>>> look at the diffstat to see that it's a better API anyway.
>>>>>>
>>>>>> While we are at it, document locking rules for kvm_io_device.
>>>>>>  =20
>>>>>>        =20
>>>>>>            =20
>>>>> Hi Michael,
>>>>>
>>>>> I just tried to apply this to kvm.git/master, and it blew up really=

>>>>> badly.  What tree should I be using?
>>>>>      =20
>>>>>          =20
>>>> Ugh, this is against 2.6.30. I'll post kvm.git version soon.
>>>>
>>>>    =20
>>>>        =20
>>> I went ahead and tried to rebase it, to find that it conflicts with
>>> recent patch 35b3038961f94e83557944ae0d30c8fa0b5012cf merged in kvm.g=
it:
>>> 'KVM: switch irq injection/acking data structures to irq_lock'
>>> which now does this:
>>> 	lock
>>> 	find
>>> 	unlock
>>> 	write
>>>
>>> I thought for a while that it might make sense to start small and jus=
t
>>> add in_range parameter for starters ...
>>> However, I just realised that this only works because devices are not=

>>> added or removed dynamically.
>>>
>>> The long term fix is to switch to SRCU for bus management.  But if we=

>>> need to do this for iosignalfd anyway, in_range removal becomes possi=
ble
>>> again.
>>>
>>> Short term it might be also possible to go back to keeping kvm lock
>>> across both find and read - since the lock is taken, we don't
>>> really win anything currently if we drop the lock earlier.
>>>
>>> Comments?
>>>
>>>  =20
>>>      =20
>> Can we just get iosignalfd merged for now as it is, then?
>>    =20
>
> The patch that adds value to in_range is still okay. We could go that
> way for now.  But what I am saying is that groups are still devices, an=
d
> the patch that adds kvm_io_bus_unregister_dev seems broken with the new=

> locking. No?
>
>  =20
>> Its not like
>> we cant patch the group/item code later to clean it up when the time i=
s
>> right.
>>
>> Regards,
>> -Greg
>>
>>    =20
>
> What's the rush?
>  =20

The patch has been in circulation for weeks, is well tested/reviewed
(and I hope its considered well written), and I want to get on with my
life ;).  Your proposal doesn't change the user->kern ABI, so any
consolidation will be just an internal change to the kernel code only.=20
People can start using the interface today to build things, and we can
fix up the internal code later once your proposals have had a chance to
be shaped after review, etc (which I know from experience can take a
while and change radically though the course ;).

IOW: The only thing waiting does is hide the history of the edit, since
whatever change is proposed is invariably the same amount of work for me
to convert it over.  Its purely a question of whether its folded into
the history or visible as two change records.  Based on that. I don't
see any problem with it just going in now.  Its certainly ready from my
perspective.

So I guess the question is: What's your objection?

(BTW: I am talking about the yet unpublished "v9" which addresses all
your other comments sans the io_bus interface changes.  Will push out
later today)

Regards,
-Greg



--------------enig5ADB63E82FF2DE60D8AB5565
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpDaKQACgkQlOSOBdgZUxl7HwCfbUTssmIjaHDHREUwdgC1Uvdg
pEIAoIxmqVX5hNx9Ely89uNTKXqM1AvJ
=/7h8
-----END PGP SIGNATURE-----

--------------enig5ADB63E82FF2DE60D8AB5565--
