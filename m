Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYKUJFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYKUJFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 04:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYKUJFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 04:05:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55118
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbYKUJFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 04:05:09 -0500
Date: Fri, 21 Nov 2008 01:05:08 -0800 (PST)
Message-Id: <20081121.010508.40225532.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: mingo@elte.hu, cl@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       efault@gmx.de, a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <49267694.1030506@cosmosbay.com>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com>
	<20081121083044.GL16242@elte.hu>
	<49267694.1030506@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Fri, 21 Nov 2008 09:51:32 +0100

> Now, I wish sockets and pipes not going through dcache, not tbench affair
> of course but real workloads...
> 
> running 8 processes on a 8 way machine doing a 
> 
> for (;;)
> 	close(socket(AF_INET, SOCK_STREAM, 0));
> 
> is slow as hell, we hit so many contended cache lines ...
> 
> ticket spin locks are slower in this case (dcache_lock for example
> is taken twice when we allocate a socket(), once in d_alloc(), another one
> in d_instantiate())

As you of course know, this used to be a ton worse.  At least now
these things are unhashed. :)

