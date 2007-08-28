Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbXH1Klu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbXH1Klu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXH1Kln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:41:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:35014 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbXH1Klm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=Qx/luwyKrYUCDQvKLhd9OeJmD/nOO50SGXwwyzIs3gp+reus2dpL3LF+ZBZXKzkYFogLyIbZVXHB1YjTqPANNcUgwdEzIC2rw8RmaUsUX0+1Yz84pRfDoyoWfapyS2bRfry+La5yFCihOkiSnGyQlT7WdRnIuuje1BiOCz9+x8w=
Message-ID: <46D3FBDF.3080508@gmail.com>
Date: Tue, 28 Aug 2007 12:41:35 +0200
From: Luka Napotnik <luka.napotnik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: division and cpu usage
References: <46CE1BA2.8070200@gmail.com> <Pine.LNX.4.61.0708240731130.8096@chaos.analogic.com> <Pine.LNX.4.64.0708241442590.28540@fbirervta.pbzchgretzou.qr> <46D34B19.6050006@gmail.com> <Pine.LNX.4.64.0708280843030.11442@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708280843030.11442@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig18546FCE5C39018693C97224"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig18546FCE5C39018693C97224
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

How about this:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
old_stime =3D task->stime;
old_utime =3D task->utime
old_j =3D jiffies;

set_current_state(TASK_INTERRUPTIBLE);
schedule_timeout(1 * HZ);

new_stime =3D task->stime;
new_utime =3D task->utime;
new_j =3D jiffies;
sum =3D ((new_stime - old_stime) + (new_utime - old_utime)) * 100 / (new_=
j
- old_j)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

I get how much time the task has spent in 1 sec in the scheduler and
then get the percentage?

Greets,
Luka

Jan Engelhardt pravi:
> On Aug 28 2007 00:07, Luka Napotnik wrote:
>>>>> 2. I'm trying to get the percentage of CPU used for a certain
>>>>> task_struct and figured the following formula:
>>>>>
>>>>> (task->utime + task->stime) / jiffies
>> This formula just doesn't work. I have a task with 99% CPU (top) but t=
he
>> result of that formula is random (4, sometimes 8). What am I doing
>> wrong? Please help.
>=20
> You are calculating the CPU time the process has used since the start.
> That is definitely not the same as the "%CPU" that top shows, more like=

> the "TIME+" top shows by default.
>=20
>=20



--------------enig18546FCE5C39018693C97224
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG0/vkkO3xBWVRX08RArOdAKCFvqpRiD+gb/EjeeTqV3onoT2lmACfYhU2
ZWhelJMWmtFKAdIjvWCFo9c=
=NaHD
-----END PGP SIGNATURE-----

--------------enig18546FCE5C39018693C97224--
