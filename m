Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbYDJXlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbYDJXlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbYDJXlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:41:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37225
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbYDJXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:41:07 -0400
Date: Thu, 10 Apr 2008 16:41:06 -0700 (PDT)
Message-Id: <20080410.164106.192045155.davem@davemloft.net>
To: vincent-perrier@club-internet.fr
Cc: jesper.juhl@gmail.com, tilman@imap.cc, lkml@rtr.ca,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1207870334.13150.11.camel@localhost>
References: <1207869029.19683.13.camel@localhost>
	<20080410.161453.52032573.davem@davemloft.net>
	<1207870334.13150.11.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vincent-perrier <vincent-perrier@club-internet.fr>
Date: Fri, 11 Apr 2008 01:32:14 +0200

[ Please use netdev@vger.kernel.org so that this discussion
  reaches the networking develops. ]

> Even if the patch is not good, the line dst_free(&rt->u.dst); 
> when rt is still in tree leads to a crash, but when you do not
> do the dst_free, when rt is in tree, then it may have hidden 
> other bugs, but at least I can keep working.
> 
> 
> I never said my patch was good, but it does the minimum to avoid my bug:
> 
> 
>                 if (fn->leaf == NULL) {
>                         bug_8895_clownix_provisional_workaround = 1;
>                         fn->leaf = rt;
>                         atomic_inc(&rt->rt6i_ref);
>                 }
> ...
> 
> ip6_fib.c, line 796:
> 
>                 if (!bug_8895_clownix_provisional_workaround)
>                         dst_free(&rt->u.dst);
> 
> That way at least it does not crash.
> 
> I cannot provide more than the line and the reason for the crash, I am
> one of the numerous brainless users.

Now that the discussion has reached the mailing list, it won't die in
bugzilla like most such bugs do, and very likely will get fixed
quickly as a result.

Thank you.
