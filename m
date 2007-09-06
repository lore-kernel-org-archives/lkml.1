Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbXIFBAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbXIFBAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 21:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbXIFBA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 21:00:28 -0400
Received: from panic.printk.net ([217.147.83.20]:48966 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbXIFBA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 21:00:27 -0400
Subject: Re: [PATCH 2/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
From: Jon Masters <jonathan@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Neil Horman <nhorman@tuxdriver.com>, adam@yggdrasil.com,
       jcm@jonmasters.org, kaber@trash.net,
       netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
In-Reply-To: <1189032069.10802.212.camel@localhost.localdomain>
References: <20070904203053.GC19083@hmsreliant.think-freely.org>
	 <1189023999.12261.147.camel@jcmlaptop>
	 <1189032069.10802.212.camel@localhost.localdomain>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Wed, 05 Sep 2007 20:58:10 -0400
Message-Id: <1189040290.12261.172.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 08:41 +1000, Rusty Russell wrote:
> On Wed, 2007-09-05 at 16:26 -0400, Jon Masters wrote:
> > On Tue, 2007-09-04 at 16:30 -0400, Neil Horman wrote:
> > 
> > > 	2nd of two patches.  This patch enhances modprobe to operate like rmmod
> > > in non-blocking mode.  It also adds a -w option to allow for explicit blocking
> > > operation.
> > 
> > As I suspected, this patch isn't in the tree. I am going to commit it
> > now because it makes sense. I'm also going to sort out moving things to
> > kernel.org this afternoon while I'm at it - I don't want to confuse
> > people with kerneltools.org any more now I've got a kernel.org acc.
> 
> 1) You don't want to hand the "wait" flag (ie ~O_NONBLOCK) to
> sub-rmmods,
> 
> 2) You need to do something about this code if wait is specified:
> 
> 	if (usecount != 0) {
> 		if (!ignore_inuse)
> 			error("Module %s is in use.\n", name);
> 		goto remove_rest;
> 	}

Goodness, I suck. I'll get it fixed properly.

Jon.


