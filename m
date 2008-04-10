Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbYDJXc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbYDJXc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbYDJXcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:32:20 -0400
Received: from relay-cv.club-internet.fr ([194.158.96.103]:54881 "EHLO
	relay-cv.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYDJXcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:32:19 -0400
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: vincent-perrier <vincent-perrier@club-internet.fr>
To: David Miller <davem@davemloft.net>
Cc: jesper.juhl@gmail.com, tilman@imap.cc, lkml@rtr.ca,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
In-Reply-To: <20080410.161453.52032573.davem@davemloft.net>
References: <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
	 <20080410.154651.101700010.davem@davemloft.net>
	 <1207869029.19683.13.camel@localhost>
	 <20080410.161453.52032573.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 01:32:14 +0200
Message-Id: <1207870334.13150.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2-1pclos2007 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if the patch is not good, the line dst_free(&rt->u.dst); 
when rt is still in tree leads to a crash, but when you do not
do the dst_free, when rt is in tree, then it may have hidden 
other bugs, but at least I can keep working.


I never said my patch was good, but it does the minimum to avoid my bug:


                if (fn->leaf == NULL) {
                        bug_8895_clownix_provisional_workaround = 1;
                        fn->leaf = rt;
                        atomic_inc(&rt->rt6i_ref);
                }
...

ip6_fib.c, line 796:

                if (!bug_8895_clownix_provisional_workaround)
                        dst_free(&rt->u.dst);

That way at least it does not crash.

I cannot provide more than the line and the reason for the crash, I am
one of the numerous brainless users.







On Thu, 2008-04-10 at 16:14 -0700, David Miller wrote:
> From: vincent-perrier <vincent-perrier@club-internet.fr>
> Date: Fri, 11 Apr 2008 01:10:29 +0200
> 
> > I am an end user, I do not know precisely what bisecting means, but I
> > have spent some time on bug 8895, I suppose I have totally bisseced it,
> > but it seems that it has been lost. 
> > It is clearly a bug and I am still patching every kernel to avoid the 
> > fib6 crash, obviously I am the only one to get it.
> 
> I remember this bug.
> 
> The analysis is incorrect and the patch adds new errors.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-net" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> &#0;
> 

