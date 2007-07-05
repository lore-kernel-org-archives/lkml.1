Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbXGEPS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbXGEPS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757256AbXGEPSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:18:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757211AbXGEPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:18:46 -0400
Date: Thu, 5 Jul 2007 08:17:03 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 5/9] netconsole: Introduce dev_status member
Message-ID: <20070705081703.7bcc28bc@oldman>
In-Reply-To: <20070704135642.GB11115@waste.org>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
	<20070704110804.28520.25792.sendpatchset@cselinux1.cse.iitk.ac.in>
	<20070704135642.GB11115@waste.org>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007 08:56:42 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Wed, Jul 04, 2007 at 04:38:04PM +0530, Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > 
> > [5/9] netconsole: Introduce dev_status member
> > 
> > Introduce a new member in netconsole_target that tracks the status (up or
> > down) of the underlying interface network device that the specific logging
> > target netpoll is attached to.
> > 
> > We then join this up with the just-introduced net_device notifier, and
> > introduce NETDEV_UP and NETDEV_DOWN notifications. By disabling the target
> > when the corresponding local interface is down, we save the overhead of
> > unnecessarily disabling interrupts and calling into the netpoll stack in
> > console->write().
> 
> Yuck. 
> 
> > +/*
> > + * Why no net_dev_is_up() in netdevice.h? The kernel could lose a lot of
> > + * weight if only netdevice.h had the good sense to export such a function.
> > + * Oh well ...
> > + */
> > +static inline int net_dev_is_up(struct net_device *net_dev)
> > +{
> > +	return ((net_dev->flags & IFF_UP) == IFF_UP);
> > +}
> 
> Why editorialize? Why not just add this to netdevice.h?
> 
> > +	if (nt->dev_status) {
> 
> Why not simply call net_dev_is_up?

The flags field values are really BSD legacy-ish stuff and should not be
used internally. IFF_UP etc, do not have the necessary atomic properties.

Use netif_running() instead.
