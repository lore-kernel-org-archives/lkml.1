Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYGWH7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYGWH7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYGWH7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:59:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48439
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbYGWH7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:59:21 -0400
Date: Wed, 23 Jul 2008 00:59:21 -0700 (PDT)
Message-Id: <20080723.005921.113868915.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: Larry.Finger@lwfinger.net, kaber@trash.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080723062036.GA4561@ff.dom.local>
References: <20080722.160409.216536011.davem@davemloft.net>
	<20080723062036.GA4561@ff.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 23 Jul 2008 06:20:36 +0000

> PS: if there is nothing new in lockdep the classical method would
> be to change this static array:
> 
> static struct lock_class_key
> netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
> 
> to
> 
> static struct lock_class_key
> netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)][MAX_NUM_TX_QUEUES];
> 
> and set lockdep classes per queue as well. (If we are sure we don't
> need lockdep subclasses anywhere this could be optimized by using
> one lock_class_key per 8 queues and spin_lock_nested()).

Unfortunately MAX_NUM_TX_QUEUES is USHORT_MAX, so this isn't really
a feasible approach.

spin_lock_nested() isn't all that viable either, as the subclass
limit is something like 8.

