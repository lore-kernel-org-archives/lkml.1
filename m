Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbZJNILw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbZJNILw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZJNILv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:11:51 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:36082 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbZJNILu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 04:11:50 -0400
Date: Wed, 14 Oct 2009 12:14:05 +0000
From: iceberg <strakh@ispras.ru>
Subject: [BUG] ali-ircc.c: get spin_lock twice
To: Benjamin Kong <benjamin_kong@ali.com.tw>, Samuel Ortiz <samuel@sortiz.org>,
       rda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.3.26
Message-Id: <1255522445.31793.0@pamir>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.31
	DESCRIBE:
Driver reports/drivers/net/irda/ali-ircc.c  - get spin_lock twice

drivers/net/irda/ali-ircc.c:
2028static int ali_ircc_net_ioctl(struct net_device *dev, struct ifreq 
*rq, int cmd)

...
2056		spin_lock_irqsave(&self->lock, flags);
2057		ali_ircc_change_speed(self, irq->ifr_baudrate);
...

Path to second spin_lock_irqsave(&self->lock, flags) 
 from ali_ircc_change_speed:
1. ali_ircc_change_speed calls ali_ircc_sir_change_speed ./drivers/net/
irda/ali-ircc.c:999
2. ali_ircc_sir_change_speed calls spin_lock_irqsave at ./drivers/net/
irda/ali-ircc.c:1084:

1050static void ali_ircc_sir_change_speed(struct ali_ircc_cb *priv, 
__u32 speed)
1084        spin_lock_irqsave(&self->lock, flags);

Found by: Linux Driver Verification project

