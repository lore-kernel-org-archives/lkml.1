Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZEER5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZEER5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZEER4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:56:55 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33375 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZEER4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:56:54 -0400
Message-ID: <4A007DDA.5000302@novell.com>
Date: Tue, 05 May 2009 13:56:42 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A005F05.30409@redhat.com>
In-Reply-To: <4A005F05.30409@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8406AA151DE63FDE9D82D1B2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8406AA151DE63FDE9D82D1B2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>
>> +int
>> +kvm_irqfd(struct kvm *kvm, int gsi, int flags)
>> +{
>> +    struct _irqfd *irqfd;
>> +    struct file *file =3D NULL;
>> +    int fd =3D -1;
>> +    int ret;
>> +
>> +    irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
>> +    if (!irqfd)
>> +        return -ENOMEM;
>> +
>> +    irqfd->kvm =3D kvm;
>>  =20
>
> You need to increase the refcount on struct kvm here.  Otherwise evil
> userspace will create an irqfd, close the vm and vcpu fds, and inject
> an interrupt.

I just reviewed the code in prep for v5, and now I remember why I didnt
take a reference:  I designed it the opposite direction:  the vm-fd owns
a reference to the irqfd, and will decouple the kvm context from the
eventfd on shutdown  (see kvm_irqfd_release()).   I still need to spin a
v5 regardless in order to add the padding as previously discussed.  But
let me know if you still see any holes in light of this alternate object
lifetime approach I am using.

-Greg



--------------enig8406AA151DE63FDE9D82D1B2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoAfdoACgkQlOSOBdgZUxkVZACeLHaDzq4IHpj9NF2YcLEByErG
hxMAoIyCIdUcV4sRdKbdQ2pJFIBtIOrk
=DAz8
-----END PGP SIGNATURE-----

--------------enig8406AA151DE63FDE9D82D1B2--
