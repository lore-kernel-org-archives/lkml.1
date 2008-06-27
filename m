Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbYF0UB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbYF0UB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYF0UBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:01:05 -0400
Received: from ns1.mrv.com ([66.43.110.3]:28881 "EHLO chmailsrv.int.mrv.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762688AbYF0UBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:01:03 -0400
Date: Fri, 27 Jun 2008 13:01:00 -0700
From: Nye Liu <nyet@mrv.com>
To: linux-kernel@vger.kernel.org
Cc: scottwood@freescale.com, linuxppc-dev@ozlabs.org
Subject: [PATCH] POWERPC CPM: Minor cosmetic changes to udbg_putc
Message-ID: <20080627200100.GA16661@mrv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 27 Jun 2008 20:02:40.0986 (UTC) FILETIME=[C14AE3A0:01C8D890]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nye Liu <nyet@mrv.com>

udbg_putc is a *function pointer* that is initialized during
udbg_init_cpm. It might not be initialized properly when called from
udbg_putc_cpm(), so (recursively) call udbg_putc_cpm() directly.

Printing an "X" on initialization is ugly. How about a "\n" instead?

Signed-off-by: Nye Liu <nyet@mrv.com>

---

diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index cb7df2d..dcde743 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -37,7 +37,7 @@ static void udbg_putc_cpm(char c)
 	u8 __iomem *txbuf = (u8 __iomem __force *)in_be32(&cpm_udbg_txdesc[1]);
 
 	if (c == '\n')
-		udbg_putc('\r');
+		udbg_putc_cpm('\r');
 
 	while (in_be32(&cpm_udbg_txdesc[0]) & 0x80000000)
 		;
@@ -53,7 +53,7 @@ void __init udbg_init_cpm(void)
 		setbat(1, 0xf0000000, 0xf0000000, 1024*1024, _PAGE_IO);
 #endif
 		udbg_putc = udbg_putc_cpm;
-		udbg_putc('X');
+		udbg_putc('\n');
 	}
 }
 #endif

-- 
Nye Liu
nliu@mrv.com
(818) 772-6235x248
(818) 772-0576 fax

"Who would be stupid enough to quote a fictitious character?"
	-- Don Quixote
