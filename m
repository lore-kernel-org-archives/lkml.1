Return-Path: <linux-kernel-owner+w=401wt.eu-S932863AbZKXLLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbZKXLLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932806AbZKXLK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:10:56 -0500
Received: from mail.klingt.org ([86.59.21.178]:33175 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbZKXLKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:10:54 -0500
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 06:10:50 EST
Message-ID: <4B0BBBB8.8060901@klingt.org>
Date: Tue, 24 Nov 2009 11:55:52 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091121 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] workqueue.c: remove branch hint
References: <cover.1259059549.git.tim@klingt.org>
In-Reply-To: <cover.1259059549.git.tim@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5F09975A514D9EF4F7021D0A"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Tue, 24 Nov 2009 12:02:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5F09975A514D9EF4F7021D0A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

branch hint profiling of my nehalem machine, showed 96% incorrect branch
hints:

131609  3840434  96 queue_delayed_work_on          workqueue.c          2=
58

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0a98bef..6985ab0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -255,7 +255,7 @@ int queue_delayed_work_on(int cpu, struct
workqueue_struct *wq,
 		timer->data =3D (unsigned long)dwork;
 		timer->function =3D delayed_work_timer_fn;
 -		if (unlikely(cpu >=3D 0))
+		if (cpu >=3D 0)
 			add_timer_on(timer, cpu);
 		else
 			add_timer(timer);
--=20
1.6.4.2



--------------enig5F09975A514D9EF4F7021D0A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksLu7gACgkQdL+4qsZfVstZFgCfQoM6SYHVaJp4yGn7mZv4lMJW
I0AAn1EQlcHxG0VLCCuy36MmN+a32662
=HFQo
-----END PGP SIGNATURE-----

--------------enig5F09975A514D9EF4F7021D0A--
