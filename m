Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYILAfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYILAfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 20:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYILAfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 20:35:05 -0400
Received: from postel.suug.ch ([194.88.212.233]:54341 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbYILAfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 20:35:04 -0400
Date: Fri, 12 Sep 2008 02:35:23 +0200
From: Thomas Graf <tgraf@suug.ch>
To: David Miller <davem@davemloft.net>
Cc: vegard.nossum@gmail.com, netdev@vger.kernel.org, penberg@cs.helsinki.fi,
       mingo@elte.hu, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: fix overrun in attribute iteration
Message-ID: <20080912003522.GN20815@postel.suug.ch>
References: <20080911205933.GA20032@localhost.localdomain> <20080911.150434.99620481.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911.150434.99620481.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller <davem@davemloft.net> 2008-09-11 15:04
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Thomas, please review.
> 
> > diff --git a/include/net/netlink.h b/include/net/netlink.h
> > index 18024b8..208fe5a 100644
> > --- a/include/net/netlink.h
> > +++ b/include/net/netlink.h
> > @@ -702,7 +702,7 @@ static inline int nla_len(const struct nlattr *nla)
> >   */
> >  static inline int nla_ok(const struct nlattr *nla, int remaining)
> >  {
> > -	return remaining >= sizeof(*nla) &&
> > +	return remaining >= (int) sizeof(*nla) &&
> >  	       nla->nla_len >= sizeof(*nla) &&
> >  	       nla->nla_len <= remaining;
> >  }

Very nice catch, would never have thought of that.
