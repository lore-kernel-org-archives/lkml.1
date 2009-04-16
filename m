Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZDPXkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZDPXkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbZDPXkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:40:07 -0400
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:39004 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753967AbZDPXkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:40:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] kernel/sys.c: fix sparse warning
Date: Thu, 16 Apr 2009 19:39:27 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F9036@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] kernel/sys.c: fix sparse warning
Thread-Index: Acm+7JSV40rIvDFLRS+ehIUj2KhvIQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2009 23:40:04.0496 (UTC) FILETIME=[AADD5100:01C9BEEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning in kernel/sys.c.

  warning: do-while statement is not a compound statement

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/kernel/sys.c b/kernel/sys.c
index e7998cf..e3f3cc8 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -189,10 +189,10 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who,
int, niceval)
 				 !(user = find_user(who)))
 				goto out_unlock;	/* No processes
for this user */
 
-			do_each_thread(g, p)
+			do_each_thread(g, p) {
 				if (__task_cred(p)->uid == who)
 					error = set_one_prio(p, niceval,
error);
-			while_each_thread(g, p);
+			} while_each_thread(g, p);
 			if (who != cred->uid)
 				free_uid(user);		/* For
find_user() */
 			break;
@@ -252,13 +252,13 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 				 !(user = find_user(who)))
 				goto out_unlock;	/* No processes
for this user */
 
-			do_each_thread(g, p)
+			do_each_thread(g, p) {
 				if (__task_cred(p)->uid == who) {
 					niceval = 20 - task_nice(p);
 					if (niceval > retval)
 						retval = niceval;
 				}
-			while_each_thread(g, p);
+			} while_each_thread(g, p);
 			if (who != cred->uid)
 				free_uid(user);		/* for
find_user() */
 			break; 
