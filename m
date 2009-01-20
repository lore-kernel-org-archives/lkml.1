Return-Path: <linux-kernel-owner+w=401wt.eu-S1761752AbZATRQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761752AbZATRQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758004AbZATRQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:16:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38361
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757925AbZATRQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:16:14 -0500
Date: Tue, 20 Jan 2009 09:16:16 -0800 (PST)
Message-Id: <20090120.091616.224452074.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: zbr@ioremap.net, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090120110144.GB17004@ff.dom.local>
References: <20090120102053.GA17004@ff.dom.local>
	<20090120103122.GC9167@ioremap.net>
	<20090120110144.GB17004@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Tue, 20 Jan 2009 11:01:44 +0000

> On Tue, Jan 20, 2009 at 01:31:22PM +0300, Evgeniy Polyakov wrote:
> > On Tue, Jan 20, 2009 at 10:20:53AM +0000, Jarek Poplawski (jarkao2@gmail.com) wrote:
> > > Good question! Alas I can't check this soon, but if it's really like
> > > this, of course this needs some better idea and rework. (BTW, I'd like
> > > to prevent here as much as possible some strange activities like 1
> > > byte (payload) packets getting full pages without any accounting.)
> > 
> > I believe approach to meet all our goals is to have own network memory
> > allocator, so that each skb could have its payload in the fragments, we
> > would not suffer from the heavy fragmentation and power-of-two overhead
> > for the larger MTUs, have a reserve for the OOM condition and generally
> > do not depend on the main system behaviour.
> 
> 100% right! But I guess we need this current fix for -stable, and I'm
> a bit worried about safety.

Jarek, we already have a page and offset you can use.

It's called sk_sndmsg_page but that is just the (current) name.
Nothing prevents you from reusing it for your purposes here.
