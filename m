Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZLWRev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZLWRev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZLWReu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:34:50 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:64715 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449AbZLWRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=IVo2vW5NmdQCQCoD8a77UIo6i0YWwDAf1YJtdVgBnxo0wJq2ooOqw9+tIjFQYkCLrp
         XdZjgnEMtGtC0jLelH0EZk3AGg8V7ba6fESThz8lO9Wgza9rW2WfMpw29U2F7IDd81fK
         4+Qp6DrgAZi65E9D0Bsif602N9cB8UnbM1+uQ=
Message-ID: <4B3254B4.2080602@gmail.com>
Date: Wed, 23 Dec 2009 12:34:44 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> 	<4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> 	<4B3103B4.4070708@gmail.com> <f73f7ab80912222215i39ba865dv95764f95fd57bd96@mail.gmail.com>
In-Reply-To: <f73f7ab80912222215i39ba865dv95764f95fd57bd96@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8D89DAD9F03F2957BA21E5D8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8D89DAD9F03F2957BA21E5D8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/23/09 1:15 AM, Kyle Moffett wrote:
> On Tue, Dec 22, 2009 at 12:36, Gregory Haskins
> <gregory.haskins@gmail.com> wrote:
>> On 12/22/09 2:57 AM, Ingo Molnar wrote:
>>> * Gregory Haskins <gregory.haskins@gmail.com> wrote:
>>>> Actually, these patches have nothing to do with the KVM folks. [...]=

>>>
>>> That claim is curious to me - the AlacrityVM host
>>
>> It's quite simple, really.  These drivers support accessing vbus, and
>> vbus is hypervisor agnostic.  In fact, vbus isn't necessarily even
>> hypervisor related.  It may be used anywhere where a Linux kernel is t=
he
>> "io backend", which includes hypervisors like AlacrityVM, but also
>> userspace apps, and interconnected physical systems as well.
>>
>> The vbus-core on the backend, and the drivers on the frontend operate
>> completely independent of the underlying hypervisor.  A glue piece
>> called a "connector" ties them together, and any "hypervisor" specific=

>> details are encapsulated in the connector module.  In this case, the
>> connector surfaces to the guest side as a pci-bridge, so even that is
>> not hypervisor specific per se.  It will work with any pci-bridge that=

>> exposes a compatible ABI, which conceivably could be actual hardware.
>=20
> This is actually something that is of particular interest to me.  I
> have a few prototype boards right now with programmable PCI-E
> host/device links on them; one of my long-term plans is to finagle
> vbus into providing multiple "virtual" devices across that single
> PCI-E interface.
>=20
> Specifically, I want to be able to provide virtual NIC(s), serial
> ports and serial consoles, virtual block storage, and possibly other
> kinds of interfaces.  My big problem with existing virtio right now
> (although I would be happy to be proven wrong) is that it seems to
> need some sort of out-of-band communication channel for setting up
> devices, not to mention it seems to need one PCI device per virtual
> device.
>=20
> So I would love to be able to port something like vbus to my nify PCI
> hardware and write some backend drivers... then my PCI-E connected
> systems would dynamically provide a list of highly-efficient "virtual"
> devices to each other, with only one 4-lane PCI-E bus.

Hi Kyle,

We indeed have others that are doing something similar.  I have CC'd Ira
who may be able to provide you more details.  I would also point you at
the canonical example for what you would need to write to tie your
systems together.  Its the "null connector", which you can find here:

http://git.kernel.org/?p=3Dlinux/kernel/git/ghaskins/alacrityvm/linux-2.6=
=2Egit;a=3Dblob;f=3Dkernel/vbus/connectors/null.c;h=3Db6d16cb68b7e49e0752=
8278bc9f5b73e1dac0c2f;hb=3DHEAD

Do not hesitate to ask any questions, though you may want to take the
conversation to the alacrityvm-devel list as to not annoy the current CC
list any further than I already have ;)

Kind Regards,
-Greg


--------------enig8D89DAD9F03F2957BA21E5D8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksyVLQACgkQP5K2CMvXmqGUDgCfZxDJeTqKiX3y9Fpz3RURVy1v
YrcAnRdSSj3nnbmYYnC/PH4jk67Gl4GL
=XpWp
-----END PGP SIGNATURE-----

--------------enig8D89DAD9F03F2957BA21E5D8--
