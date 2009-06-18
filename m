Return-Path: <linux-kernel-owner+w=401wt.eu-S1761074AbZFRLoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074AbZFRLoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZFRLoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:44:09 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42250 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbZFRLoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:44:08 -0400
Message-ID: <4A3A2879.6080909@novell.com>
Date: Thu, 18 Jun 2009 07:43:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37AEF7.7070203@novell.com> <4A3A02F8.6040301@redhat.com>
In-Reply-To: <4A3A02F8.6040301@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig317FE7E61181A3735E401EFC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig317FE7E61181A3735E401EFC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 06/16/2009 05:40 PM, Gregory Haskins wrote:
>>
>> Something else to consider:  For iosignalfd, we can assume we will
>> always be called from vcpu process context so we might not really need=

>> official affirmation from the system.  For irqfd, we cannot predict wh=
o
>> may be injecting the interrupt (for instance, it might be a
>> PCI-passthrough hard-irq context).  I am not sure if this knowledge
>> actually helps to simplify the problem space, but I thought I should
>> mention it.
>>   =20
>
> We can't assume anything.  Userspace might hand out that eventfd to
> anyone.

Yeah agreed, and I misspoke (mistyped? ;).  It's not that I assume its
from a vcpu.  Its that it doesn't matter (at least for vbus).

The reason is that the memory context is established in vbus via a
different channel (i.e. I never look at "current" in the context of the
eventfd callback).  The eventfd is just telling me that the previously
established memory context needs to be looked at (e.g. the virtio-ring
changed).  Therefore, the origin of the signal doesn't actually matter
(at least w.r.t. safe handling of the request).

Obviously, the question of whether something has really changed in the
memory and whether an errant signal could cause problems is a separate
issue.  But we need to be robust against that anyway, for a multitude of
other reasons (e.g. malicious/broken guest scribbling over the
virtio-ring, etc).

-Greg



--------------enig317FE7E61181A3735E401EFC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko6KHkACgkQlOSOBdgZUxlN6wCfQVhJtK53aQubpLJKkELSyA5n
FTEAnRUeQhWY8PMao8LlyJDCbH7/PdPO
=A4gf
-----END PGP SIGNATURE-----

--------------enig317FE7E61181A3735E401EFC--
