Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYBRIrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYBRIrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYBRIrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:47:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34266
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756077AbYBRIrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:47:23 -0500
Date: Mon, 18 Feb 2008 00:47:59 -0800 (PST)
Message-Id: <20080218.004759.27101677.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080218190841.eeed735f.sfr@canb.auug.org.au>
References: <20080218190841.eeed735f.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Feb 2008 19:08:41 +1100

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.

The patch below fixes the allmodconfig build on sparc64
for me.

I notice on the build status page that sparc64 allmodconfig
fails in the CODA filesystem bits.  I suspect this is some
cross-build issue, and even moreso it appears the "u_quad"
definition is to blame and the way that gets defined in the
CODA fs headers is beyond questionable :-/

Anyways, here is the build fix:

[SPARC64]: Add ide_default_irq() implementation.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/asm-sparc64/ide.h b/include/asm-sparc64/ide.h
index c5fdabe..5bfb064 100644
--- a/include/asm-sparc64/ide.h
+++ b/include/asm-sparc64/ide.h
@@ -24,6 +24,11 @@
 # endif
 #endif
 
+static inline int ide_default_irq(unsigned long base)
+{
+	return 0;
+}
+
 #define __ide_insl(data_reg, buffer, wcount) \
 	__ide_insw(data_reg, buffer, (wcount)<<1)
 #define __ide_outsl(data_reg, buffer, wcount) \
