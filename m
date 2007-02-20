Return-Path: <linux-kernel-owner+w=401wt.eu-S964919AbXBTOeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919AbXBTOeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964936AbXBTOeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:34:16 -0500
Received: from mail.screens.ru ([213.234.233.54]:49734 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964919AbXBTOeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:34:15 -0500
Date: Tue, 20 Feb 2007 17:34:12 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? net/bridge/br_if.c: fix use after free in port_carrier_check()
Message-ID: <20070220143412.GC155@tv-sign.ru>
References: <20070219221125.GA5070@tv-sign.ru> <20070218214359.GA4226@tv-sign.ru> <8462.1171884453@redhat.com> <20070219115955.GB91@tv-sign.ru> <18581.1171968296@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18581.1171968296@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, David Howells wrote:
> 
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> >  static void release_nbp(struct kobject *kobj)
> >  {
> >  	struct net_bridge_port *p
> >  		= container_of(kobj, struct net_bridge_port, kobj);
> > +
> > +	dev_put(p->dev);
> 
> Does this need to be done with the mutex held?

I think no. At least the current code does dev_put() without mutex held.

>                                                     And does anything actually pay
> attention to the refcount on dev?  I assume not...

I guess net/core/dev.c:netdev_wait_allrefs(), but not sure.

> Should you clear p->dev->br_port before calling dev_put()?

Looks like it is protected by RCU... Anyway the current code does the same.

> Looks reasonable.  I like it.
> 
> Acked-By: David Howells <dhowells@redhat.com>

Thanks! I'll re-send with a proper changelog later today.

Oleg.

