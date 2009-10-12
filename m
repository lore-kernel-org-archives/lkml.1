Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZJLDAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZJLDAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 23:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbZJLDAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 23:00:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36732 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbZJLDAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 23:00:45 -0400
Date: Mon, 12 Oct 2009 14:00:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: suspend tree build failure
Message-Id: <20091012140002.10f1f3d1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Oct_2009_14_00_02_+1100_d50Ck6DeaY2oO09f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Oct_2009_14_00_02_+1100_d50Ck6DeaY2oO09f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/base/power/main.c: In function 'device_pm_wait':
drivers/base/power/main.c:218: error: 'TASK_UNINTERRUPTIBLE' undeclared (fi=
rst use in this function)
drivers/base/power/main.c:218: error: (Each undeclared identifier is report=
ed only once
drivers/base/power/main.c:218: error: for each function it appears in.)
drivers/base/power/main.c:218: error: implicit declaration of function 'sch=
edule'
drivers/base/power/main.c: In function 'dbg_show_time':
drivers/base/power/main.c:514: error: implicit declaration of function 'tas=
k_pid_nr'
drivers/base/power/main.c: In function '__device_resume_noirq':
drivers/base/power/main.c:551: error: 'TASK_NORMAL' undeclared (first use i=
n this function)
drivers/base/power/main.c: In function '__device_resume':
drivers/base/power/main.c:713: error: 'TASK_NORMAL' undeclared (first use i=
n this function)
drivers/base/power/main.c: In function '__device_suspend_noirq':
drivers/base/power/main.c:970: error: 'TASK_NORMAL' undeclared (first use i=
n this function)
drivers/base/power/main.c: In function '__device_suspend':
drivers/base/power/main.c:1145: error: 'TASK_NORMAL' undeclared (first use =
in this function)

Presumably caused by commit d43c36dc6b357fa1806800f18aa30123c747a6d1
("headers: remove sched.h from interrupt.h") from Linus' tree.

I have added the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 12 Oct 2009 13:48:27 +1100
Subject: [PATCH] suspend: using TASK_ macros requires sched.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/power/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 3b09009..fb1c648 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -29,6 +29,7 @@
 #include <linux/async.h>
 #include <linux/completion.h>
 #include <linux/time.h>
+#include <linux/sched.h>
=20
 #include "../base.h"
 #include "power.h"
--=20
1.6.4.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Oct_2009_14_00_02_+1100_d50Ck6DeaY2oO09f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrSm7IACgkQjjKRsyhoI8xzWgCfb/Q7QWl3x4slvEmrq/vec+HG
qAIAoLmNXhCRAKa0jST2hOaWy7qm9UZq
=MN54
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Oct_2009_14_00_02_+1100_d50Ck6DeaY2oO09f--
