Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYBOPnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYBOPnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYBOPnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:43:32 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:33854 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYBOPnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:43:31 -0500
X-Greylist: delayed 1312 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2008 10:43:31 EST
From: Marin Mitov <mitov@issp.bas.bg>
To: linux-kernel@vger.kernel.org
Subject: Is netif_tx_lock() SMP PREEMPT safe?
Date: Fri, 15 Feb 2008 17:25:05 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200802151725.05424.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As in: include/linux/netdevice.h (kernel-2.6.24.2) one finds:

static inline void __netif_tx_lock(struct net_device *dev, int cpu)
{
        spin_lock(&dev->_xmit_lock);
        dev->xmit_lock_owner = cpu;
}

static inline void netif_tx_lock(struct net_device *dev)
{
        __netif_tx_lock(dev, smp_processor_id());
}

Does netif_tx_lock(struct net_device *dev) expands into:

cpu = smp_processor_id(); 
<preempt & shift to another cpu (bogus)>
spin_lock(&dev->_xmit_lock);
dev->xmit_lock_owner = cpu; /* cpu is not the lock owner */

Or to:

spin_lock(&dev->_xmit_lock);
dev->xmit_lock_owner = smp_processor_id();

which is correct?

Thanks in advance for your answer.

Regards

Marin Mitov


