Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbXKNMKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbXKNMKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbXKNMKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:10:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60408
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754677AbXKNMKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:10:20 -0500
Date: Wed, 14 Nov 2007 04:10:08 -0800 (PST)
Message-Id: <20071114.041008.146131045.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: herbert@gondor.apana.org.au, clameter@sgi.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression
 with tbench
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711141102.11477.nickpiggin@yahoo.com.au>
References: <20071114.031022.183117678.davem@davemloft.net>
	<20071114114844.GA13927@gondor.apana.org.au>
	<200711141102.11477.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Wed, 14 Nov 2007 11:02:11 +1100

> On Wednesday 14 November 2007 22:48, Herbert Xu wrote:
> > On Wed, Nov 14, 2007 at 03:10:22AM -0800, David Miller wrote:
> > > So the thing that's being effected here in TCP is
> > > net/ipv4/tcp.c:select_size(), specifically the else branch:
> >
> > Thanks for the pointer.  Indeed there is a bug in that area.
> > I'm not sure whether it's causing the problem at hand but it's
> > certainly suboptimal.
> >
> > [TCP]: Fix size calculation in sk_stream_alloc_pskb
> 
> This looks like it fixes the problem!

Great, thanks for testing.  I'll apply Herbert's patch tomorrow
as I've already sent Linus a bug fix pull request tonight.

> Still interested to know why SLAB didn't see the same thing...

Yes, I wonder why too.  I bet objects just got packed differently.

There is this fugly "LOOPBACK_OVERHEAD" macro define in
drivers/net/loopback.c that is trying to figure out the
various overheads that we should subtract from the loopback
MTU we use by default.

It's almost guarenteed to be wrong for the way the allocators
work now.
