Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbZICIZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbZICIZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbZICIZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:25:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58096 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbZICIZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:25:17 -0400
Date: Thu, 3 Sep 2009 18:25:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: linux-next: tip tree build warnings
Message-Id: <20090903182510.8fd4d4d1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Sep_2009_18_25_10_+1000_urGwXRyHLq6=QjZC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Sep_2009_18_25_10_+1000_urGwXRyHLq6=QjZC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) produced these warning:

In file included from include/trace/ftrace.h:285,
                 from include/trace/define_trace.h:61,
                 from include/trace/events/timer.h:342,
                 from kernel/timer.c:50:
include/trace/events/timer.h: In function 'ftrace_raw_output_itimer_state':
include/trace/events/timer.h:280: warning: format '%lu' expects type 'long =
unsigned int', but argument 4 has type 'cputime_t'
include/trace/events/timer.h: In function 'ftrace_raw_output_itimer_expire':
include/trace/events/timer.h:317: warning: format '%lu' expects type 'long =
unsigned int', but argument 5 has type 'cputime_t'

Introduced by commit 3f0a525ebf4b8ef041a332bbe4a73aee94bb064b ("timers: Add=
 tracepoints for itimer") from the tip tree.

cputime_t is variously "u64", "unsigned long long" and "unsigned long" on
different architectures.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Sep_2009_18_25_10_+1000_urGwXRyHLq6=QjZC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqffWYACgkQjjKRsyhoI8wf6gCghWrHSU6isgx3Vz57qtE7OmmE
DrIAoLnuD2RyQGXuB6nSjEiJpVtoyZsD
=qZme
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Sep_2009_18_25_10_+1000_urGwXRyHLq6=QjZC--
