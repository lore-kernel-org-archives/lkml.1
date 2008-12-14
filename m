Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYLNNkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYLNNkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 08:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYLNNju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 08:39:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53562 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbYLNNjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 08:39:49 -0500
Date: Sun, 14 Dec 2008 13:39:41 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC] remove linux/hardirq.h from asm-generic/local.h
Message-ID: <20081214133941.GA18035@flint.arm.linux.org.uk>
Mail-Followup-To: Linux Kernel List <linux-kernel@vger.kernel.org>,
	linux-arch@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at reducing the amount of architecture namespace pollution
in the generic kernel, I found that asm/irq.h is included in the vast
majority of compilations on ARM (around 650 files.)

Since asm/irq.h includes a sub-architecture include file on ARM, this
causes a negative impact on the ccache's ability to re-use the build
results from other sub-architectures, so we have a desire to reduce
the dependencies on asm/irq.h.

It turns out that a major cause of this is the needless include of
linux/hardirq.h into asm-generic/local.h.  The patch below removes this
include, resulting in some 250 to 300 files (around half) of the kernel
then omitting asm/irq.h.

My test builds still succeed, provided two ARM files are fixed
(arch/arm/kernel/traps.c and arch/arm/mm/fault.c) - so there may be
negative impacts for this on other architectures.

Note that x86 does not include asm/irq.h nor linux/hardirq.h in its
asm/local.h, so this patch can be viewed as bringing the generic version
into line with the x86 version.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/include/asm-generic/local.h b/include/asm-generic/local.h
index 33d7d04..43c0b81 100644
--- a/include/asm-generic/local.h
+++ b/include/asm-generic/local.h
@@ -2,7 +2,6 @@
 #define _ASM_GENERIC_LOCAL_H
 
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
 #include <asm/atomic.h>
 #include <asm/types.h>
 

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
