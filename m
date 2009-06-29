Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbZF2J15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbZF2J15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbZF2J1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:27:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41009 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723AbZF2J1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:27:43 -0400
Date: Mon, 29 Jun 2009 11:27:41 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] net: fix race in the receive/select
Message-ID: <20090629092741.GB3845@jolsa.lab.eng.brq.redhat.com>
References: <alpine.DEB.1.10.0906251858520.9517@makko.or.mcafeemobile.com> <4A443033.8060401@gmail.com> <alpine.DEB.1.10.0906251947530.9517@makko.or.mcafeemobile.com> <20090626135742.GB3845@redhat.com> <alpine.DEB.1.10.0906261018580.16400@makko.or.mcafeemobile.com> <20090626145027.GA6534@redhat.com> <4A474FB5.4070901@gmail.com> <4A475266.9040203@gmail.com> <20090628180412.GA9171@redhat.com> <20090628214846.GB4584@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090628214846.GB4584@ami.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 11:48:46PM +0200, Jarek Poplawski wrote:
> On Sun, Jun 28, 2009 at 08:04:12PM +0200, Oleg Nesterov wrote:
> > On 06/28, Jarek Poplawski wrote:
> ...
> > > Hmm... of course:
> > >
> > > static inline void sock_poll_wait(struct file * filp, struct sock *sk, poll_table *p)
> > > {
> > >  	if (p && sk->sk_sleep) {
> > >  		__poll_wait(filp, sk->sk_sleep, p);
> > >  		/*
> > >  		 * fat comment
> > >  		 */
> > >  		smp_mb(); // or smp_mb__after_unlock();
> > >  	}
> > > }
> > 
> > Perhaps it makes sense to check ->sk_sleep != NULL in sock_poll_wait(), but
> > I don't think we need __poll_wait(). poll_wait() is inline, I think gcc
> > will optimize out "if (p && wait_address)" check if poll_wait() is called
> > from sock_poll_wait().
> 
> Sure, to me it looks a bit more readable, but let Jiri choose.;-)
> 
> Cheers,
> Jarek P. 

yes :) I like more Jarek's way.. and I'll send separate patch for the
smp_mb_after_lock change.

thanks,
jirka
