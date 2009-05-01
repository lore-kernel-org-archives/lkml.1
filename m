Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbZEAQ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbZEAQ6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZEAQ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:58:10 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:42188 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZEAQ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:58:08 -0400
X-IronPort-AV: E=Sophos;i="4.40,280,1238976000"; 
   d="scan'208";a="161036098"
Date: Fri, 1 May 2009 09:58:03 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-scsi@cuplxvomd02.corp.sa.net,
       netdev@cuplxvomd02.corp.sa.net
Subject: Re: [PATCH 1/5] KERNEL: Support asynchronously-discovered boot
	devices, v4 (resend)
Message-ID: <20090501165803.GA13342@cuplxvomd02.corp.sa.net>
References: <20090430140559.a2343f7c.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0904301712450.31375-100000@netrider.rowland.org> <20090430145412.c1386cb2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430145412.c1386cb2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 02:54:12PM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2009 17:19:34 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > > I wonder if we can think of something more new ad unique.  startupdev?  yuk.
> > 
> > Initdev?  Or does that mean something else also?
...
> initdev sounds good to me.  Given that we're adding a new and distinct
> concept which will remain with us for a long time, we should name it
> with care.

Yes, we do need a good name, so we are now guaranteed to be entering
the Bike Shed Zone. Personally, I'm fine with initdev and will assume this
is the name going forward. I'll tweak the patches appropriately.

> > Really, these are devices that we want to have working before starting
> > up any userspace processes.  These would be the console device(s) (so
> > that the first process has open files for its stdin, stdout, and
> > stderr) and the block device containing the root filesystem (if the
> > initramfs image doesn't make its own arrangements).
> 
> OK, so "initdev" could be viewed as meaning "a device which /sbin/init
> needs"?  Even I can understand that.
> 
> But /sbin/init isn't the first userspace we run, is it?  There's
> initramfs stuff, firmware loaders, etc.
> 
> What's the story here?  Do we intend that all initdevs be up and
> running before _any_ userspace runs?  Or is /sbin/init the red line?

I've avoided making any guarantees about this, but /sbin/init is implicitly
the red line. If we make this explicit, we're probably back in the vicinity
of the bike shed, but this should help frame any subsequent discussion
in a concrete manner.

David VomLehn
