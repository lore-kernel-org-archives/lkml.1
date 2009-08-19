Return-Path: <linux-kernel-owner+w=401wt.eu-S1751361AbZHSFgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbZHSFgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 01:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZHSFgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 01:36:49 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:21351 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZHSFgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 01:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=FRXh/tB9VQDPxNmhwTFanAsQ0XdNLEv039+wt8j/SiXUQLZGtYY2xSHw/D+sY4cJhW
         L8OobNRNqOM1e7uAzSz6/5T6iOvO4JV8liiYL3DZEYLAHPchP/drEzzqWWV8cl883YR+
         cnUn0pkGnCV1zXjTzswaMh8R+Mw/iymQQU7Gg=
Message-ID: <4A8B8F6D.9050306@gmail.com>
Date: Wed, 19 Aug 2009 01:36:45 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for vbus_driver
 objects
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <4A8A674E.8070200@redhat.com> <4A8ABEC9.6090006@gmail.com> <200908182020.11126.arnd@arndb.de>
In-Reply-To: <200908182020.11126.arnd@arndb.de>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig50273F24AE0283E955F43A1B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig50273F24AE0283E955F43A1B
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann wrote:
> On Tuesday 18 August 2009, Gregory Haskins wrote:
>> Avi Kivity wrote:
>>> On 08/17/2009 10:33 PM, Gregory Haskins wrote:
>>>
>>> One point of contention is that this is all managementy stuff and sho=
uld
>>> be kept out of the host kernel.  Exposing shared memory, interrupts, =
and
>>> guest hypercalls can all be easily done from userspace (as virtio
>>> demonstrates).  True, some devices need kernel acceleration, but that=
's
>>> no reason to put everything into the host kernel.
>> See my last reply to Anthony.  My two points here are that:
>>
>> a) having it in-kernel makes it a complete subsystem, which perhaps ha=
s
>> diminished value in kvm, but adds value in most other places that we a=
re
>> looking to use vbus.
>>
>> b) the in-kernel code is being overstated as "complex".  We are not
>> talking about your typical virt thing, like an emulated ICH/PCI chipse=
t.
>>  Its really a simple list of devices with a handful of attributes.  Th=
ey
>> are managed using established linux interfaces, like sysfs/configfs.
>=20
> IMHO the complexity of the code is not so much of a problem. What I
> see as a problem is the complexity a kernel/user space interface that
> manages a the devices with global state.
>=20
> One of the greatest features of Michaels vhost driver is that all
> the state is associated with open file descriptors that either exist
> already or belong to the vhost_net misc device. When a process dies,
> all the file descriptors get closed and the whole state is cleaned
> up implicitly.
>=20
> AFAICT, you can't do that with the vbus host model.

It should work the same.  When a driver opens a vbus device, it calls
"interface->connect()" and gets back a "connection" object.  The
connection->release() method is invoked when the driver "goes away",
which would include the scenario you present.  This gives the
device-model the opportunity to cleanup in the same way.


>=20
>>> What performance oriented items have been left unaddressed?
>> Well, the interrupt model to name one.
>=20
> The performance aspects of your interrupt model are independent
> of the vbus proxy, or at least they should be. Let's assume for
> now that your event notification mechanism gives significant
> performance improvements (which we can't measure independently
> right now). I don't see a reason why we could not get the
> same performance out of a paravirtual interrupt controller
> that uses the same method, and it would be straightforward
> to implement one and use that together with all the existing
> emulated PCI devices and virtio devices including vhost_net.

Agreed.  I proposed this before and Avi rejected the idea.

-Greg


--------------enig50273F24AE0283E955F43A1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqLj20ACgkQP5K2CMvXmqGhVACggTZoIKkRQcAfmIU3y/qxfaQP
2JUAoIQWTHDn6ENFLqcWDVhQEqnpmLyz
=CVif
-----END PGP SIGNATURE-----

--------------enig50273F24AE0283E955F43A1B--
