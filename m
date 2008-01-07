Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYAGQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYAGQgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbYAGQgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:36:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:50983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbYAGQgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:36:08 -0500
Date: Mon, 7 Jan 2008 07:44:04 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Brownell <david-b@pacbell.net>,
       Dave Young <hidave.darkstar@gmail.com>, stern@rowland.harvard.edu,
       peterz@infradead.org, davem@davemloft.net, jarkao2@gmail.com,
       krh@redhat.com, dbrownell@users.sourceforge.net,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       cbou@mail.ru, dwmw2@infradead.org,
       linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Message-ID: <20080107154404.GA10880@suse.de>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com> <20080107020944.GA3637@darkstar.te-china.tietoenator.com> <20080107084528.GA8365@suse.de> <200801070101.15168.david-b@pacbell.net> <478227D5.8050402@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478227D5.8050402@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 02:23:33PM +0100, Stefan Richter wrote:
> David Brownell wrote:
> > On Monday 07 January 2008, Greg KH wrote:
> >> Most of the non-driver core code should be converted to not use the
> >> lock in the class at all.  They should use a local lock instead.
> > 
> > Or better yet, that yet-to-be-written class_for_each_instance()
> > iterator ... :)
> 
> By far most of the usages of class.semaphore or class.mutex in drivers
> are to protect the class.devices list.  The only? right thing to do
> there is to keep using the class.{semaphore,mutex}.  The more elegant
> variation of this would be David's class_for_each_instance() iterator
> which would allow us to hide the locking details from the drivers.

If such functionality is needed, fine, I have no objection to that
change to move the locking logic into the driver core.

thanks,

greg k-h
