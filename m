Return-Path: <linux-kernel-owner+w=401wt.eu-S1764562AbXJOM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764562AbXJOM3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbXJOM3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:29:34 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39860 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbXJOM3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:29:33 -0400
Message-ID: <47135D1B.1060004@bull.net>
Date: Mon, 15 Oct 2007 14:29:15 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time	accounting.
References: <46E550EF.5080209@bull.net> <20071015093800.GA22818@elte.hu> <47133732.2090809@qumranet.com> <20071015095125.GB28367@elte.hu> <47133ABD.8050608@qumranet.com> <471346B0.8050102@bull.net> <47134BCE.1080306@qumranet.com> <4713510D.2050208@bull.net> <471357E4.90904@qumranet.com>
In-Reply-To: <471357E4.90904@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 14:35:56,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 14:35:57,
	Serialize complete at 15/10/2007 14:35:57
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4161246FB6E8FABA8B54137B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4161246FB6E8FABA8B54137B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Laurent Vivier wrote:
>=20
> =20
>=20
>>> But if we didn't get an interrupt in that time?
>>>
>>> We can clear it a bit later, after local_irq_enable() in
>>> __vcpu_run(). However we need a nop instruction first because "sti"
>>> keeps interrupts
>>> disabled for one more instruction.
>>>    =20
>>
>> IMHO, I think it is better to let kvm_guest_exit() empty (you can
>> remove it, if
>> you want):
>>
>> 1st case:
>> - unset PF_VCPU in kvm_guest_exit(), all the tick is always for system=

>> time.
>> Guest time is always 0.
>>
>> 1st case and half:
>>
>> - like 1st case but we move kvm_guest_exit() as you propose and the
>> reason of
>> the interrupt is the tick interrupt. The tick is for guest time only.
>> I think
>> the probability is very low.
>>  =20
>=20
> If the guest is executing for 10% of the time, the probability is
> exactly 10%, no?

I think you know that better than me.

But is there homogeneity in probability ?

I mean, if the guest has a lot I/O, it is interrupted by them and the
probability to be interrupted by a tick is lower than the time passed in =
the VCPU ?

>> 2nd case:
>> - don't unset PF_VCPU in kvm_guest_exit(), all the tick is for guest
>> time.
>>  =20
>=20
> But then even execution in ->handle_exit() is accounted as guest time,
> which is wrong.

System time and User time are wrong too as the tick is accounted to the s=
ide
where it appears, even if CPU has executed code from the other side in a
sub-part of the tick. It's not a good argument.

Laurent
--=20
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond


--------------enig4161246FB6E8FABA8B54137B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFHE10e9Kffa9pFVzwRAoSKAJ9i2XPAQAuZklSlISLRkxoR8yFK4gCgy16h
dGfXIlBB/x7IaNyQ5s2DiZk=
=iIIG
-----END PGP SIGNATURE-----

--------------enig4161246FB6E8FABA8B54137B--
