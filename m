Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0CLNhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:37:46 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60525 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab0CLNho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:37:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pHEplu/CdPoffY7L7n6LWMcQvOwzeozVtTj7oCi/GhLq6Evxn3whkf2D2TSBebZvIE
         2r3p3vwTA4Yqic+3Fq9seh/veBWxs7yuMB9DEFqOTdu2hi5W5tb0JuXkIcjzabRcWie2
         +13PKrpE9QAl9dPOYEQbHFsmOZ4fAt3KUPfoE=
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: David Miller <davem@davemloft.net>, paulmck@linux.vnet.ibm.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <2375c9f91003120511j6f33592cl12cb2617a27351ec@mail.gmail.com>
References: <20100311134556.GA6344@linux.vnet.ibm.com>
	 <20100311161751.GA3804@hack>
	 <2375c9f91003112356g1b4164e4pb5f63f0e0e2f310a@mail.gmail.com>
	 <20100312.000705.225033546.davem@davemloft.net>
	 <2375c9f91003120059g771d162fxefc21beb2ab17b4d@mail.gmail.com>
	 <1268392276.3141.4.camel@edumazet-laptop>
	 <2375c9f91003120511j6f33592cl12cb2617a27351ec@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 14:37:38 +0100
Message-ID: <1268401058.3141.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 mars 2010 à 21:11 +0800, Américo Wang a écrit :

> Oh, but lockdep complains about rcu_read_lock(), it said
> rcu_read_lock() can't be used in softirq context.
> 
> Am I missing something?

Well, lockdep might be dumb, I dont know...

I suggest you read rcu_read_lock_bh kernel doc :

/**
 * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical
section
 *
 * This is equivalent of rcu_read_lock(), but to be used when updates
 * are being done using call_rcu_bh(). Since call_rcu_bh() callbacks
 * consider completion of a softirq handler to be a quiescent state,
 * a process in RCU read-side critical section must be protected by
 * disabling softirqs. Read-side critical sections in interrupt context
 * can use just rcu_read_lock().
 *
 */


Last sentence being perfect :

Read-side critical sections in interrupt context
can use just rcu_read_lock().



