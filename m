Return-Path: <linux-kernel-owner+w=401wt.eu-S1765177AbXKPEHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765177AbXKPEHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 23:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757192AbXKPEHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 23:07:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56400
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756801AbXKPEHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 23:07:15 -0500
Date: Thu, 15 Nov 2007 20:07:14 -0800 (PST)
Message-Id: <20071115.200714.109055797.davem@davemloft.net>
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, dada1@cosmosbay.com
Subject: Re: [NET]: rt_check_expire() can take a long time, add a
 cond_resched()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071115193802.4ec64eef@laptopd505.fenrus.org>
References: <200711150401.lAF41mSs021898@hera.kernel.org>
	<20071115193802.4ec64eef@laptopd505.fenrus.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Thu, 15 Nov 2007 19:38:02 -0800

> On Thu, 15 Nov 2007 04:01:48 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> >     Using a "if (need_resched())" test before calling
> > "cond_resched();" is necessary to avoid spending too much time doing
> > the resched check. 
> 
> int __sched cond_resched(void)
> {
>         if (need_resched() &&  .....
> 
> somehow I wonder why the second if() is useful at all; it's another
> spot for a branch predictor to miss... and a void function call is
> really really cheap... 

Not by Eric's tests.  Please read the thread, he checked and it's
50ms more expensive to make the function call.

Please, when you notice something interesting in something flying
by on git-web, go check thing out we probably discussed the thing
you're interested in.

And please at least CC: netdev about networking patches, and also the
patch author, which I've corrected in this reply.
