Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbYAGNyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbYAGNyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYAGNyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:54:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:30009 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYAGNyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZmYHz+Gx1JIfEDRk+QhXxuEdZ0Pe9BkrY53ZsxKJ13UZMPSYqh7Yl0gg3btpxUlPrNS3Ldeo+aumNvYrdd2Udwn2vGKCfodVDoEglvBBmohcfenyBWkp23Ysbedf+S7OGSfG5rXWPz6okxvAd4xGE9HHxi1dgGU9b+heVor3Nw0=
Date: Mon, 7 Jan 2008 15:00:14 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
       Dave Young <hidave.darkstar@gmail.com>, stern@rowland.harvard.edu,
       peterz@infradead.org, davem@davemloft.net, krh@redhat.com,
       dbrownell@users.sourceforge.net, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, cbou@mail.ru, dwmw2@infradead.org,
       linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Message-ID: <20080107140014.GA2961@ff.dom.local>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com> <20080107020944.GA3637@darkstar.te-china.tietoenator.com> <20080107084528.GA8365@suse.de> <200801070101.15168.david-b@pacbell.net> <478227D5.8050402@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478227D5.8050402@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
> 
> -------
> ?)  Well, another correct thing to do would be to not take any locks or
> mutexes in the driver core but instead let the drivers do the necessary
> serialization between calls like class_device_add() and the likes and
> list iterations.  But this would complicate the API because of the
> additional locking requirements, and hence would invariably result in
> buggy usages of the API.
> -- 

I hope I'm wrong, but IMHO it should be safer not to mix such changes,
so do the mutexes first or delay them until the end. Otherwise some
false blaming seems almost inevitable.

Regards,
Jarek P.
