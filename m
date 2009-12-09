Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbZLITWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbZLITWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbZLITWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:22:46 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54334 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbZLITWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:22:45 -0500
Date: Wed, 9 Dec 2009 20:22:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/12] arch/xtensa: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092022260.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/xtensa/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -277,7 +277,7 @@ void xtensa_elf_core_copy_regs (xtensa_g
 
 	/* Don't leak any random bits. */
 
-	memset(elfregs, 0, sizeof (elfregs));
+	memset(elfregs, 0, sizeof(*elfregs));
 
 	/* Note:  PS.EXCM is not set while user task is running; its
 	 * being set in regs->ps is for exception handling convenience.
