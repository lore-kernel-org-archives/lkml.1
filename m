Return-Path: <linux-kernel-owner+w=401wt.eu-S1031570AbXHMQBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031570AbXHMQBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031702AbXHMOWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:22:50 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56397 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031670AbXHMOWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:22:48 -0400
Message-ID: <46C0693A.1080900@bull.net>
Date: Mon, 13 Aug 2007 16:22:50 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kvm-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, cotte@de.ibm.com
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net> <200708131605.40479.borntraeger@de.ibm.com>
In-Reply-To: <200708131605.40479.borntraeger@de.ibm.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 16:27:52,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 16:27:53,
	Serialize complete at 13/08/2007 16:27:53
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig17F904F63489DD33255C7245"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig17F904F63489DD33255C7245
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christian Borntraeger wrote:
> Am Freitag, 10. August 2007 schrieb Laurent Vivier:
>> The aim of these two patches is to measure the CPU time used by a virt=
ual
>> machine. All comments are welcome... I'm not sure it's the good way to=
 do=20
> that.
>=20
> I did something similar for or s390guest prototype, that Carsten posted=
 in=20
> May.  I decided to account guest time to the user process instead of ad=
ding a=20
> new field to avoid hazzle with old top. As you can read in the patch co=
mment,=20
> I personally prefer a new field if we can get one.
>=20
> My implementation uses a similar mechanism like hard and softirq. So I =
have an=20
> sie_enter an sie_exit and a task_is_in_sie function - like irq_enter an=
d=20
> irq_exit. The main difference is based on the fact, that s390 has preci=
se=20
> accouting for irq, steal, user and system time, and therefore my patch =
is=20
> based on architecture specifc code using CONFIG_VIRT_CPU_ACCOUNT.=20
>=20
> In general my patch has the same idea as your patch, so I am going to r=
eview=20
> your patch and see if it would fit for s390.
>=20
> For reference this is the (never posted) old patch for our virtualisati=
on=20
> prototype. It wont work with kvm but it gives you the idea what we had =
in=20
> mind on s390.
>=20

thank you for your comment.

As virtualization becomes very popular, perhaps we should implement somet=
hing
which could be used by all linux supported architectures ?
(yes, I know it's non-sense for archs like m68k...)
But my [PATCH 1/2] can be a good start (adding "guest" in cpustat)
As guest accounting is hw dependent, I think we should add a hook in the
accounting functions.

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig17F904F63489DD33255C7245
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGwGk+9Kffa9pFVzwRAjcQAJ9KWtGGM50u/4sypi4myGY7IJyA6wCgoBNC
+GNRE5w60CEhMhMt6gXHn5Y=
=bPBU
-----END PGP SIGNATURE-----

--------------enig17F904F63489DD33255C7245--
