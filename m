Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZGWPCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZGWPCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZGWPCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:02:13 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44949 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZGWPCN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:02:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: mmotm-0716 - selinux_bprm_commited_creds patch missing..
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248357159_9653P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Jul 2009 09:52:39 -0400
Message-ID: <13397.1248357159@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248357159_9653P
Content-Type: text/plain; charset=us-ascii

Andrew - mmotm-0716 dies at boot because it's missing this patch from Oleg
for a problem originally spotted in -0630/0702:

Date: Fri, 03 Jul 2009 11:23:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,         James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,         Roland McGrath <roland@redhat.com>
Subject: [PATCH] selinux_bprm_committed_creds: use __wake_up_parent()

(depends on ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
 which exports __wake_up_parent)

Spotted by Valdis.Kletnieks@vt.edu.

selinux_bprm_committed_creds() should not play with ->wait_chldexit, now
that __wake_up_parent() is exported change the code to use this helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- WAIT/security/selinux/hooks.c~SEL_WAKE_PARENT	2009-06-16 17:01:42.000000000 +0200
+++ WAIT/security/selinux/hooks.c	2009-07-03 11:15:08.000000000 +0200
@@ -2404,7 +2404,7 @@ static void selinux_bprm_committed_creds
 	/* Wake up the parent if it is waiting so that it can recheck
 	 * wait permission to the new task SID. */
 	read_lock(&tasklist_lock);
-	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
+	__wake_up_parent(current, current->real_parent);
 	read_unlock(&tasklist_lock);
 }
 





--==_Exmh_1248357159_9653P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKaGsncC3lWbTT17ARAlndAJ9PpQZccN1iY067RHzK0druNi9HawCg1lOd
H8gTlH4Igz+oG+Ue+B1a0ak=
=7IQw
-----END PGP SIGNATURE-----

--==_Exmh_1248357159_9653P--
