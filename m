Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZJZNZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZJZNZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZJZNZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:25:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:37941 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZJZNZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=tAd6ewNuf+vS2PSOxCntB34Gz4M/j/pjABQ1D+9zWl5uAdFFxLXTJbsk/XrurCB1eP
         wLDJNfbn0OUOZNbwdeNNeKh5oDH2B3VIU1/j7TEvvKkRHPWuAnYNI4/EGBjvBEIAehas
         CNtAj1oI/YTCWDB7nbFvsr5xkjwYX9nN1vD1E=
Message-ID: <4AE5A336.4010801@gmail.com>
Date: Mon, 26 Oct 2009 09:25:10 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [Alacrityvm-devel] [KVM PATCH v2 1/2] KVM: export lockless GSI
 attribute
References: <20091023023512.3891.65889.stgit@dev.haskins.net>	<20091023023845.3891.36857.stgit@dev.haskins.net> <4AE460F4.2090905@redhat.com>
In-Reply-To: <4AE460F4.2090905@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE57E2CB4BDDF16FE83E4824D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE57E2CB4BDDF16FE83E4824D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/23/2009 04:38 AM, Gregory Haskins wrote:
>> Certain GSI's support lockless injecton, but we have no way to detect
>> which ones at the GSI level.  Knowledge of this attribute will be
>> useful later in the series so that we can optimize irqfd injection
>> paths for cases where we know the code will not sleep.  Therefore,
>> we provide an API to query a specific GSI.
>>
>>   =20
>=20
> Instead of a lockless attribute, how about a ->set_atomic() method.  Fo=
r=20
> msi this can be the same as ->set(), for non-msi it can be a function=20
> that schedules the work (which will eventually call ->set()).
>=20
> The benefit is that we make a decision only once, when preparing the=20
> routing entry, and install that decision in the routing entry instead o=
f=20
> making it again and again later.

Yeah, I like this idea.  I think we can also get rid of the custom
workqueue if we do this as well, TBD.

>=20
>> +int kvm_irq_check_lockless(struct kvm *kvm, u32 irq)
>>   =20
>=20
> bool kvm_irq_check_lockless(...)

We lose the ability to detect failure (such as ENOENT) if we do this,
but its moot if we move to the ->set_atomic() model, since this
attribute is no longer necessary and this patch can be dropped.

Kind Regards,
-Greg


--------------enigE57E2CB4BDDF16FE83E4824D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrlozYACgkQP5K2CMvXmqHZwgCeLTEG8lKeRLjeurJiwL2vsltQ
ajYAn0TBRYQfsKEt8V8+FXq7dK4/yhQT
=+xg4
-----END PGP SIGNATURE-----

--------------enigE57E2CB4BDDF16FE83E4824D--
