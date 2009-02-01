Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbZBAImU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbZBAImU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 03:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZBAImB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 03:42:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52762
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbZBAImA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 03:42:00 -0500
Date: Sun, 01 Feb 2009 00:41:57 -0800 (PST)
Message-Id: <20090201.004157.222535435.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: jarkao2@gmail.com, zbr@ioremap.net, w@1wt.eu, dada1@cosmosbay.com,
       ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH v3] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090127071130.GA29125@gondor.apana.org.au>
References: <20090125.212203.15909648.davem@davemloft.net>
	<20090127071130.GA29125@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 27 Jan 2009 18:11:30 +1100

> David Miller <davem@davemloft.net> wrote:
> > From: Jarek Poplawski <jarkao2@gmail.com>
> > Date: Thu, 22 Jan 2009 09:04:42 +0000
> > 
> >> It seems this sk_sndmsg_page usage (refcounting) isn't consistent.
> >> I used here tcp_sndmsg() way, but I think I'll go back to this question
> >> soon.
> > 
> > Indeed, it is something to look into, as well as locking.
> > 
> > I'll try to find some time for this, thanks Jarek.
> 
> After a quick look it seems to be OK to me.  The code in the patch
> is called from tcp_splice_read, which holds the socket lock.  So as
> long as the patch uses the usual TCP convention it should work.

I've tossed Jarek's patch into net-next-2.6, thanks everyone.
