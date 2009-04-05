Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbZDEHMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbZDEHMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 03:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbZDEHMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 03:12:06 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:56090 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbZDEHMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 03:12:05 -0400
Date: Sun, 5 Apr 2009 10:12:00 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Yinghai Lu <yinghai@kernel.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: strange MTRR on 2.6.29-git
In-Reply-To: <86802c440904011143i65d99bd8x7a296f616f6bfccc@mail.gmail.com>
Message-ID: <Pine.SOC.4.64.0904050953480.2958@math.ut.ee>
References: <Pine.SOC.4.64.0904011711210.5672@math.ut.ee>
 <86802c440904011143i65d99bd8x7a296f616f6bfccc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-851401618-1238915520=:2958"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-851401618-1238915520=:2958
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

> > reg00: base=3D0x000000000 ( =A0 =A00MB), size=3D =A0512MB, count=3D1:=
 write-back
> > reg01: base=3D0x020000000 ( =A0512MB), size=3D =A0 =A01MB, count=3D1:=
 write-back
> > reg02: base=3D0x020000000 ( =A0512MB), size=3D =A0 =A01MB, count=3D1:=
 uncachable
> > reg03: base=3D0x0f2000000 ( 3872MB), size=3D =A0 32MB, count=3D2: wri=
te-combining
> > reg04: base=3D0x0f8000000 ( 3968MB), size=3D =A0 64MB, count=3D1: wri=
te-combining

> that is original setting by BIOS.
> it should be ok.
> if you like, could try to enable
>=20
> CONFIG_MTRR=3Dy
> CONFIG_MTRR_SANITIZER=3Dy
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
>=20
> it could do the clean up for you.

Thank you, it did clean it up:

reg00: base=3D0x000000000 (    0MB), size=3D  512MB, count=3D1: write-bac=
k
reg01: base=3D0x0f2000000 ( 3872MB), size=3D   32MB, count=3D2: write-com=
bining
reg02: base=3D0x0f8000000 ( 3968MB), size=3D   64MB, count=3D1: write-com=
bining

and it removed the overlapping MTRR-s altogether since there was no RAM=20
described t be here. Seems to work fine.

--=20
Meelis Roos (mroos@linux.ee)
---559023410-851401618-1238915520=:2958--
