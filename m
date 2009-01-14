Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbZANEZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbZANEZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZANEZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:25:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58013
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbZANEZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:25:31 -0500
Date: Tue, 13 Jan 2009 20:25:31 -0800 (PST)
Message-Id: <20090113.202531.43266519.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: zbr@ioremap.net, dada1@cosmosbay.com, w@1wt.eu, ben@zeus.com,
       jarkao2@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090114035124.GA8409@gondor.apana.org.au>
References: <20090113.163705.130074998.davem@davemloft.net>
	<20090114035124.GA8409@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 14 Jan 2009 14:51:24 +1100

> Unfortunately this won't work, not even for network destinations.
> 
> The reason is that this gets called as soon as the destination's
> splice hook returns, for networking that means when sendpage returns.
> 
> So by that time we'll still be left with just a page reference
> on a page where the slab memory may already have been freed.
> 
> To make this work we need to get the destination's splice hooks
> to acquire this reference.

Yes I realized this after your earlier posting today.
