Return-Path: <linux-kernel-owner+w=401wt.eu-S1751293AbZJXQVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbZJXQVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 12:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZJXQVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 12:21:11 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:54142 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZJXQVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 12:21:10 -0400
Message-ID: <4AE32926.2020005@web.de>
Date: Sat, 24 Oct 2009 18:19:50 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
 on top of perf events
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com> <1256393818-8921-5-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1256393818-8921-5-git-send-email-fweisbec@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE06997BCBE9513A326906F2D"
X-Provags-ID: V01U2FsdGVkX1+AwqnizbZs9Ez/Jy+ooiOSITy7K21C3riyCvQY
	3v12AIxC6WcjcViWTUYT4XxvZsvwm6lfBTP0s+spW+CuzyE6M5
	HSwXp1TL4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE06997BCBE9513A326906F2D
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Frederic Weisbecker wrote:
> This patch rebase the implementation of the breakpoints API on top of
> perf events instances.
>=20
> Each breakpoints are now perf events that handle the
> register scheduling, thread/cpu attachment, etc..
>=20
> The new layering is now made as follows:
>=20
>        ptrace       kgdb      ftrace   perf syscall
>           \          |          /         /
>            \         |         /         /
>                                         /
>             Core breakpoint API        /
>                                       /
>                      |               /
>                      |              /
>=20
>               Breakpoints perf events
>=20
>                      |
>                      |
>=20
>                Breakpoints PMU ---- Debug Register constraints handling=

>                                     (Part of core breakpoint API)
>                      |
>                      |
>=20
>              Hardware debug registers
>=20
> Reasons of this rewrite:
>=20
> - Use the centralized/optimized pmu registers scheduling,
>   implying an easier arch integration
> - More powerful register handling: perf attributes (pinned/flexible
>   events, exclusive/non-exclusive, tunable period, etc...)
>=20
> Impact:
>=20
> - New perf ABI: the hardware breakpoints counters
> - Ptrace breakpoints setting remains tricky and still needs some per
>   thread breakpoints references.

- Broken CONFIG_KVM

>=20
> Todo (in the order):
>=20

- Unbreak CONFIG_KVM :)

> - Support breakpoints perf counter events for perf tools (ie: implement=

>   perf_bpcounter_event())
> - Support from perf tools

Since commit 3d53c27d05, KVM uses current->thread.debugregs for
restoring the host state in case the guest played with breakpoints. We
need an equivalent interface to restore ptrace breakpoints and all
others currently in use.

Jan


--------------enigE06997BCBE9513A326906F2D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkrjKTcACgkQitSsb3rl5xTuPwCgrT6hs7a2X106B9fxzBJogy6D
YGgAoMkKYgN7zfDrp8oNoo3QjApj+rJR
=7h2T
-----END PGP SIGNATURE-----

--------------enigE06997BCBE9513A326906F2D--
