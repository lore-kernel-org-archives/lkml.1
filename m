Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbZHLXoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbZHLXoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZHLXoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:44:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33289
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZHLXoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:44:02 -0400
Date: Wed, 12 Aug 2009 16:44:12 -0700 (PDT)
Message-Id: <20090812.164412.266822784.davem@davemloft.net>
To: jpirko@redhat.com
Cc: akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] net: Fix spinlock use in alloc_netdev_mq()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090806083102.GA3737@psychotron.englab.brq.redhat.com>
References: <20090805084746.GA3897@psychotron.englab.brq.redhat.com>
	<20090805101327.2c49cc62.akpm@linux-foundation.org>
	<20090806083102.GA3737@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Thu, 6 Aug 2009 10:31:02 +0200

> Hmm, I see your point here. Eric previously posted patch which moved spin lock
> init into alloc_netdev_mq(). But he was worried about having it here and
> netdev_set_addr_lockdep_class() in register_netdevice() (because before
> dev_unicast_init() dev->type is not set). So how about the following patch?

Well, because of those potential late dev->type settings we
can't do things this way.  And I believe those in fact do happen.

So I'm tossing this patch, I wouldn't have applied it to net-2.6
anyways, as it's net-next-2.6 material :-)
