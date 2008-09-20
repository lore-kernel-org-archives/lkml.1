Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbYITUAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbYITUAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 16:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYITUAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 16:00:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50387
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbYITUAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 16:00:03 -0400
Date: Sat, 20 Sep 2008 12:59:49 -0700 (PDT)
Message-Id: <20080920.125949.193703969.davem@davemloft.net>
To: dwalker@mvista.com
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1221932404.1343.196.camel@localhost.localdomain>
References: <1221926529.1343.140.camel@localhost.localdomain>
	<20080920091918.0ffaef8c@infradead.org>
	<1221932404.1343.196.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>
Date: Sat, 20 Sep 2008 10:40:04 -0700

> Dave didn't supply the users of his code, or what kind of improvement
> was seen, or the case in which it would be needed. I think Dave knowns
> his subsystem, but the code on the surface looks like an end run around
> some other problem area..

I posted an example use case on netdev a few days ago, and
the block layer example is in Jen's block layer tree.

It's for networking cards that don't do flow seperation on
receive using multiple RX queues and MSI-X interrupts.  It's
also for things like IPSEC where the per-packet cpu usage
is so huge (to do the crypto) that it makes sense to even
split up the work to multiple cpus within the same flow.
