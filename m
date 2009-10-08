Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZJHKnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZJHKnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbZJHKnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:43:41 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:48674 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbZJHKnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:43:39 -0400
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Benjamin Kong <benjamin_kong@ali.com.tw>, Samuel Ortiz <samuel@sortiz.org>,
       rda-users@lists.sourceforge.net,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] ali-ircc.c sleeping function called from invalid context
Date: Thu, 8 Oct 2009 14:45:40 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910081445.43125.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.31
	DESCRIBE:
(wrong message before that)
Driver reports/drivers/net/irda/ali-ircc.c  - get spin_lock twice 

drivers/net/irda/ali-ircc.c:
2028static int ali_ircc_net_ioctl(struct net_device *dev, struct ifreq *rq, 
int cmd)
...
2056 ? ? ? ? ? ? ? ?spin_lock_irqsave(&self->lock, flags);
2057 ? ? ? ? ? ? ? ?ali_ircc_change_speed(self, irq->ifr_baudrate); ? ? ? ? 
...

Path to second spin_lock_irqsave(&self->lock, flags)  from 
ali_ircc_change_speed:
1. ali_ircc_change_speed calls ali_ircc_sir_change_speed 
./drivers/net/irda/ali-ircc.c:999
2. ali_ircc_sir_change_speed calls spin_lock_irqsave at 
./drivers/net/irda/ali-ircc.c:1084:

1050static void ali_ircc_sir_change_speed(struct ali_ircc_cb *priv, __u32 
speed)
1084        spin_lock_irqsave(&self->lock, flags);

Found by: Linux Driver Verification

