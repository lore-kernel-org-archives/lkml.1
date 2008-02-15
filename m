Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbYBOQBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbYBOQBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYBOQBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:01:04 -0500
Received: from smtp20.orange.fr ([80.12.242.27]:49597 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbYBOQBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:01:01 -0500
X-ME-UUID: 20080215160058894.DA4C91C000AD@mwinf2007.orange.fr
Message-ID: <47B5B73F.9050904@cosmosbay.com>
Date: Fri, 15 Feb 2008 17:01:03 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Is netif_tx_lock() SMP PREEMPT safe?
References: <200802151725.05424.mitov@issp.bas.bg>
In-Reply-To: <200802151725.05424.mitov@issp.bas.bg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marin Mitov a écrit :
> Hi all,
>
> As in: include/linux/netdevice.h (kernel-2.6.24.2) one finds:
>
> static inline void __netif_tx_lock(struct net_device *dev, int cpu)
> {
>         spin_lock(&dev->_xmit_lock);
>         dev->xmit_lock_owner = cpu;
> }
>
> static inline void netif_tx_lock(struct net_device *dev)
> {
>         __netif_tx_lock(dev, smp_processor_id());
> }
>
> Does netif_tx_lock(struct net_device *dev) expands into:
>
> cpu = smp_processor_id(); 
> <preempt & shift to another cpu (bogus)>
> spin_lock(&dev->_xmit_lock);
> dev->xmit_lock_owner = cpu; /* cpu is not the lock owner */
>
> Or to:
>
> spin_lock(&dev->_xmit_lock);
> dev->xmit_lock_owner = smp_processor_id();
>
> which is correct?
>
>   
Hi Marin

This expands to the first version, but netif_tx_lock() is allways called 
with preemption disabled.

(Or checks in smp_processor_id() would just trigger)


Eric
(Cced netdev for network related stuff)





