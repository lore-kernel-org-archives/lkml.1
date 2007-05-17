Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbXEQU3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbXEQU3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760473AbXEQU3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:29:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56681
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760080AbXEQU3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:29:35 -0400
Date: Thu, 17 May 2007 13:29:37 -0700 (PDT)
Message-Id: <20070517.132937.29572252.davem@davemloft.net>
To: tglx@linutronix.de
Cc: mikulas@artax.karlin.mff.cuni.cz, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOHZ: local_softirq_pending with tickless plip
From: David Miller <davem@davemloft.net>
In-Reply-To: <1179399131.3764.50.camel@chaos>
References: <Pine.LNX.4.64.0705161415350.10041@artax.karlin.mff.cuni.cz>
	<1179399131.3764.50.camel@chaos>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 May 2007 12:52:11 +0200

> On Wed, 2007-05-16 at 15:00 +0200, Mikulas Patocka wrote:
> > Hi
> > 
> > On one of my machines with tickless kernel and plip I get messages :
> 
> I bet this is a machine a P4 with Hyperthreading enabled ?
> 
> > NOHZ: local_softirq_pending 08
> > 
> > always when using plip (on other machine with tickless kernel and plip I 
> > get no errors). Thebug happens both on 2.6.21 and 2.6.22-rc1
> > 
> > This patch fixes that. Note that plip calls netif_rx neither from hardware 
> > interrupt nor from ksoftirqd, so there is no one who would wake 
> > ksoftirqd then. netif_tx calls only 
> > __raise_softirq_irqoff(NET_RX_SOFTIRQ), which sets softirq bit, but 
> > doesn't wake ksoftirqd.
> 
> Dave, 
> 
> can we please get rid of __raise_softirq_irqoff() at all ? These micro
> optimizations are causing more trouble than they are worth.

Actually I think this is pointing out a bug, in that plip is not
invoking things in the proper context, which will likely cause
other problems :-)

I'll put this on my TODO list and look into this.
