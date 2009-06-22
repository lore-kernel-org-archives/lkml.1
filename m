Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZFVTWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZFVTWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbZFVTWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:22:16 -0400
Received: from mail-pz0-f182.google.com ([209.85.222.182]:49720 "EHLO
	mail-pz0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199AbZFVTWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:22:14 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 15:22:14 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=hk/3HqSzabFdSHevlykM9Ef5Tm2Ol/IJXvZ1LO44S6tZaoEjIJRVjKkP4esmvYs5fo
         oC23U1DXe8sPruja8KbzwzQwEG0EiKuUOMTbr3+CQNQWh1c+lRv2mtjXog7chtPJlecW
         uc+gO4M4PaiAqVRP1frEXLTcq7RNI5bZC/yUg=
Message-ID: <4A3FD89A.8080809@gmail.com>
Date: Mon, 22 Jun 2009 15:16:42 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig060E1F4B4B1897791689DB5D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig060E1F4B4B1897791689DB5D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Mon, 22 Jun 2009, Michael S. Tsirkin wrote:
>
>  =20
>> On Mon, Jun 22, 2009 at 11:03:22AM -0700, Davide Libenzi wrote:
>>    =20
>>> In your case of kernel-to-kernel scenario, why would you need eventfd=
 at=20
>>> all, if userspace role in that model is simply to create it?
>>>      =20
>> That's not 100% true. We have a mode where userspace is the producer
>> and/or consumer (migration mode) and we switch between that and
>> direct kernel-to-kernel communication.
>>    =20
>
> Then you'd need to ask yourself how to handle your complex case inside =
the=20
> KVM code, so that other eventfd users are not affected by the extra fat=
=20
> needed to handle your scenarios. Thing that seem to be continuosly trie=
d.
> A file* based kernel-to-kernel interface is rather wrong IMO.
>  =20

Well, I will point out that the interface in question is
eventfd_signal(struct file *), and you were the one that invented it
afaict.  Can't help it if we like it :)

BTW: The termination point of that call is incidental.  Afterall, it
works the same for kernel-kernel or kernel-userspace.  The only relevant
discussion point here is that your proposal breaks POLLHUP for
eventfd_signal() users, and we have a real use case that cares.

Let me ask the question a different way: Lets say we all agree that
eventfd_signal() cannot be file* based to be correct.  Is there a way
you can think of that satisfies both the need to get rid of file* AND
still deliver producer-release notification to consumers.  Ultimately
that is all I care about.

-Greg



--------------enig060E1F4B4B1897791689DB5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/2JoACgkQP5K2CMvXmqGr0gCeK2kQyNY+o1cDVphkjt+AJ3K9
1FQAn2TlKwTs4ZJcs46nfFxMvJ0j7Kxe
=NEZm
-----END PGP SIGNATURE-----

--------------enig060E1F4B4B1897791689DB5D--
