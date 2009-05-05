Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbZEERfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbZEERfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZEEReu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:34:50 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55689 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZEEReu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:34:50 -0400
Message-ID: <4A0078B5.7030509@novell.com>
Date: Tue, 05 May 2009 13:34:45 -0400
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
 boundary="------------enigE95B3931FB0CE5443C7463AD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE95B3931FB0CE5443C7463AD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> KVM provides a complete virtual system environment for guests, includi=
ng
>> support for injecting interrupts modeled after the real
>> exception/interrupt
>> facilities present on the native platform (such as the IDT on x86).
>> Virtual interrupts can come from a variety of sources (emulated device=
s,
>> pass-through devices, etc) but all must be injected to the guest via
>> the KVM infrastructure.  This patch adds a new mechanism to inject a
>> specific
>> interrupt to a guest using a decoupled eventfd mechnanism:  Any legal
>> signal
>> on the irqfd (using eventfd semantics from either userspace or
>> kernel) will
>> translate into an injected interrupt in the guest at the next availabl=
e
>> interrupt window.
>>
>> =20
>> +struct kvm_irqfd {
>> +    __u32 gsi;
>> +    __u32 flags;
>> +};
>> +
>>  =20
>
> Please add some reserved space here.

Ack.  Any rule of thumb here?  How about a "__u8 pad[16]" ?

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

Good catch.  Will fix.

Thanks Avi,
-Greg



--------------enigE95B3931FB0CE5443C7463AD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoAeLUACgkQlOSOBdgZUxmvbwCcDl85FCaMfMjJLTAqImxn1vvy
uPwAmwUujtd/j9GAYplLZiOoziOxRpNu
=YjR9
-----END PGP SIGNATURE-----

--------------enigE95B3931FB0CE5443C7463AD--
