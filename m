Return-Path: <linux-kernel-owner+w=401wt.eu-S2992456AbXDRN2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992456AbXDRN2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992452AbXDRN2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:28:16 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:38715 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992456AbXDRN2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:28:15 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Christoph Pfister" <christophpfister@gmail.com>
Subject: Re: Kaffeine problem with CFS
Date: Wed, 18 Apr 2007 16:25:51 +0300
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Michael Lothian" <mike@fireburn.co.uk>,
       "Christophe Thommeret" <hftom@free.fr>,
       "Jurgen Kofler" <kaffeine@gmx.net>,
       "Ulrich Drepper" <drepper@redhat.com>
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <19a3b7a80704180555q4e0b26d5x54bbf34b4cd9d33e@mail.gmail.com> <19a3b7a80704180621m1b343b4eif02a7930a5edf2fc@mail.gmail.com>
In-Reply-To: <19a3b7a80704180621m1b343b4eif02a7930a5edf2fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1331041.vAu3ol99Ag";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704181625.51389.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1331041.vAu3ol99Ag
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

18 Nis 2007 =C3=87ar tarihinde, Christoph Pfister =C5=9Funlar=C4=B1 yazm=C4=
=B1=C5=9Ft=C4=B1:=20
> Replacing the sched_yield in demux.c with an usleep(10) stopped those
> seeking hangs here (at least I was able to pull the slider back and
> forth during 2 mins without trouble compared to the few secs I need
> earlier to get a hang).

Index: linux/kernel/sched.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3785,7 +3785,7 @@ asmlinkage long sys_sched_yield(void)
        _raw_spin_unlock(&rq->lock);
        preempt_enable_no_resched();
=20
=2D       schedule();
+       msleep(1);
=20
        return 0;
 }

which Ingo sends me to try also has the same effect on me. I cannot reprodu=
ce=20
hangs anymore with that patch applied top of CFS while one console checks o=
ut=20
SVN repos and other one compiles a small test software.

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1331041.vAu3ol99Ag
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGJhxfy7E6i0LKo6YRAhexAKC7e06ChKIeOsftHsqOo2QflV0xJgCcCjrc
ZhNUhXbtbzZvUrPrOstfIMg=
=tkyT
-----END PGP SIGNATURE-----

--nextPart1331041.vAu3ol99Ag--
