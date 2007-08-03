Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbXHCUsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbXHCUsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760960AbXHCUsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:48:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:10165 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593AbXHCUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:48:40 -0400
Date: Fri, 3 Aug 2007 16:48:39 -0400
From: "George G. Davis" <gdavis@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix local_irq_* macro definition thinkos for the !TRACE_IRQFLAGS_SUPPORT case
Message-ID: <20070803204839.GA25379@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: George G. Davis <gdavis@mvista.com>

Fix local_irq_* macro definition errors for the !TRACE_IRQFLAGS_SUPPORT
case in which the macros are errantly "redefined" rather than defined.

Signed-off-by: George G. Davis <gdavis@mvista.com>

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 412e025..49a3df8 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -67,10 +67,10 @@
  * The local_irq_*() APIs are equal to the raw_local_irq*()
  * if !TRACE_IRQFLAGS.
  */
-# define raw_local_irq_disable()	local_irq_disable()
-# define raw_local_irq_enable()		local_irq_enable()
-# define raw_local_irq_save(flags)	local_irq_save(flags)
-# define raw_local_irq_restore(flags)	local_irq_restore(flags)
+# define local_irq_disable()		raw_local_irq_disable()
+# define local_irq_enable()		raw_local_irq_enable()
+# define local_irq_save(flags)		raw_local_irq_save(flags)
+# define local_irq_restore(flags)	raw_local_irq_restore(flags)
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
