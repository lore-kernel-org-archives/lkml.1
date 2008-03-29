Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbYC2Ewr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbYC2Ewr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 00:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYC2Ewh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 00:52:37 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:57692 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbYC2Ewg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 00:52:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=LjjzEP9Cwx8s4e5NSXWZcqo4EaD/gHADYFP39Guy8WPZAA7BNPbxGSeNaQFcl63y;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Sat, 29 Mar 2008 00:52:26 -0400
From: Bill Fink <billfink@mindspring.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Miller <davem@davemloft.net>, ilpo.jarvinen@helsinki.fi,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH 3/7] [NET]: uninline dev_alloc_skb, de-bloats a lot
Message-Id: <20080329005226.3fe0ea85.billfink@mindspring.com>
In-Reply-To: <200803282334.29975.vda.linux@googlemail.com>
References: <1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi>
	<200803280036.59311.vda.linux@googlemail.com>
	<20080327.175212.119805454.davem@davemloft.net>
	<200803282334.29975.vda.linux@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d264abe436e4951ab085bad153732cb96350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.48.212.104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typo in patch (see below):

On Fri, 28 Mar 2008, Denys Vlasenko wrote:

> On Friday 28 March 2008 01:52, David Miller wrote:
> > From: Denys Vlasenko <vda.linux@googlemail.com>
> > Date: Fri, 28 Mar 2008 00:36:59 +0100
> > 
> > > Can you add a comment which explains the intent?
> > > 
> > > +struct sk_buff *dev_alloc_skb(unsigned int length)
> > > +{
> > > +       /* There is more code here than it seems:
> > > +        * __dev_alloc_skb is an inline */
> > > +	return __dev_alloc_skb(length, GFP_ATOMIC);
> > > +}
> > > +EXPORT_SYMBOL(dev_alloc_skb);
> > 
> > I've applied his patch already, if you want this comment
> > please submit the patch to add it and also please use
> > the correct formatting of the comment.
> 
> Here it is.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> --
> vda
> 
> --- net-2.6.26/net/core/skbuff.c	Fri Mar 28 23:31:05 2008
> +++ net-2.6.26.comment/net/core/skbuff.c	Fri Mar 28 23:33:03 2008
> @@ -277,6 +277,10 @@
>   */
>  struct sk_buff *dev_alloc_skb(unsigned int length)
>  {
> +	/*
> +	 * There is more code here than it seems:
> +	 * __def_alloc_skb is an inline
               ^
               v

> +	 */
>  	return __dev_alloc_skb(length, GFP_ATOMIC);
>  }
>  EXPORT_SYMBOL(dev_alloc_skb);

						-Bill
