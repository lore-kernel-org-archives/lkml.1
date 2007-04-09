Return-Path: <linux-kernel-owner+w=401wt.eu-S965522AbXDIUhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbXDIUhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965338AbXDIUhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:37:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50872
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965522AbXDIUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:37:53 -0400
Date: Mon, 09 Apr 2007 13:37:53 -0700 (PDT)
Message-Id: <20070409.133753.108740229.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       cramerj@intel.com, auke-jan.h.kok@intel.com,
       christopher.leech@intel.com
Subject: Re: [PATCH 2/2] NET: Multiqueue network device support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070409205052.31370.97137.stgit@gitlost.site>
References: <20070409204908.31370.9954.stgit@gitlost.site>
	<20070409205052.31370.97137.stgit@gitlost.site>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter P.Waskiewicz Jr. <peter.p.waskiewicz.jr@intel.com>
Date: Mon, 09 Apr 2007 13:50:52 -0700

> From: Peter P. Waskiewicz Jr. <peter.p.waskiewicz.jr@intel.com>
> 
> Added an API and associated supporting routines for multiqueue network devices.
> This allows network devices supporting multiple TX queues to configure each
> queue within the netdevice and manage each queue independantly.  Changes to the
> PRIO Qdisc also allow a user to map multiple flows to individual TX queues,
> taking advantage of each queue on the device.
> 
> Signed-off-by: Peter P. Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

This looks definitely better than the previous implementation,
myself and others will review this in more depth though.

> + 	alloc_size = (sizeof(struct net_device_subqueue) * queue_count);
> + 
> + 	p = kzalloc(alloc_size, GFP_KERNEL);
> + 	if (!p) {
> + 		printk(KERN_ERR "alloc_netdev: Unable to allocate queues.\n");
> + 		return NULL;
> + 	}
> + 
> + 	dev->egress_subqueue = (struct net_device_subqueue *)p;

No need for a cast, 'p' is "void *".
