Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZASGTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZASGTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 01:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758729AbZASGTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 01:19:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37550
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758426AbZASGTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 01:19:06 -0500
Date: Sun, 18 Jan 2009 22:19:08 -0800 (PST)
Message-Id: <20090118.221908.47032075.davem@davemloft.net>
To: w@1wt.eu
Cc: herbert@gondor.apana.org.au, jarkao2@gmail.com, zbr@ioremap.net,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090119061420.GB12946@1wt.eu>
References: <20090119030844.GA31941@gondor.apana.org.au>
	<20090118.192719.198405397.davem@davemloft.net>
	<20090119061420.GB12946@1wt.eu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Mon, 19 Jan 2009 07:14:20 +0100

> On Sun, Jan 18, 2009 at 07:27:19PM -0800, David Miller wrote:
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Date: Mon, 19 Jan 2009 14:08:44 +1100
> > 
> > > One thing to note is that Myricom's driver probably uses page
> > > frags which means that you're not actually triggering the copy.
> 
> So does this mean that the corruption problem should still there for
> such a driver ? I'm asking before testing, because at these speeds,
> validity tests are not that easy ;-)

It ought not to, but it seems that is the case where you
saw the original corruptions, so hmmm...

Actually, I see, the myri10ge driver does put up to
64 bytes of the initial packet into the linear area.
If the IPV4 + TCP headers are less than this, you will
hit the corruption case even with the myri10ge driver.

So everything checks out.

> > And this is also the only reason why jumbo MTU worked :-)
> 
> What should we expect from other drivers with jumbo frames ? Hangs,
> corruption, errors, packet loss ?

Upon recent review I think jumbo frames in such drivers should
actually be fine.
