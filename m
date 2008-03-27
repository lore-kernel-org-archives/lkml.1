Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbYC0WW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbYC0WW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758586AbYC0WWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:22:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49034
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754641AbYC0WWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:22:19 -0400
Date: Thu, 27 Mar 2008 15:22:18 -0700 (PDT)
Message-Id: <20080327.152218.235944668.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: rjw@sisk.pl, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       marcus@better.se, shemminger@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
 net_rx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080327222248.GA3596@ami.dom.local>
References: <20080327124928.GE2845@ami.dom.local>
	<200803272256.50454.rjw@sisk.pl>
	<20080327222248.GA3596@ami.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Thu, 27 Mar 2008 23:22:48 +0100

> On Thu, Mar 27, 2008 at 10:56:49PM +0100, Rafael J. Wysocki wrote:
> ...
> > I assume there will be a patch posted for this issue.  Correct?
> 
> I guess Peter should know the answer!

Instead of going back and forth like this can someone post
just take it upon themselves to post such an obvious patch
already :-)

All of this "he'll do it, she'll do it" just wastes time.

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a2f0032..fae6a7e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -383,9 +383,11 @@ static inline void __napi_complete(struct napi_struct *n)
 
 static inline void napi_complete(struct napi_struct *n)
 {
-	local_irq_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__napi_complete(n);
-	local_irq_enable();
+	local_irq_restore(flags);
 }
 
 /**
