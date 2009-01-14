Return-Path: <linux-kernel-owner+w=401wt.eu-S1751593AbZANKGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbZANKGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZANKGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:06:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56294
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbZANKGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:06:36 -0500
Date: Wed, 14 Jan 2009 02:06:37 -0800 (PST)
Message-Id: <20090114.020637.181791518.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: herbert@gondor.apana.org.au, zbr@ioremap.net, dada1@cosmosbay.com,
       w@1wt.eu, ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090114094215.GC4234@ff.dom.local>
References: <20090114085308.GB4234@ff.dom.local>
	<20090114.012919.117682429.davem@davemloft.net>
	<20090114094215.GC4234@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 14 Jan 2009 09:42:16 +0000

> On Wed, Jan 14, 2009 at 01:29:19AM -0800, David Miller wrote:
> > From: Jarek Poplawski <jarkao2@gmail.com>
> > Date: Wed, 14 Jan 2009 08:53:08 +0000
> > 
> > > Actually, I still think my second approach (the PageSlab) is probably
> > > (if tested) the easiest for now, because it should fix the reported
> > > (Willy's) problem, without any change or copy overhead for splice to
> > > file (which could be still wrong, but not obviously wrong).
> > 
> > It's a simple fix, but as Herbert stated it leaves other ->sendpage()
> > implementations exposed to data corruption when the from side of the
> > pipe buffer is a socket.
> 
> I don't think Herbert meant other ->sendpage() implementations, but I
> could miss something.

I think he did :-)

Or, more generally, he could have been referring to splice pipe
outputs.  All of these things grab references to pages and
expect that to keep the underlying data from being reallocated.

That doesn't work for this skb->data case.

> > That, to me, is almost worse than a bad fix.
> > 
> > It's definitely worse than a slower but full fix, which the copy
> > patch is.
> 
> Sorry, I can't see how this patch could make sendpage worse.

Because that patch only fixes TCP's ->sendpage() implementation.

There are others out there which could end up experiencing similar
data corruption.
