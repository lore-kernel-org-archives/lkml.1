Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYIBFE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYIBFE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 01:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYIBFET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 01:04:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55415 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbYIBFES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 01:04:18 -0400
Date: Tue, 2 Sep 2008 15:04:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulus@samba.org
Cc: ppc-dev <linuxppc-dev@ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       David Woodhouse <dwmw2@infradead.org>, Milton Miller <miltonm@bga.com>
Subject: [PATCH] powerpc: make sure all kernel text is before _etext
Message-Id: <20080902150409.5aca2198.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes core_kernel_text() (and therefore kernel_text_address())
return the correct result.  Currently all the __devinit routines (at
least) will not be considered to be kernel text.

This is just a quick fix for 2.6.27 - hopefully we will be able to fix
this better in 2.6.28.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/vmlinux.lds.S |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4a8ce62..9f6c1ca 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -66,11 +66,12 @@ SECTIONS
 		__got2_end = .;
 #endif /* CONFIG_PPC32 */
 
-		. = ALIGN(PAGE_SIZE);
-		_etext = .;
-		PROVIDE32 (etext = .);
 	} :kernel
 
+	. = ALIGN(PAGE_SIZE);
+	_etext = .;
+	PROVIDE32 (etext = .);
+
 	/* Read-only data */
 	RODATA
 
-- 
1.5.6.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
