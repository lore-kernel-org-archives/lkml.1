Return-Path: <linux-kernel-owner+w=401wt.eu-S965269AbXIJQCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965269AbXIJQCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbXIJQBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:01:54 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45827 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXIJQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:01:53 -0400
Message-ID: <46E56A5E.20209@bull.net>
Date: Mon, 10 Sep 2007 18:01:34 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 3/4] modify account_system_time() to update
 guest time in cpustat and task_struct
References: <46E550EA.1030809@bull.net> <20070910085331.84dc1fb5.randy.dunlap@oracle.com>
In-Reply-To: <20070910085331.84dc1fb5.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 18:07:33,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 18:07:34,
	Serialize complete at 10/09/2007 18:07:34
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6B587C2B6FC41441AB9E628C"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6B587C2B6FC41441AB9E628C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Randy Dunlap wrote:
> On Mon, 10 Sep 2007 16:12:58 +0200 Laurent Vivier wrote:
>=20
>> [PATCH 3/4] modify account_system_time() to add cputime to cpustat->gu=
est if we
>> are running a VCPU. We add this cputime to  cpustat->user instead of
>> cpustat->system because this part of KVM code is in fact user code alt=
hough it
>> is executed in the kernel. We duplicate VCPU time between guest and us=
er to
>> allow an unmodified "top(1)" to display correct value. A modified "top=
(1)" is
>> able to display good cpu user time and cpu guest time by subtracting c=
pu guest
>> time from cpu user time. Update "gtime" in task_struct accordingly.
>>
>> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
>=20
>=20
> Hi,
> Please use kernel-doc notation here:
> (see Documentation/kernel-doc-nano-HOWTO.txt or source file examples
> or ask)
>=20
> easy fix:
>=20
>  /*
> + * Account guest cpu time to a process.
>=20
> /**
>  * account_guest_time - Account guest cpu time to a process.
>=20
> + * @p: the process that the cpu time gets accounted to
> + * @cputime: the cpu time spent in virtual machine since the last upda=
te
> + */
> +void account_guest_time(struct task_struct *p, cputime_t cputime)
> +{

thank you for the comment.

But I just made a cut&past of the comment of the function above.

Should I be consistent with the doc or with the source ?

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig6B587C2B6FC41441AB9E628C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFG5Wpi9Kffa9pFVzwRApZBAJwPbbL2quNUMGAAe87dEyMQDxCgxQCgx1bh
kO+4N1neavWkNbD2ziS5Mw0=
=sVd5
-----END PGP SIGNATURE-----

--------------enig6B587C2B6FC41441AB9E628C--
