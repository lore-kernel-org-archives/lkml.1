Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbXHUHq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbXHUHq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbXHUHp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:45:57 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42721 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbXHUHpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:45:51 -0400
Message-ID: <46CA9831.4080309@bull.net>
Date: Tue, 21 Aug 2007 09:45:53 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, John Stoffel <john@stoffel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: =?ISO-8859-1?Q?R=E9f=2E_=3A_Re=3A_=5BPATCH_0/4=5D_?=
 =?ISO-8859-1?Q?Virtual_Machine_Time_Accounting?=
References: <OF945F7B1F.FF4B4672-ONC125733D.006266E7-C125733D.00626843@frec.bull.fr> <5d6222a80708201334q27fc6cbcr7ce6a9d7147437a2@mail.gmail.com>
In-Reply-To: <5d6222a80708201334q27fc6cbcr7ce6a9d7147437a2@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/08/2007 09:51:05,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/08/2007 09:51:06,
	Serialize complete at 21/08/2007 09:51:06
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4E28FF2019D37A8E3FBFDFA8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4E28FF2019D37A8E3FBFDFA8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Glauber de Oliveira Costa wrote:
>> by doing this at kernel level, we can:
>> - measure exactly the guest time,
>> - move this part of system time to user time (as you think it should b=
e
>> user time),
>> - have consistency between system, user and guest time,
>> - report values in /proc/state and /proc/<pid>/state, at system wide l=
evel
>>
>> I'm not sure we can measure the guest time at the qemu user level.
>>
>> Perhaps Rusty can say what he thinks about this ?
>>
> Even if we cannot _now_, isn't that an easier, and safer change? (and
> I don't think we lose anything by design).

Could you explain ? How should I do this ?
I'm _sure_ it is not easier to do that at qemu level.

I don't like to patch kernel (it is the last thing I do to solve a proble=
m: I
know there is always at least one guy to not agree the patch :-P ) but in=
 this
case I think this is the best way to do that.

I think the virtualization notion should be introduced at the kernel leve=
l, at
least in the kernel statistics: it is generic, it can be used by other
virtualization tools. As I said, until know CPUs have got only two states=

reflected in statistics by "user time" and "system time". Since recently,=
 they
have introduced a third state, the virtual CPU, that, in my opinion, shou=
ld be
also reflected in the CPU statistics as the "guest time".

>=20
> Although I don't know KVM to a that deep level, I think it should be
> possible to keep the virtual cpus in different process (or threads),
> and take the accounting time from there. Perfectly possible to know
> the time we spent running (user time), and the time the hypervisor
> spent doing things on our behalf (system time).

But we have always user time accounted as system time. CPU stats are wron=
g if we
do not modify the kernel. Can you live with wrong statistics ? (yes, I th=
ink,
you can, but perhaps someone else not)

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig4E28FF2019D37A8E3FBFDFA8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGypg19Kffa9pFVzwRAh/rAJ4gRO+jIoCW3YunaSuWka1NIDRGTACfYcPO
ITXJR0IHlYzs5DNekLzHEaA=
=kv8o
-----END PGP SIGNATURE-----

--------------enig4E28FF2019D37A8E3FBFDFA8--
