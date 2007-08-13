Return-Path: <linux-kernel-owner+w=401wt.eu-S1030996AbXHMNDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030996AbXHMNDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943265AbXHMINh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:13:37 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34542 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939829AbXHMIN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:13:28 -0400
Message-ID: <46C012A8.2040908@bull.net>
Date: Mon, 13 Aug 2007 10:13:28 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net> <46C00FC1.1070306@qumranet.com>
In-Reply-To: <46C00FC1.1070306@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 10:18:30,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 10:18:32,
	Serialize complete at 13/08/2007 10:18:32
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5333B5AA9AC76FDCEB9D8930"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5333B5AA9AC76FDCEB9D8930
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Laurent Vivier wrote:
>> The aim of these two patches is to measure the CPU time used by a virt=
ual
>> machine. All comments are welcome... I'm not sure it's the good way to=

>> do that.
>>
>> [PATCH 1/2] introduce a new field, "guest", in cpustat to store the
>> time used by
>> the CPU to run virtual CPU. Modify /proc/stat to display this new fiel=
d.
>>
>> [PATCH 2/2] modify account_system_time() to add cputime to
>> cpustat->guest if we
>> are running a VCPU. We add this cputime to  cpustat->user instead of
>> cpustat->system because this part of KVM code is in fact user code
>> although it
>> is executed in the kernel. We duplicate VCPU time between guest and
>> user to
>> allow an unmodified "top(1)" to display correct value. A modified
>> "top(1)" is
>> able to display good cpu user time and cpu guest time by subtracting
>> cpu guest
>> time from cpu user time.
>>  =20
>=20
> [copying Ingo and Rusty]
>=20
> The patches look good.  A couple of comments:
>=20
> - perhaps the new fields should be guarded by a #ifdef CONFIG_HYPERVISO=
R
> (selected by CONFIG_KVM)?  that way the (minor) additional overhead is
> only incurred if it can possibly be used.  I imagine that our canine
> cousin will want to use this as well.

There is also a CONFIG_VIRTUALIZATION and a CONFIG_VIRT_CPU_ACCOUNTING (f=
rom
s390 and powerpc) Which one to use ?

I'm wondering if we can have a more accurate accounting:

- For the moment we add all system time since the previous entering to th=
e VCPU
to the guest time (and I guess there is some real system time in it ???)

- Perhaps we can sum nanoseconds spent in the VCPU and add it to cpustat =
when
these ns are greater than 1 ms ? (I'm trying to make something in this wa=
y)

> - I think that there is per-task accounting of user time and system
> time; that should be extended as well.

it should be easy to do too...

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig5333B5AA9AC76FDCEB9D8930
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGwBKr9Kffa9pFVzwRAqJZAKCxIzVK7c92NSJ5eitJdobVjVosWwCgqBSv
5eIVLJXurjSqJvX2Gx38EIU=
=t4hl
-----END PGP SIGNATURE-----

--------------enig5333B5AA9AC76FDCEB9D8930--
