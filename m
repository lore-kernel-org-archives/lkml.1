Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYELCMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYELCMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 22:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYELCMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 22:12:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:58337 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754374AbYELCMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 22:12:36 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX19mRNUtGdpmnB73a8PYpfiKN7LZgBcdThulMyk25i
	NfWbc6Rax4hReP
Subject: [Patch]: Cgroups: Fix compile warning: incompatible types in
	kernel/sched.c on 2.6.26-rc1
From: Mirco Tischler <mt-ml@gmx.de>
To: Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hj649bRPUrfTmKBICYDl"
Date: Mon, 12 May 2008 04:12:33 +0200
Message-Id: <1210558353.29885.12.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Hj649bRPUrfTmKBICYDl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi
I've got this warning on 2.6.26-rc1 on compile:=20
> CC      kernel/sched.o
> kernel/sched.c:9026: warning: initialization from incompatible pointer ty=
pe
>=20
This patch fixes it.

Thanks
Mirco

Cgroups: Fix compile warning: incompatible types in kernel/sched.c

Return type of cpu_rt_runtime_write() should be int instead of ssize_t.

Signed-off-by: Mirco Tischler <mt-ml@gmx.de>

diff --git a/kernel/sched.c b/kernel/sched.c
index c51b656..ba91376 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8988,7 +8988,7 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, s=
truct cftype *cft)
 #endif
=20
 #ifdef CONFIG_RT_GROUP_SCHED
-static ssize_t cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cf=
t,
+static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
 				s64 val)
 {
 	return sched_group_set_rt_runtime(cgroup_tg(cgrp), val);


--=-Hj649bRPUrfTmKBICYDl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIJ6eQz+diZ7c2xfgRAkREAJ9RjZ92KJ2Ys5uZHNQarEpwE2VuZgCeM39/
V7vF+IeFAmPxT5KMiDN5eTo=
=punQ
-----END PGP SIGNATURE-----

--=-Hj649bRPUrfTmKBICYDl--

