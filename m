Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934296Ab0BYWjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:39:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934167Ab0BYWjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:39:39 -0500
Date: Thu, 25 Feb 2010 16:39:23 -0600
From: Clark Williams <williams@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RT] trivial fix to REMINDER block in init/main.c
Message-ID: <20100225163923.3621094e@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ucqxtQORnFxg4ra0wB55QcW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ucqxtQORnFxg4ra0wB55QcW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Thomas,

Here's a trivial patch to the RT tree. I noticed during testing that I
was getting an empty REMINDER block in dmesg. Looks like STACK_TRACER
got dropped.

Clark

diff --git a/init/main.c b/init/main.c
index aa48b7b..48393c0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -928,6 +928,9 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                          =
                    *\n");
 #endif
+#ifdef CONFIG_STACK_TRACER
+	printk(KERN_ERR "*        CONFIG_STACK_TRACER                            =
                    *\n");
+#endif
 #if defined(CONFIG_FTRACE) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
 	printk(KERN_ERR "*        CONFIG_FTRACE                                  =
                    *\n");
 #endif

--Sig_/ucqxtQORnFxg4ra0wB55QcW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkuG/B8ACgkQHyuj/+TTEp2gJQCgiipfXtMk1g8/LnpM83e/QJUZ
IpYAn2V1D4xh+8OpWwgSNw0vVL07sApP
=IQQ2
-----END PGP SIGNATURE-----

--Sig_/ucqxtQORnFxg4ra0wB55QcW--
