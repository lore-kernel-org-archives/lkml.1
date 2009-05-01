Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZEAB4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZEAB4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 21:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZEAB41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 21:56:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45471 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbZEAB41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 21:56:27 -0400
Date: Thu, 30 Apr 2009 21:56:20 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Michael Ellerman <michael@ellerman.id.au>
cc: Sam Ravnborg <sam@ravnborg.org>, Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Waseem Daher <wdaher@MIT.EDU>
Subject: Re: [PATCH 2/8] powerpc: share .data output section definition
 between 32 and 64 bits.
In-Reply-To: <1241142402.6928.7.camel@concordia>
Message-ID: <alpine.DEB.1.10.0904302153260.3955@vinegar-pot.mit.edu>
References: <1241135777-9462-1-git-send-email-tabbott@mit.edu>  <1241135777-9462-2-git-send-email-tabbott@mit.edu>  <1241135777-9462-3-git-send-email-tabbott@mit.edu> <1241142402.6928.7.camel@concordia>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Michael Ellerman wrote:

> On Thu, 2009-04-30 at 19:56 -0400, Tim Abbott wrote:
> > +#ifndef CONFIG_PPC32
> 
> This would be clearer in the positive, as in #ifdef CONFIG_PPC64.

Good point.  New version below.

	-Tim Abbott

powerpc: share .data output section definition between 32 and 64 bits.

Since upcoming changes will add several more common pieces of code
between the 32-bit and 64-bit powerpc architectures, it seems best to
unify these two blocks.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/vmlinux.lds.S |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index b9ef164..de80f89 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -219,20 +219,19 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	_sdata = .;
 
-#ifdef CONFIG_PPC32
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		DATA_DATA
+#ifdef CONFIG_PPC32
 		*(.sdata)
 		*(.got.plt) *(.got)
-	}
 #else
-	.data : AT(ADDR(.data) - LOAD_OFFSET) {
-		DATA_DATA
 		*(.data.rel*)
 		*(.toc1)
 		*(.branch_lt)
+#endif
 	}
 
+#ifdef CONFIG_PPC64
 	.opd : AT(ADDR(.opd) - LOAD_OFFSET) {
 		*(.opd)
 	}
-- 
1.6.2.1

