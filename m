Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZJUPmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZJUPmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZJUPmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:42:23 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:48533 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZJUPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=NnGsVjLEKmbqzfjIqR3XK1UGTUEV+qoIu1TARmZWnpStAQrkxFUy6GpVFHVYE+hO6z
         tYtKjyeMYhCiqDIIxe0IHOkwc4XTl/ns0O6E4DaKIkDS0Lomrwe+MztB/QS4Y/vMA0RN
         1sgzwONdioqepXZa5tJMcwm8qGxJe1vaZ/l4A=
Message-ID: <4ADF2BDD.40706@gmail.com>
Date: Wed, 21 Oct 2009 11:42:21 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [KVM PATCH 1/2] KVM: Directly inject interrupts via irqfd
References: <20091021143042.14955.22470.stgit@dev.haskins.net> <20091021143453.14955.80578.stgit@dev.haskins.net> <20091021152621.GR29477@redhat.com> <4ADF2A1B.3010205@gmail.com> <20091021153640.GS29477@redhat.com>
In-Reply-To: <20091021153640.GS29477@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDF9F1B9CA30E874C93BE7685"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDF9F1B9CA30E874C93BE7685
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gleb Natapov wrote:
> On Wed, Oct 21, 2009 at 11:34:51AM -0400, Gregory Haskins wrote:
>> Gleb Natapov wrote:
>>> On Wed, Oct 21, 2009 at 10:34:53AM -0400, Gregory Haskins wrote:
>>>> IRQFD currently uses a deferred workqueue item to execute the inject=
ion
>>>> operation.  It was originally designed this way because kvm_set_irq(=
)
>>>> required the caller to hold the irq_lock mutex, and the eventfd call=
back
>>>> is invoked from within a non-preemptible critical section.
>>>>
>>>> With the advent of lockless injection support in kvm_set_irq, the de=
ferment
>>>> mechanism is no longer technically needed. Since context switching t=
o the
>>>> workqueue is a source of interrupt latency, lets switch to a direct
>>>> method.
>>>>
>>> kvm_set_irq is fully lockless only in MSI case. IOAPIC/PIC has mutexe=
s.
>> Right, but irqfd by design only works with MSI (or MSI like edge
>> triggers) anyway.  Legacy-type injections follow a different path.
>>
> Ah, If this the case and it will stay that way then the change looks OK=

> to me.


I believe Avi, Michael, et. al. were in agreement with me on that design
choice.  I believe the reason is that there is no good way to do EOI/ACK
feedback within the constraints of an eventfd pipe which would be
required for the legacy pin-type interrupts.  Therefore, we won't even
bother trying.  High-performance subsystems will use irqfd/msi, and
legacy emulation can use the existing injection code (which includes the
necessary feedback for ack/eoi).

To that point, perhaps it should be better documented.  If we need a v2,
I will add a comment.

Kind Regards,
-Greg


--------------enigDF9F1B9CA30E874C93BE7685
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrfK90ACgkQP5K2CMvXmqEqgwCffAjYnu8/B0DuUtSHQ2Ofraua
qXEAmgPvTRrDAOTdcK9vZ7vVaGVeWa41
=O3vw
-----END PGP SIGNATURE-----

--------------enigDF9F1B9CA30E874C93BE7685--
