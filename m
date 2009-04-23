Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZDWQrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZDWQrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZDWQq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:46:58 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:37352 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZDWQq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:46:57 -0400
Message-ID: <49F09B78.7000403@novell.com>
Date: Thu, 23 Apr 2009 12:46:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH 2/3] eventfd: add a notifier mechanism
References: <20090423150910.14094.73708.stgit@dev.haskins.net> <20090423151436.14094.35875.stgit@dev.haskins.net> <alpine.DEB.1.10.0904230922180.18603@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0904230922180.18603@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA4C8D3D84102D26A54819969"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA4C8D3D84102D26A54819969
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Thu, 23 Apr 2009, Gregory Haskins wrote:
>
>  =20
>> This allows synchronous notifications to register with the eventfd
>> infrastructure.  Unlike traditional vfs based eventfd readers, notifie=
es
>> do not implictly clear the counter on reception.  However, the clearin=
g
>> is primarily important to allowing threads to block waiting for events=

>> anyway, so its an acceptable trade-off since blocking doesn't apply to=

>> notifiers.
>>    =20
>
> Do you really need to add a notifier? Eventfd already has a wait queue,=
=20
> and we support callback-based wakeups, so is there any reason we should=
n't=20
> use those and rely on the already existing wakeups?
>  =20
Well, IIUC the issue is that a wait queue implies that you are in fact
waiting...which we may not. :)

The target in this particular application with kvm-irqfd is a vcpu
context, which *may* be sleeping in something like a HLT, but it also
could be in a number of other states such as non-root (guest) mode, it
could be running in the kernel, it could be up in userspace, etc.

That said: I am not married to the concept that this has to be a
notifier callback, but I do want to be able to meet the target
application.  So if there is some way to do that within the existing
wait-queue contstruct, I am open to suggestions.

Thanks Davide,
-Greg

>
>
> - Davide
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enigA4C8D3D84102D26A54819969
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknwm3kACgkQlOSOBdgZUxkw9wCfTl/cwrwkr0v2j+ZkFLuk2InT
ackAoIME19jnipNbGzZF256HaGP0ve8j
=oJgO
-----END PGP SIGNATURE-----

--------------enigA4C8D3D84102D26A54819969--
