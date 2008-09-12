Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbYILCF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbYILCF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 22:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYILCFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 22:05:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58984
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754213AbYILCFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 22:05:45 -0400
Date: Thu, 11 Sep 2008 19:05:39 -0700 (PDT)
Message-Id: <20080911.190539.47210177.davem@davemloft.net>
To: tgraf@suug.ch
Cc: vegard.nossum@gmail.com, netdev@vger.kernel.org, penberg@cs.helsinki.fi,
       mingo@elte.hu, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: fix overrun in attribute iteration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080912003522.GN20815@postel.suug.ch>
References: <20080911205933.GA20032@localhost.localdomain>
	<20080911.150434.99620481.davem@davemloft.net>
	<20080912003522.GN20815@postel.suug.ch>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Fri, 12 Sep 2008 02:35:23 +0200

> * David Miller <davem@davemloft.net> 2008-09-11 15:04
> > From: Vegard Nossum <vegard.nossum@gmail.com>
> > Thomas, please review.
> > 
> > > diff --git a/include/net/netlink.h b/include/net/netlink.h
> > > index 18024b8..208fe5a 100644
> > > --- a/include/net/netlink.h
> > > +++ b/include/net/netlink.h
> > > @@ -702,7 +702,7 @@ static inline int nla_len(const struct nlattr *nla)
> > >   */
> > >  static inline int nla_ok(const struct nlattr *nla, int remaining)
> > >  {
> > > -	return remaining >= sizeof(*nla) &&
> > > +	return remaining >= (int) sizeof(*nla) &&
> > >  	       nla->nla_len >= sizeof(*nla) &&
> > >  	       nla->nla_len <= remaining;
> > >  }
> 
> Very nice catch, would never have thought of that.

Applied, thanks everyone.
