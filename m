Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZHLP3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZHLP3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZHLP3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:29:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52725 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbZHLP3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:29:05 -0400
Date: Wed, 12 Aug 2009 10:28:43 -0500
From: Clark Williams <williams@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: RT <linux-rt-users@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RT PATCH] Changed boot warning to look for CONFIG_FUNCTION &&
 !CONFIG_DYNAMIC_FTRACE
Message-ID: <20090812102843.1e0c6d73@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tV_Q5R.WLwdS8crv4_i+3i+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tV_Q5R.WLwdS8crv4_i+3i+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Thomas,

After a conversation with Steven, I changed the boot warning for
configs that may hurt performance to look for CONFIG_FUNCTION
&& !CONFIG_DYNAMIC_FTRACE, rather than just CONFIG_FTRACE.

Signed-off-by: Clark Williams <williams@redhat.com>
---
 init/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index a04e102..9a0d510 100644
--- a/init/main.c
+++ b/init/main.c
@@ -935,7 +935,7 @@ static int __init kernel_init(void * unused)
 	WARN_ON(irqs_disabled());
 #endif
=20
-#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQ=
SOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER=
) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defi=
ned(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTR=
ACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
+#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQ=
SOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER=
) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defi=
ned(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FUN=
CTION) - defined(CONFIG_DYNAMIC_FTRACE)))
=20
 #if DEBUG_COUNT > 0
 	printk(KERN_ERR "********************************************************=
*********************\n");
@@ -955,8 +955,8 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                          =
                    *\n");
 #endif
-#ifdef CONFIG_FTRACE
-	printk(KERN_ERR "*        CONFIG_FTRACE                                  =
                    *\n");
+#if defined(CONFIG_FUNCTION) && !defined(CONFIG_DYNAMIC_FTRACE)
+	printk(KERN_ERR "*        CONFIG_FUNCTION                                =
                    *\n");
 #endif
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
 	printk(KERN_ERR "*        CONFIG_WAKEUP_LATENCY_HIST                     =
                    *\n");
--=20
1.6.2.5


--Sig_/tV_Q5R.WLwdS8crv4_i+3i+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqC37AACgkQHyuj/+TTEp2u8wCeIvYsWfoUqfhh+JgM4rtCEIg9
69AAmwQwuWEriOROCICx0d59uDQTxKCh
=hIzg
-----END PGP SIGNATURE-----

--Sig_/tV_Q5R.WLwdS8crv4_i+3i+--
