Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXKKBCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXKKBCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 20:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXKKBCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 20:02:20 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40270 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXKKBCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 20:02:19 -0500
Date: Sat, 10 Nov 2007 20:01:00 -0500
Message-Id: <200711110101.lAB110LV017867@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
CC: Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Serge Hallyn <serue@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH] kernel/capability.c get_task_comm compile error (MMOTM)
Cc: linux-kernel@vger.kernel.org
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Using http://userweb.kernel.org/~akpm/mmotm/ timestamped "10-Nov-2007
22:46".

$ make
  CC      kernel/capability.o
kernel/capability.c: In function 'sys_capset':
kernel/capability.c:231: warning: passing argument 1 of 'get_task_comm' from incompatible pointer type
kernel/capability.c:231: error: too few arguments to function 'get_task_comm'
make[1]: *** [kernel/capability.o] Error 1
make[1]: Target `__build' not remade because of errors.
make: *** [kernel] Error 2

Small patch below fixes compile error.

Erez.


Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/kernel/capability.c b/kernel/capability.c
index ea21bbe..8cba9b2 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -225,10 +225,11 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 	switch (version) {
 	case _LINUX_CAPABILITY_VERSION_1:
 		if (warned < 5) {
+			char name[sizeof(current->comm)];
 			warned++;
 			printk(KERN_INFO
 			       "warning: process `%s' sets w/ old libcap\n",
-			       get_task_comm(current));
+			       get_task_comm(name, current));
 		}
 		tocopy = _LINUX_CAPABILITY_U32S_1;
 		break;
