Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYITUDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYITUDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 16:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYITUDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 16:03:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50399
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbYITUDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 16:03:37 -0400
Date: Sat, 20 Sep 2008 13:03:25 -0700 (PDT)
Message-Id: <20080920.130325.56429707.davem@davemloft.net>
To: dwalker@mvista.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
Subject: Re: [PATCH 2/2]: softirq: Add support for triggering softirq work
 on softirqs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1221925413.1343.132.camel@localhost.localdomain>
References: <20080919.234832.127229997.davem@davemloft.net>
	<1221925413.1343.132.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>
Date: Sat, 20 Sep 2008 08:43:33 -0700

> On Fri, 2008-09-19 at 23:48 -0700, David Miller wrote:
> 
> > @@ -6,6 +6,8 @@
> >   *	Distribute under GPLv2.
> >   *
> >   *	Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
> > + *
> > + *	Remote softirq infrastructure is by Jens Axboe.
> >   */
> 
> This goes in the GIT log so I hear, so you shouldn't need to add it to
> the top.. It sounds like your saying Jens is the author, but I'm sure
> you are..

No, Jens wrote this code, I just merely made it generic.
He also deserves a mention at the top of the file.  If
we had left it in the block layer, he would have received
such a mention.

Why the heck does this even bother you?

> This list your adding is rather confusing .. You add to it, but never
> remove anything.. You've got it in the header file, so you must use it
> someplace else .. Then I don't see what else it could be used for other
> than triggering the softirq..

The layers that use this stuff dequeue from their softirq
handler, directly from the list, that's why it's exported.

> This whole patch really needs ifdefs. There's no value here on UP, since
> what other cpu are you going to send softirqs to?

On UP we get a single queue, which the layer needs anyways.
It just always queues to the one queue.

Unlike Andrew's, your review comments have been completely and utterly
useless, as well as a total waste of my time.
