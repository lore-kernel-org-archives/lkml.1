Return-Path: <linux-kernel-owner+w=401wt.eu-S1031190AbXDQTqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031190AbXDQTqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031189AbXDQTqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:46:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45695
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031190AbXDQTqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:46:08 -0400
Date: Tue, 17 Apr 2007 12:46:10 -0700 (PDT)
Message-Id: <20070417.124610.63508619.davem@davemloft.net>
To: xemul@sw.ru
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Set a separate lockdep class for neighbour table's
 proxy_queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <46236739.5000409@sw.ru>
References: <46236739.5000409@sw.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelianov <xemul@sw.ru>
Date: Mon, 16 Apr 2007 16:08:25 +0400

> Otherwise the following calltrace will lead to a wrong
> lockdep warning:
> 
>   neigh_proxy_process()
>     `- lock(neigh_table->proxy_queue.lock);
>   arp_redo /* via tbl->proxy_redo */
>   arp_process
>   neigh_event_ns
>   neigh_update
>   skb_queue_purge
>     `- lock(neighbor->arp_queue.lock);
> 
> This is not a deadlock actually, as neighbor table's proxy_queue
> and the neighbor's arp_queue are different queues.
> 
> Lockdep thinks there is a deadlock as both queues are initialized
> with skb_queue_head_init() and thus have a common class.

Patch applied, thank you.

Please provide a proper "Signed-off-by: " line in future patch
submissions or else I will ignore your patches entirely.

Thanks!
