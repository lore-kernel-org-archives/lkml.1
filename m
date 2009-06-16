Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZFPDGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZFPDGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 23:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZFPDGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 23:06:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50726 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZFPDGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 23:06:31 -0400
Date: Tue, 16 Jun 2009 13:06:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, "David S. Miller" <davem@davemloft.net>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: linux-next: manual merge of the rr tree with the  tree
Message-Id: <20090616130632.3c411f5c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
drivers/net/sfc/efx.c between commit
3977d0334b98770b81dfeb248db232c9bb3d3c88 ("sfc: modify allocation error
message") from Linus' tree and commit
c735805e707362aa397ad3e78c16c616b3ec7399 ("cpumask: use zalloc_cpumask_var
() where possible") from the rr tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/sfc/efx.c
index 343e8da,23ee983..0000000
--- a/drivers/net/sfc/efx.c
+++ b/drivers/net/sfc/efx.c
@@@ -884,9 -894,9 +884,9 @@@ static int efx_wanted_rx_queues(void
  	int count;
  	int cpu;
  
- 	if (unlikely(!alloc_cpumask_var(&core_mask, GFP_KERNEL))) {
 -	if (!zalloc_cpumask_var(&core_mask, GFP_KERNEL)) {
++	if (unlikely(!zalloc_cpumask_var(&core_mask, GFP_KERNEL))) {
  		printk(KERN_WARNING
 -		       "efx.c: allocation failure, irq balancing hobbled\n");
 +		       "sfc: RSS disabled due to allocation failure\n");
  		return 1;
  	}
  
