Return-Path: <linux-kernel-owner+w=401wt.eu-S1763602AbXKNGMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763602AbXKNGMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbXKNGMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:12:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41189
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757489AbXKNGMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:12:43 -0500
Date: Tue, 13 Nov 2007 22:12:42 -0800 (PST)
Message-Id: <20071113.221242.153352652.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: clameter@sgi.com, netdev@vger.kernel.org, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression
 with tbench
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711140436.24492.nickpiggin@yahoo.com.au>
References: <200711132241.59074.nickpiggin@yahoo.com.au>
	<20071113.175804.151698768.davem@davemloft.net>
	<200711140436.24492.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Wed, 14 Nov 2007 04:36:24 +1100

> On Wednesday 14 November 2007 12:58, David Miller wrote:
> > I suspect the issue is about having a huge skb->data linear area for
> > TCP sends over loopback.  We're likely getting a much smaller
> > skb->data linear data area after the patch in question, the rest using
> > the sk_buff scatterlist pages which are a little bit more expensive to
> > process.
> 
> It didn't seem to be noticeable at 1 client. Unless scatterlist
> processing is going to cause cacheline bouncing, I don't see why this
> hurts more as you add CPUs?

Is your test system using HIGHMEM?

That's one thing the page vector in the sk_buff can do a lot,
kmaps.
