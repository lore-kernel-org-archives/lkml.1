Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbXBYFmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbXBYFmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933662AbXBYFmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:42:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33573
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933652AbXBYFmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:42:02 -0500
Date: Sat, 24 Feb 2007 21:42:01 -0800 (PST)
Message-Id: <20070224.214201.126577744.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, peter.keilty@hp.com
Subject: [PATCH]: tick-sched.c build fix
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While getting dynticks/hrtimers up on sparc64 I ran into
the following build problem.  If you use get_irq_regs() you
need to include asm/irq_regs.h

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 512a4a9..51556b9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -21,6 +21,8 @@
 #include <linux/sched.h>
 #include <linux/tick.h>
 
+#include <asm/irq_regs.h>
+
 #include "tick-internal.h"
 
 /*
