Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbXIESxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbXIESxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 14:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXIESxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 14:53:12 -0400
Received: from panic.printk.net ([217.147.83.20]:46178 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXIESxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 14:53:11 -0400
X-Greylist: delayed 1844 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 14:53:11 EDT
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
From: Jon Masters <jonathan@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Neil Horman <nhorman@tuxdriver.com>, Patrick McHardy <kaber@trash.net>,
       adam@yggdrasil.com, jcm@jonmasters.org,
       netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
In-Reply-To: <1189014097.10802.174.camel@localhost.localdomain>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
	 <1189008806.10802.150.camel@localhost.localdomain>
	 <20070905170831.GA25050@hmsreliant.think-freely.org>
	 <1189014097.10802.174.camel@localhost.localdomain>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Wed, 05 Sep 2007 14:19:23 -0400
Message-Id: <1189016363.12261.122.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 03:41 +1000, Rusty Russell wrote:
> On Wed, 2007-09-05 at 13:08 -0400, Neil Horman wrote:
> > On Thu, Sep 06, 2007 at 02:13:26AM +1000, Rusty Russell wrote:
> > > On Wed, 2007-09-05 at 17:22 +0200, Patrick McHardy wrote:
> > > > But I'm wondering, wouldn't module refcounting alone fix this problem?
> > > > If we make nf_sockopt() call try_module_get(ops->owner), remove_module()
> > > > on ip_tables.ko would simply fail because the refcount is above zero
> > > > (so it would fail at point 3 above). Am I missing something important?
> > > 
> > > Yes, that seems the correct solution to me, too.  ISTR that this code
> > > predates the current module code.
> > > 
> > > Rusty.
> > 
> > Thanks guys-
> > 	When I first started looking at this problem I would have agreed with
> > you, that module reference counting alone would fix the problem.  However,
> > delete_module can work in either a non-blocking or a blocking mode.  rmmod
> > passes O_NONBLOCK to delete module, and so is fine, but modprobe does not.

> 	You have this backwards: O_NONBLOCK is the default.  That seems to be
> what everyone wants, although I implemented 'rmmod -w' because it seemed
> like a good option.

:-)

Thanks for keeping me copied. I'll think about the in-kernel module
situation when I get some time over the weekend - but shout if there's
an external impact sooner! :-)

Jon.


