Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZA3WEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZA3WEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbZA3WDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:03:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57766
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753004AbZA3WDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:03:49 -0500
Date: Fri, 30 Jan 2009 14:03:46 -0800 (PST)
Message-Id: <20090130.140346.159984249.davem@davemloft.net>
To: w@1wt.eu
Cc: jarkao2@gmail.com, zbr@ioremap.net, herbert@gondor.apana.org.au,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090130215920.GC31355@1wt.eu>
References: <20090127074048.GA4197@ff.dom.local>
	<20090130.134227.123379239.davem@davemloft.net>
	<20090130215920.GC31355@1wt.eu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Fri, 30 Jan 2009 22:59:20 +0100

> On Fri, Jan 30, 2009 at 01:42:27PM -0800, David Miller wrote:
> > It's cheesy and the SLAB developers will likely barf at the
> > idea, but it would certainly work.
> 
> Maybe that would be enough as a definitive fix for a stable
> release, so that we can go on with deeper changes in newer
> versions ?

Such a check could have performance ramifications, I wouldn't
risk it and already I intend to push Jarek's page allocator
splice fix back to -stable eventually.

> > Back to real life, I think long term the thing to do is to just do the
> > cached page allocator thing we'll be doing after Jarek's socket page
> > patch is integrated, and for best performance the driver has to
> > receive it's data into pages, only explicitly pulling the ethernet
> > header into the linear area, like NIU does.
> 
> Are there NICs out there able to do that themselves or does the
> driver need to rely on complex hacks in order to achieve this ?

Any NIC, even the dumbest ones, can be made to receive into pages.
