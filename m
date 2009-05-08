Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZEHLaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZEHLaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZEHL3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:29:55 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:7170 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZEHL3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=F75QTwhsbK/At2PR+9oDRU0DEgjz8zQLHqFfTjqvIwvhc1M01S61W+fXUsvkZmq+0N
         uEl020XDDlH7Arcx5johMDxS5LTRXKz9r4tt8nsN/BsuNNkN7tsuUdfbBpWu6/I2ZdPg
         11v8+k+dZgOOkm8u4db1JAZ9AmDb4k5DgLPDA=
Message-ID: <4A04179E.5040504@gmail.com>
Date: Fri, 08 May 2009 07:29:34 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <4A033101.8050106@gmail.com> <4A0339D2.3050600@redhat.com> <4A033F6E.3010604@novell.com> <4A03416D.8020405@redhat.com> <4A0343F5.5070509@gmail.com> <4A03EEDA.5090008@redhat.com>
In-Reply-To: <4A03EEDA.5090008@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0FA0FE1AB39184586A830BE1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0FA0FE1AB39184586A830BE1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>
>  =20
>>>> Ack.  I hope when its all said and done I can convince you that the
>>>> framework to code up those virtio backends in the kernel is vbus ;)
>>>>      =20
>>> If vbus doesn't bring significant performance advantages, I'll prefer=

>>> virtio because of existing investment.
>>>    =20
>>
>> Just to clarify: vbus is just the container/framework for the in-kerne=
l
>> models.  You can implement and deploy virtio devices inside the
>> container (tho I haven't had a chance to sit down and implement one
>> yet).  Note that I did publish a virtio transport in the last few seri=
es
>> to demonstrate how that might work, so its just ripe for the picking i=
f
>> someone is so inclined.
>>
>>  =20
>
> Yeah I keep getting confused over this.
>
>> So really the question is whether you implement the in-kernel virtio
>> backend in vbus, in some other framework, or just do it standalone.
>>  =20
>
> I prefer the standalone model.  Keep the glue in userspace.

Just to keep the facts straight:  The glue in userspace vs standalone
model are independent variables.  E.g. you can have the glue in
userspace for vbus, too.  Its not written that way today for KVM, but
its moving in that direction as we work though these subtopics like
irqfd, dynhc, etc.

What vbus buys you as a core technology is that you can write one
backend that works "everywhere" (you only need a glue layer for each
environment you want to support).  You might say "I can make my backends
work everywhere too", and to that I would say "by the time you get it to
work, you will have duplicated almost my exact effort on vbus" ;).  Of
course, you may also say "I don't care if it works anywhere else but
KVM", which is a perfectly valid (if not unfortunate) position to take.

I think the confusion point is possibly a result of the name "vbus".=20
The vbus core isn't really true bus in the traditional sense.  It's just
a host-side kernel-based container for these device models.  That is all
I am talking about here.  There is, of course, also an LDM "bus" for
rendering vbus devices in the guest as a function of the current
kvm-specific glue layer Ive written.  Note that this glue layer could
render them as PCI in the future, TBD.

-Greg



--------------enig0FA0FE1AB39184586A830BE1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoEF54ACgkQP5K2CMvXmqHSmQCfXt0yOx/NJZZe54tMiwQplhHF
WWoAn3h/2f0w3wfji9BsNXlWRodAmryZ
=Sl9q
-----END PGP SIGNATURE-----

--------------enig0FA0FE1AB39184586A830BE1--
