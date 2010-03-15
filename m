Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936103Ab0COKE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:04:28 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46529 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936076Ab0COKE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 06:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IaduQtuCDPrx1X0ntm35qzQJHUEcA4nS42KhLrqJpJah1JaH18JRT2Ue6onJsnUQJR
         abPPAw5sjb2LcapuVv/4aE/3iU1SuVVN1e63ufj9snzoyBrRrf4kzQ6VJTieRi70p+XN
         s+tV3/M9OZp7lvhMTLhOFBtx89rLaZZHWgE5g=
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       David Miller <davem@davemloft.net>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <2375c9f91003150239m1abc765bh59eb51c948eed592@mail.gmail.com>
References: <20100311134556.GA6344@linux.vnet.ibm.com>
	 <20100312.000705.225033546.davem@davemloft.net>
	 <2375c9f91003120059g771d162fxefc21beb2ab17b4d@mail.gmail.com>
	 <1268392276.3141.4.camel@edumazet-laptop>
	 <2375c9f91003120511j6f33592cl12cb2617a27351ec@mail.gmail.com>
	 <1268401058.3141.9.camel@edumazet-laptop> <20100313053356.GC3704@hack>
	 <20100313215838.GB6805@linux.vnet.ibm.com> <20100315010802.GB2735@hack>
	 <2375c9f91003142010g61841666iad53c24f39036acf@mail.gmail.com>
	 <2375c9f91003150239m1abc765bh59eb51c948eed592@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 11:04:20 +0100
Message-ID: <1268647460.3154.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 15 mars 2010 à 17:39 +0800, Américo Wang a écrit :

> 
> Ok, I think I found what lockdep really complains about, it is that we took
> spin_lock in netpoll_poll_lock() which is in hardirq-enabled environment,
> later, we took another spin_lock with spin_lock_irqsave() in netpoll_rx(),
> so lockdep thought we broke the locking rule.
> 
> I don't know why netpoll_rx() needs irq disabled, it looks like that no one
> takes rx_lock in hardirq context. So can we use spin_lock(&rx_lock)
> instead? Or am I missing something here? Eric? David?

I am a bit lost.

Could you give the complete picture, because I cannot find it in my
netdev archives.



