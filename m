Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbXJCEyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbXJCEyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbXJCExz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:53:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbXJCExx (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:53:53 -0400
Date: Tue, 2 Oct 2007 21:53:16 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: pomac@vapor.com, Linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: jumbo frame regression fix
Message-ID: <20071002215316.0faa7676@freepuppy.rosehill>
In-Reply-To: <4702EB4A.4000208@pobox.com>
References: <1191372129.26233.12.camel@localhost>
	<20071002180209.47c350a3@freepuppy.rosehill>
	<4702EB4A.4000208@pobox.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 21:07:22 -0400
Jeff Garzik <jgarzik@pobox.com> wrote:

> Stephen Hemminger wrote:
> > Remove unneeded check that caused problems with jumbo frame sizes.
> > The check was recently added and is wrong.
> > When using jumbo frames the sky2 driver does fragmentation, so
> > rx_data_size is less than mtu.
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> > 
> > --- a/drivers/net/sky2.c	2007-10-02 17:56:31.000000000 -0700
> > +++ b/drivers/net/sky2.c	2007-10-02 17:58:56.000000000 -0700
> > @@ -2163,9 +2163,6 @@ static struct sk_buff *sky2_receive(stru
> >  	sky2->rx_next = (sky2->rx_next + 1) % sky2->rx_pending;
> >  	prefetch(sky2->rx_ring + sky2->rx_next);
> >  
> > -	if (length < ETH_ZLEN || length > sky2->rx_data_size)
> > -		goto len_error;
> > -
> 
> 2.6.23?  2.6.24?  enquiring minds want to know...

2.6.23, since it is a regression

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
