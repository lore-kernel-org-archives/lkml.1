Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbXKEKu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbXKEKu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbXKEKut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:50:49 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58797 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbXKEKus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:50:48 -0500
Date: Mon, 5 Nov 2007 16:11:12 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, paulus@samba.org,
       apw@shadowen.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] cpm_load_patch() - declartion conflict
Message-ID: <20071105104112.GA18347@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The build fails with following error

  CC      arch/powerpc/sysdev/micropatch.o
arch/powerpc/sysdev/micropatch.c:625: error: conflicting types for ‘cpm_load_patch’
include/asm/commproc.h:94: error: previous declaration of ‘cpm_load_patch’ was here
arch/powerpc/sysdev/micropatch.c: In function ‘cpm_load_patch’:
arch/powerpc/sysdev/micropatch.c:630: warning: unused variable ‘smp’
arch/powerpc/sysdev/micropatch.c:629: warning: unused variable ‘spp’
arch/powerpc/sysdev/micropatch.c:628: warning: unused variable ‘iip’
make[1]: *** [arch/powerpc/sysdev/micropatch.o] Error 1
make: *** [arch/powerpc/sysdev] Error 2

The commit f2a0bd3753dad7ea4605ebd5435716b39e9f92bb defines the function
with void cpm_load_patch(cpm8xx_t *cp) prtotype and is declared as 
extern void cpm_load_patch(volatile immap_t *immr) in the header file.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
diff --git a/include/asm-powerpc/commproc.h b/include/asm-powerpc/commproc.h
index 0307c84..a2328b8 100644
--- a/include/asm-powerpc/commproc.h
+++ b/include/asm-powerpc/commproc.h
@@ -91,7 +91,7 @@ extern uint m8xx_cpm_hostalloc(uint size);
 extern int  m8xx_cpm_hostfree(uint start);
 extern void m8xx_cpm_hostdump(void);
 
-extern void cpm_load_patch(volatile immap_t *immr);
+extern void cpm_load_patch(cpm8xx_t *cp);
 
 /* Buffer descriptors used by many of the CPM protocols.
 */


--
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
