Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZICIZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZICIZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZICIZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:25:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58116 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbZICIZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:25:46 -0400
Date: Thu, 3 Sep 2009 18:25:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the tip tree with the rr tree
Message-Id: <20090903182545.46dcd1d0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/setup.c between commit
212eddcdef19bfbe9c2178257708eb7cf17931be
("cpumask:remove-last-remaining-irqaction-mask") from the rr tree and
commit 845b3944bbdf9e9247849bf037f27ff3a3f26d87 ("x86: Add timer_init to
x86_init_ops") from the tip tree.

The latter moves the code that the former removes.  I fixed it up using
the following patch (which I can carry as necessary).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: tip: fix merge for cupmask update

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index fcece00..7883cf9 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -93,7 +93,6 @@ static struct irqaction irq0  = {
 
 void __init setup_default_timer_irq(void)
 {
-	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
