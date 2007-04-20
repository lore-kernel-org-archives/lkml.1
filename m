Return-Path: <linux-kernel-owner+w=401wt.eu-S2993308AbXDTTBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993308AbXDTTBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993318AbXDTTBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:01:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993308AbXDTTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:01:44 -0400
Date: Fri, 20 Apr 2007 12:00:36 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take4 2/6] support multiple logging
Message-ID: <20070420120036.2a96cf8d@dxpl.pdx.osdl.net>
In-Reply-To: <20070420182109.GR11115@waste.org>
References: <462605DC.2080804@bx.jp.nec.com>
	<462609D1.50300@bx.jp.nec.com>
	<20070419210813.a599c54f.akpm@linux-foundation.org>
	<46288D11.4000801@bx.jp.nec.com>
	<20070420111526.01ad7f4c.akpm@linux-foundation.org>
	<20070420182109.GR11115@waste.org>
Organization: The Linux Foundation
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 13:21:10 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Fri, Apr 20, 2007 at 11:15:26AM -0700, Andrew Morton wrote:
> > On Fri, 20 Apr 2007 18:51:13 +0900
> > Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> > 
> > > > I started to do some cleanups and fixups here, but abandoned it when it was
> > > > all getting a bit large.
> > > > 
> > > > Here are some fixes against this patch:
> > > 
> > > I'm going to fix my patches by following your reviews and send new patches 
> > > on the LKML and the netdev ML in a few days.
> > > 
> > 
> > Well..  before you can finish this work we need to decide upon what the
> > interface to userspace will be.
> > 
> > - The miscdev isn't appropriate
> > 
> > - netlink remains a possibility
> > 
> > - Stephen suggests an ioctl against a socket and davem suggests socket
> >   options, but it's unclear to me how that socket will get bound to
> >   netconsole?
> 
> Yeah, that's a bit of a head-scratcher.
> 
> > either way, I agree with the overall thrust of this work: netconsole is
> > useful in production environments, can become more useful and will need
> > runtime configurability.
> > 
> > 
> > I wonder if we're approaching this in the right way, however...
> > 
> > At a high level, netconsole is just a flow of UDP packets between two
> > machines.  The kernel already has rich and well-understood ways of creating
> > and configuring such flows.
> > 
> > So...  instead of creating a brand new way of configuring such a flow via
> > sysfs and ioctl, could we instead create a flow using the existing
> > mechanisms (presumably the socket API) and then "transfer" the information
> > from that flow over to netconsole by some means??
> 
> We don't really have anything that corresponds to netpoll's
> connections at higher levels.
> 
> I'm tempted to say we should make this work more like the dummy
> network device. ie:
> 
> modprobe netconsole -o netcon1 [params]
> modprobe netconsole -o netcon2 [params]

The configuration of netconsole's looks like the configuration of routes.
Granted you probably have more routes than netconsoles, but the interface
issues are similar.  Netlink with a small application wouldn't be nice.
And having /proc/net/netconsole (read-only) would be good for the netlink
impaired.
