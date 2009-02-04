Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZBDKLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZBDKLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZBDKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:10:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:2174 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZBDKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:10:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KRkK8rYxVizHCXstuKsaC7it/kR+qfv/zCIIbtx3Zj2zPe42Zs2GK8cM/CvBMtJWCe
         yUZWcnr0WKgwhwMajsg7v2TdHh2MtOifYvIJjUpKSDfmJ9wMzFLo/RRFQP/arnjtHTWn
         9mGSL+eU/ivyX0rkPaNvtVQYIeakJFSzF6cQk=
Date: Wed, 4 Feb 2009 13:16:52 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, ink@jurassic.park.msu.ru
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fixup BUG macro
Message-ID: <20090204101652.GA11007@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do usual do {} while (0) dance, otherwise

fs/gfs2/util.c:99: error: expected expression before 'else'
drivers/scsi/lpfc/lpfc_sli.c:363: error: expected expression before 'else'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/include/asm/bug.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/include/asm/bug.h
+++ b/arch/alpha/include/asm/bug.h
@@ -8,12 +8,12 @@
 
 /* ??? Would be nice to use .gprel32 here, but we can't be sure that the
    function loaded the GP, so this could fail in modules.  */
-#define BUG()	{							\
+#define BUG()	do {							\
 	__asm__ __volatile__(						\
 		"call_pal %0  # bugchk\n\t"				\
 		".long %1\n\t.8byte %2"					\
 		: : "i"(PAL_bugchk), "i"(__LINE__), "i"(__FILE__));	\
-	for ( ; ; ); }
+	for ( ; ; ); } while (0)
 
 #define HAVE_ARCH_BUG
 #endif
