Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbXEUI3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbXEUI3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXEUI3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:29:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41229
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755963AbXEUI3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:29:02 -0400
Date: Mon, 21 May 2007 01:29:03 -0700 (PDT)
Message-Id: <20070521.012903.18300561.davem@davemloft.net>
To: mingo@elte.hu
Cc: kernel@prachanda.info, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: bad networking related lag in v2.6.22-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070521081201.GB13858@elte.hu>
References: <20070521075824.GA11198@elte.hu>
	<20070521080351.GA13375@elte.hu>
	<20070521081201.GB13858@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 21 May 2007 10:12:01 +0200

> and ... you already did a trace for Thomas, for the softirq problem:
> 
>    http://cybertek.info/taitai/trace.txt.bz2
> 
> this trace shows really bad networking related kernel activities!
> 
> gkrellm-5977 does this at timestamp 0:
> 
>  gkrellm-5977  0..s.    0us : cond_resched_softirq (established_get_next)

So it's not the 3c59x bug :-)

If you have a lot of sockets, there is not way to make
the performance of dumping /proc/net/tcp not suck, use
the netlink socket dumping which is:

1) more efficient even for full dumps
2) allows filtering for the best possible performance
