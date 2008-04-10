Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYDJXvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYDJXvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbYDJXvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:51:12 -0400
Received: from relay-ev.club-internet.fr ([194.158.96.209]:57224 "EHLO
	relay-ev.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbYDJXvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:51:11 -0400
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: vincent-perrier <vincent-perrier@club-internet.fr>
To: David Miller <davem@davemloft.net>
Cc: jesper.juhl@gmail.com, tilman@imap.cc, lkml@rtr.ca,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080410.164106.192045155.davem@davemloft.net>
References: <1207869029.19683.13.camel@localhost>
	 <20080410.161453.52032573.davem@davemloft.net>
	 <1207870334.13150.11.camel@localhost>
	 <20080410.164106.192045155.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 01:51:03 +0200
Message-Id: <1207871463.13528.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2-1pclos2007 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to you, and also to Jesper for the "git bisect" explanation,
you have powerfull tools, it is all for the best, millions of users
are relying on you!

On Thu, 2008-04-10 at 16:41 -0700, David Miller wrote:
> From: vincent-perrier <vincent-perrier@club-internet.fr>
> Date: Fri, 11 Apr 2008 01:32:14 +0200
> 
> [ Please use netdev@vger.kernel.org so that this discussion
>   reaches the networking develops. ]
> 
> > Even if the patch is not good, the line dst_free(&rt->u.dst); 
> > when rt is still in tree leads to a crash, but when you do not
> > do the dst_free, when rt is in tree, then it may have hidden 
> > other bugs, but at least I can keep working.
> > 
> > 
> > I never said my patch was good, but it does the minimum to avoid my bug:
> > 
> > 
> >                 if (fn->leaf == NULL) {
> >                         bug_8895_clownix_provisional_workaround = 1;
> >                         fn->leaf = rt;
> >                         atomic_inc(&rt->rt6i_ref);
> >                 }
> > ...
> > 
> > ip6_fib.c, line 796:
> > 
> >                 if (!bug_8895_clownix_provisional_workaround)
> >                         dst_free(&rt->u.dst);
> > 
> > That way at least it does not crash.
> > 
> > I cannot provide more than the line and the reason for the crash, I am
> > one of the numerous brainless users.
> 
> Now that the discussion has reached the mailing list, it won't die in
> bugzilla like most such bugs do, and very likely will get fixed
> quickly as a result.
> 
> Thank you.
> &#0;
> 

