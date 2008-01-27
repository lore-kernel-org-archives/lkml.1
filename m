Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbYA0TEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbYA0TEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYA0TEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:04:32 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:49855 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYA0TEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:04:31 -0500
Message-ID: <479CD5BA.80009@web.de>
Date: Sun, 27 Jan 2008 20:04:26 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH] KGDB: various refactorings
References: <479CD13D.7070703@web.de>
In-Reply-To: <479CD13D.7070703@web.de>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5F3E6F366555A57035FC1E10"
X-Provags-ID: V01U2FsdGVkX1+j305q4xFfrS1FxgvNgkNNGznmKb3kvjvYM+72
	VrBQDl4hxgTSBu+xIWLJhOYaUdN8TQfQEWeY1aHsS6zeYO6sGG
	28lswAt/Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5F3E6F366555A57035FC1E10
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Jan Kiszka wrote:
> Jason,
>=20
> this is a RFC about another round of refactoring for the KGDB version
> in x86-git. It's a single patch so far, but I can break out individual
> hunks on request.
>=20
> Things I changed:
>  - Reduce EXPORT_SYMBOLs, switch the rest to EXPORT_SYMBOL_GPL
>  - Drop code that is (yet) unused
>  - Rename variables, refactor their types (personal taste, for sure)
>  - Remove "extern" for function prototypes
>  - Remove MODULE_LICENSE/DESCRIPTION from kgdb core

Sorry, forgot to refresh for this hunk:

 - rename CHECK_EXCEPTION_STACK to EXCEPTION_STACK_READY

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 include/asm-x86/kgdb.h |    2 +-
 include/linux/kgdb.h   |    4 ++--
 kernel/kgdb.c          |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: b/include/asm-x86/kgdb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/include/asm-x86/kgdb.h
+++ b/include/asm-x86/kgdb.h
@@ -77,7 +77,7 @@ enum regnames { _AX,	/* 0 */
 #ifndef __ASSEMBLY__
 #define BREAKPOINT()		asm("   int $3");
 #ifndef CONFIG_X86_32
-#define CHECK_EXCEPTION_STACK()
((&__get_cpu_var(init_tss))[0].x86_tss.ist[0])
+#define EXCEPTION_STACK_READY()
((&__get_cpu_var(init_tss))[0].x86_tss.ist[0])
 #endif /* ! CONFIG_X86_32 */
 #define BREAK_INSTR_SIZE	1
 #define CACHE_FLUSH_IS_SAFE	1
Index: b/include/linux/kgdb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -23,8 +23,8 @@
 #include <linux/linkage.h>
 #include <linux/init.h>

-#ifndef CHECK_EXCEPTION_STACK
-#define CHECK_EXCEPTION_STACK()	1
+#ifndef EXCEPTION_STACK_READY
+#define EXCEPTION_STACK_READY()	1
 #endif

 struct tasklet_struct;
Index: b/kernel/kgdb.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1940,7 +1940,7 @@ static void __init kgdb_early_entry(void
 	 * architecture to hook in and look at us when they are ready.
 	 */

-	if (!CHECK_EXCEPTION_STACK()) {
+	if (!EXCEPTION_STACK_READY()) {
 		kgdb_state =3D KGDB_SEMI_INITIALIZED;
 		/* any kind of break point is deferred to late_init */
 		return;


--------------enig5F3E6F366555A57035FC1E10
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHnNW9niDOoMHTA+kRAgQ4AKCAEStLHPtN0Q8yk3CS0QiaDXEKRwCggV3w
PvfF0ZHqggxDbQdyrLw2GxE=
=WF5s
-----END PGP SIGNATURE-----

--------------enig5F3E6F366555A57035FC1E10--
