Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXLHMyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXLHMyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 07:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXLHMyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 07:54:46 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:39657 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbXLHMyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 07:54:45 -0500
Subject: [PATCH] Fix casting on architectures with 32-bit pointers/longs.
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       suresh.b.siddha@intel.com
In-Reply-To: <1196983219534-git-send-email-zach.brown@oracle.com>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Dec 2007 13:52:14 +0100
Message-Id: <1197118334.19335.13.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tor, 06 12 2007 kl. 15:20 -0800, skrev Zach Brown:
> The following patches are a substantial refactoring of the syslet code.  I'm
> branding them as the v7 release of the syslet infrastructure, though they
> represent a signifiant change in focus.
> 
> My current focus is to see the most fundamental functionality brought to
> maturity.  To me, this means getting a ABI that is used by applications through
> glibc on x86 and PPC64.   Only once that is ready should we distract ourselves
> with advanced complexity.
> 
> To that end, this patch series differs from v6 in significant ways:
> 
>  * syslets are initiated by providing syslet arguments to sys_indirect().
> 
>  * uatoms, threadlets, and the kaio changes are postponed until they can be
>    justified and rebuilt on more complete infrastructure.  (I'm not saying
>    these shouldn't or won't be persued.  I'm saying that we should get the
>    simplest piece working first.)
> 
>  * the code is clarified and commented, the patches are bisectable and pass
>    checkpatch.
> 
> The use of sys_indirect() and the move from 'atom's simplified the ABI
> considerably.  I've put a trivial example in a syslet-userspace git tree:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/zab/syslets-userspace.git
> 

Signed-of-by: Simon Holm Thøgersen <odie@cs.aau.dk>
---

diff --git a/basic.c b/basic.c
index 418a1a3..5938d85 100644
--- a/basic.c
+++ b/basic.c
@@ -42,7 +42,7 @@ int main(int argc, char **argv)
 	params.syslet.frame.sp = (u64)(long)memalign(pagesize, pagesize);
 
 	memset(&params, 0, sizeof(params));
-	params.syslet.frame.ip = (u64)syslet_return_func;
+	params.syslet.frame.ip = (u64)(long)syslet_return_func;
 	params.syslet.frame.sp = (u64)(long)memalign(pagesize, pagesize);
 	params.syslet.ring_ptr = (u64)(long)ring;
 
@@ -55,7 +55,7 @@ int main(int argc, char **argv)
 			pid, my_pid);
 	}
 
-	params.syslet.frame.ip = (u64)syslet_return_func;
+	params.syslet.frame.ip = (u64)(long)syslet_return_func;
 	params.syslet.frame.sp = (u64)(long)memalign(pagesize, pagesize);
 	params.syslet.ring_ptr = (u64)(long)ring;
 	params.syslet.caller_data = CALLER_DATA;


