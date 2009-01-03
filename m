Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZACQhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZACQhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758019AbZACQgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:36:55 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54562 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbZACQgy (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:36:54 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.28-mmotm1230 kernel/workqueue.c compiler warning message
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231000573_3203P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 03 Jan 2009 11:36:13 -0500
Message-ID: <3521.1231000573@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231000573_3203P
Content-Type: text/plain; charset=us-ascii

In mmotm1230, there was an apparent mismerge that left a spare '&' on
a variable, causing this compiler warning:

kernel/workqueue.c: In function 'wq_cpu_map':
kernel/workqueue.c:94: warning: pointer type mismatch in conditional expression

so let's fix that up.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-2.6.28-mmotm1230/kernel/workqueue.c.dist	2009-01-01 17:23:21.000000000 -0500
+++ linux-2.6.28-mmotm1230/kernel/workqueue.c	2009-01-03 05:30:59.000000000 -0500
@@ -91,7 +91,7 @@ static inline int is_wq_single_threaded(
 static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_wq_single_threaded(wq)
-		 ? get_cpu_mask(singlethread_cpu) : &cpu_populated_map;
+		 ? get_cpu_mask(singlethread_cpu) : cpu_populated_map;
 }
 
 static


--==_Exmh_1231000573_3203P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJX5P9cC3lWbTT17ARAhudAJ91fZkr/zK9AZu23Cev4mJ2yEBvLACfbu0v
BjjyEOhfTpvhgakpcY+yNs0=
=XvI3
-----END PGP SIGNATURE-----

--==_Exmh_1231000573_3203P--
