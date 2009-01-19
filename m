Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbZASD20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbZASD20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 22:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbZASD2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 22:28:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57164
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbZASD2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 22:28:14 -0500
Date: Sun, 18 Jan 2009 19:28:15 -0800 (PST)
Message-Id: <20090118.192815.41774176.davem@davemloft.net>
To: w@1wt.eu
Cc: herbert@gondor.apana.org.au, jarkao2@gmail.com, zbr@ioremap.net,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090119004206.GA10396@1wt.eu>
References: <20090115234408.GA1693@1wt.eu>
	<20090115.155434.206643894.davem@davemloft.net>
	<20090119004206.GA10396@1wt.eu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Mon, 19 Jan 2009 01:42:06 +0100

> Hi guys,
> 
> On Thu, Jan 15, 2009 at 03:54:34PM -0800, David Miller wrote:
> > From: Willy Tarreau <w@1wt.eu>
> > Date: Fri, 16 Jan 2009 00:44:08 +0100
> > 
> > > And BTW feel free to add my Tested-by if you want in case you merge
> > > this fix.
> > 
> > Done, thanks Willy.
> 
> Just for the record, I've now re-integrated those changes in a test kernel
> that I booted on my 10gig machines. I have updated my user-space code in
> haproxy to run a new series of tests. Eventhough there is a memcpy(), the
> results are EXCELLENT (on a C2D 2.66 GHz using Myricom's Myri10GE NICs) :
> 
>   - 4.8 Gbps at 100% CPU using MTU=1500 without LRO
>     (3.2 Gbps at 100% CPU without splice)
> 
>   - 9.2 Gbps at 50% CPU using MTU=1500 with LRO
> 
>   - 10 Gbps at 20% CPU using MTU=9000 without LRO (7 Gbps at 100% CPU without
>     splice)
> 
>   - 10 Gbps at 15% CPU using MTU=9000 with LRO

Thanks for the numbers.

We can almost certainly do a lot better, so if you have the time and
can get some oprofile dumps for these various cases that would be
useful to us.

Thanks again.
