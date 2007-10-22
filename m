Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbXJVWkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbXJVWkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXJVWkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:40:23 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:47631 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXJVWkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:40:21 -0400
Date: Mon, 22 Oct 2007 16:38:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] Bugfix to commit 4f9a58d75bfe82ab2b8ba5b8506dfb190a267834
To: Olaf Hering <olh@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Message-id: <20071022223737.21679.23812.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Commit 4f9a58d75bfe82ab2b8ba5b8506dfb190a267834 changes the size of
AT_VECTOR_SIZE from hard coded '44' to a calculation based on the value
of AT_VECTOR_SIZE_ARCH and AT_VECTOR_SIZE_BASE.  The change works for
arch/powerpc, but it breaks arch/ppc because the needed
AT_VECTOR_SIZE_ARCH is not present in include/asm-ppc/system.h and a
default value of 0 is used instead.  This results in AT_VECTOR_SIZE
being too small and it causes a kernel crash on loading init.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

I think this bug fix needs to go in ASAP.  I cannot boot my Virtex ppc405
platform without it.

Olaf, do I have the correct solution here?

Thanks,
g.

 include/asm-ppc/system.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-ppc/system.h b/include/asm-ppc/system.h
index cc45780..51df94c 100644
--- a/include/asm-ppc/system.h
+++ b/include/asm-ppc/system.h
@@ -33,6 +33,7 @@
 
 #define set_mb(var, value)	do { var = value; mb(); } while (0)
 
+#define AT_VECTOR_SIZE_ARCH 6 /* entries in ARCH_DLINFO */
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()

