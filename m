Return-Path: <linux-kernel-owner+w=401wt.eu-S1765668AbZEAU0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765668AbZEAU0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762203AbZEAU0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:26:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761667AbZEAU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:26:35 -0400
Date: Fri, 1 May 2009 13:22:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-scsi@cuplxvomd02.corp.sa.net,
       netdev@cuplxvomd02.corp.sa.net
Subject: Re: [PATCH 1/5] KERNEL: Support asynchronously-discovered boot
 devices, v4 (resend)
Message-Id: <20090501132258.672002ee.akpm@linux-foundation.org>
In-Reply-To: <20090501165803.GA13342@cuplxvomd02.corp.sa.net>
References: <20090430140559.a2343f7c.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0904301712450.31375-100000@netrider.rowland.org>
	<20090430145412.c1386cb2.akpm@linux-foundation.org>
	<20090501165803.GA13342@cuplxvomd02.corp.sa.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 09:58:03 -0700
David VomLehn <dvomlehn@cisco.com> wrote:

> On Thu, Apr 30, 2009 at 02:54:12PM -0700, Andrew Morton wrote:
> > On Thu, 30 Apr 2009 17:19:34 -0400 (EDT)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > > I wonder if we can think of something more new ad unique.  startupdev?  yuk.
> > > 
> > > Initdev?  Or does that mean something else also?
> ...
> > initdev sounds good to me.  Given that we're adding a new and distinct
> > concept which will remain with us for a long time, we should name it
> > with care.
> 
> Yes, we do need a good name, so we are now guaranteed to be entering
> the Bike Shed Zone.

Getting the name right is important!  We live with the decision daily,
for years.

> Personally, I'm fine with initdev and will assume this
> is the name going forward. I'll tweak the patches appropriately.

OK.

> > > Really, these are devices that we want to have working before starting
> > > up any userspace processes.  These would be the console device(s) (so
> > > that the first process has open files for its stdin, stdout, and
> > > stderr) and the block device containing the root filesystem (if the
> > > initramfs image doesn't make its own arrangements).
> > 
> > OK, so "initdev" could be viewed as meaning "a device which /sbin/init
> > needs"?  Even I can understand that.
> > 
> > But /sbin/init isn't the first userspace we run, is it?  There's
> > initramfs stuff, firmware loaders, etc.
> > 
> > What's the story here?  Do we intend that all initdevs be up and
> > running before _any_ userspace runs?  Or is /sbin/init the red line?
> 
> I've avoided making any guarantees about this, but /sbin/init is implicitly
> the red line. If we make this explicit, we're probably back in the vicinity
> of the bike shed, but this should help frame any subsequent discussion
> in a concrete manner.

Well, decisions which are made here can make the difference between
"computer boots" and "computer doesn't boot".  That ain't bikeshed
painting.

