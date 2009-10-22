Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZJVPOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZJVPOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbZJVPOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:14:47 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:35531 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbZJVPOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=krs9L0R3YuSioImN+LA7d4wRDPLfBb262rQD/FJt2VC3OL88P132wSuzyISbmlSpxi
         k7mffbdVdVSPIJZTQwPNpkwxkNZDRm+YYmkPk0jlLzaLaH4QED47vGzLsZd5aAmRjdsC
         nY0JPCthHdsIS47W1aGbi50Eu/9Kzb/1wOW40=
Message-ID: <4AE076E0.7030100@gmail.com>
Date: Thu, 22 Oct 2009 11:14:40 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [KVM PATCH 1/2] KVM: Directly inject interrupts via irqfd
References: <20091021143042.14955.22470.stgit@dev.haskins.net> <20091021143453.14955.80578.stgit@dev.haskins.net> <20091021152621.GR29477@redhat.com> <4ADF2A1B.3010205@gmail.com> <20091021153640.GS29477@redhat.com> <4ADF2BDD.40706@gmail.com> <4AE07541.8060903@redhat.com>
In-Reply-To: <4AE07541.8060903@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig53AA9D4EF9EDE57F19B2F671"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig53AA9D4EF9EDE57F19B2F671
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/21/2009 05:42 PM, Gregory Haskins wrote:
>> I believe Avi, Michael, et. al. were in agreement with me on that desi=
gn
>> choice.  I believe the reason is that there is no good way to do EOI/A=
CK
>> feedback within the constraints of an eventfd pipe which would be
>> required for the legacy pin-type interrupts.  Therefore, we won't even=

>> bother trying.  High-performance subsystems will use irqfd/msi, and
>> legacy emulation can use the existing injection code (which includes t=
he
>> necessary feedback for ack/eoi).
>>
>>   =20
>=20
> Right.  But we don't actually prevent anyone using non-msi with irqfd,
> which can trigger the bad lock usage from irq context, with a nice boom=

> afterwards.  So we need to either prevent it during registration, or to=

> gracefully handle it afterwards.
>=20

Yeah, I was thinking about that after I initially responded to Gleb.

I am thinking something along these lines:

Provide a function that lets you query a GSI for whether it supports
LOCKLESS or not.  Then we can either do one of two things:

1) Check for the LOCKLESS attribute at irqfd registration, fail if not
present

2) Cache the LOCKLESS attribute in the irqfd structure, and either go
direct or defer to a workqueue depending on the flag.

Thoughts?
-Greg


--------------enig53AA9D4EF9EDE57F19B2F671
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrgduAACgkQP5K2CMvXmqHDmQCfeiPF50jqMNpkgrq0oqrV4VKH
NTIAn2VysMBa5oWQsYH5Xt/M1evGt8Ww
=pAWX
-----END PGP SIGNATURE-----

--------------enig53AA9D4EF9EDE57F19B2F671--
