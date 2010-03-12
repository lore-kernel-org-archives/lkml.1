Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0CLIGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:06:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51802
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859Ab0CLIGp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:06:45 -0500
Date: Fri, 12 Mar 2010 00:07:05 -0800 (PST)
Message-Id: <20100312.000705.225033546.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
From: David Miller <davem@davemloft.net>
In-Reply-To: <2375c9f91003112356g1b4164e4pb5f63f0e0e2f310a@mail.gmail.com>
References: <20100311134556.GA6344@linux.vnet.ibm.com>
	<20100311161751.GA3804@hack>
	<2375c9f91003112356g1b4164e4pb5f63f0e0e2f310a@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Américo Wang <xiyou.wangcong@gmail.com>
Date: Fri, 12 Mar 2010 15:56:03 +0800

> Ok, after decoding the lockdep output, it looks like that
> netif_receive_skb() should call rcu_read_lock_bh() instead of rcu_read_lock()?
> But I don't know if all callers of netif_receive_skb() are in softirq context.

Normally, netif_receive_skb() is invoked from softirq context.

However, via netpoll it can be invoked essentially from any context.

But, when this happens, the networking receive path makes amends such
that this works fine.  That's what the netpoll_receive_skb() check in
netif_receive_skb() is for.  That check makes it bail out early if the
call to netif_receive_skb() is via a netpoll invocation.
