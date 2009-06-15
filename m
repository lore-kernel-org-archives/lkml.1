Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbZFOJcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbZFOJcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZFOJcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:32:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59914
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbZFOJb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:31:59 -0400
Date: Mon, 15 Jun 2009 02:32:02 -0700 (PDT)
Message-Id: <20090615.023202.245678744.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: robert.olsson@its.uu.se, zheng.yan@oracle.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Re: [BUG] fib_tries related Oops in 2.6.30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090615065333.GA4378@ff.dom.local>
References: <20090612072557.GA2761@ami.dom.local>
	<20090615065333.GA4378@ff.dom.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Mon, 15 Jun 2009 06:53:33 +0000

> ipv4: Fix fib_trie rebalancing
> 
> While doing trie_rebalance(): resize(), inflate(), halve() RCU free
> tnodes before updating their parents. It depends on RCU delaying the
> real destruction, but if RCU readers start after call_rcu() and before
> parent update they could access freed memory.
> 
> It is currently prevented with preempt_disable() on the update side,
> but it's not safe, except maybe classic RCU, plus it conflicts with
> memory allocations with GFP_KERNEL flag used from these functions.
> 
> This patch explicitly delays freeing of tnodes by adding them to the
> list, which is flushed after the update is finished.
> 
> Reported-by: Yan Zheng <zheng.yan@oracle.com>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>

Applied to net-next-2.6
