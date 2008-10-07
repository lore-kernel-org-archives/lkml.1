Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYJGSay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYJGSay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYJGSaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:30:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54002
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753972AbYJGS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:29:56 -0400
Date: Tue, 07 Oct 2008 11:29:31 -0700 (PDT)
Message-Id: <20081007.112931.144606424.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: dada1@cosmosbay.com, minyard@acm.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, shemminger@vyatta.com,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <1223368290.26330.10.camel@lappy.programming.kicks-ass.net>
References: <48EA8197.6080502@cosmosbay.com>
	<20081006.144002.56418911.davem@davemloft.net>
	<1223368290.26330.10.camel@lappy.programming.kicks-ass.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 07 Oct 2008 10:31:30 +0200

> On Mon, 2008-10-06 at 14:40 -0700, David Miller wrote:
> > From: Eric Dumazet <dada1@cosmosbay.com>
> > Date: Mon, 06 Oct 2008 23:22:31 +0200
> > 
> > > Me wondering what impact this synchronize_rcu() can have on mono-threaded
> > > VOIP applications using lot of UDP sockets. What is the maximum delay of
> > > this function ?
> > 
> > The cost is enormous, we really can't use it here.
> > 
> > I have a patch that did top-level socket destruction using RCU,
> > and that didn't use synchronize_rcu(), and that killed connection
> > rates by up to %20.
> 
> Did you ever figure out why you lost those 20% ?

Probably the RCU delay on a 128 cpu machine :-)

Also I bet batching the socket destruction eliminates all of
the cached local state we have in the cpu at the actual socket
destruction time.
