Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbYHKVA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbYHKVA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYHKVAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:00:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39272
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbYHKVAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:00:13 -0400
Date: Mon, 11 Aug 2008 14:00:14 -0700 (PDT)
Message-Id: <20080811.140014.94581847.davem@davemloft.net>
To: jkacur@gmail.com
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, rostedt@goodmis.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH] BUG: using smp_processor_id() in preemptible
 [00000000] code: caller is __qdisc_run
From: David Miller <davem@davemloft.net>
In-Reply-To: <520f0cf10808110611y62f6a4e2v94a0d0cde1d5d79d@mail.gmail.com>
References: <520f0cf10808110611y62f6a4e2v94a0d0cde1d5d79d@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John Kacur" <jkacur@gmail.com>
Date: Mon, 11 Aug 2008 15:11:46 +0200

> __qdisc_run() calls qdisc_restart() which calls
> handle_dev_cpu_collision(skb, dev, q); and then the problem shows up
> here:
> __get_cpu_var(netdev_rx_stat).cpu_collision++;
> 
> The solution is to disable interrupts around the above increment. Here
> is an attached patch to do so. (Thank's to Peter Zijlstra for help in
> the analysis and dropping the answer in my lap, so if I got it right
> it is due to his help, but if I messed it up, then I did that part all
> by myself.)

__qdisc_run() always runs in software interrupt context,
so I guess this is some problem with the -rt stuff running
software interrupts in threads?
