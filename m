Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbXHTOjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbXHTOjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXHTOjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:39:41 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48604 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbXHTOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:39:40 -0400
Message-ID: <46C9A7AB.1030003@bull.net>
Date: Mon, 20 Aug 2007 16:39:39 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
Cc: Ingo Molnar <mingo@elte.hu>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] Virtual Machine Time Accounting
References: <46C99371.7070705@bull.net> <18121.39541.790665.686081@stoffel.org>
In-Reply-To: <18121.39541.790665.686081@stoffel.org>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 16:44:50,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 16:44:53,
	Serialize complete at 20/08/2007 16:44:53
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7C4697859CD76F6581AFFD24"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7C4697859CD76F6581AFFD24
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

John Stoffel wrote:
>=20
> Laurent> The aim of these four patches is to introduce Virtual Machine
> Laurent> time accounting.
>=20
> So what does this buy us?  What increased functionality? =20
>=20

functionnalities:

- allow to measure time spent by a CPU in a virtual CPU.
- allow to display in /proc/state this value by CPU
- allow to display in /proc/<pid>/state this value by process
- allow KVM to use these 3 previous functionnalities

> Laurent> [PATCH 1/4] as recent CPUs introduce a third running state,
> Laurent> after "user" and "system", we need a new field, "guest", in
> Laurent> cpustat to store the time used by the CPU to run virtual
> Laurent> CPU. Modify /proc/stat to display this new field.
>=20
> What happens when you have multiple guests, is this state cummulative? =
=20

Yes, like system time and user time are.

> I've glanced over these patches and the #ifdefs are ugly..., esp since

#ifdefs are ugly, I agree... I can remove them.
But "#ifdef" allows to save space and time (and it is not a beauty show).=


> the overhead seems to exist even if you don't run any Guest CPUs.  Or
> whatever you're doing here.

Can you explain ?

> Please justify this patch more in terms of what it provides and why
> it's a good thing to have. =20

Well... it provides the time spent by CPUs in virtual CPUs.
It is usefull only if you run Virtual Machine on your host (like KVM, lgu=
est,
kqemu...) to know how many time your CPUs dedicate to virtual machine exe=
cution.
It's a good thing to have like user time and system time are good things =
to
have... do you use 'top' or 'time' sometime ?


Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig7C4697859CD76F6581AFFD24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGyaeu9Kffa9pFVzwRAqydAKCSG136gnCONpBpMj0/gsaNEcAsJACgjSd4
HVdzGjIUyh0DKiOBnidtZjU=
=vVLG
-----END PGP SIGNATURE-----

--------------enig7C4697859CD76F6581AFFD24--
