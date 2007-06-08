Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbXFHS6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbXFHS6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXFHS6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:58:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43898 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXFHS6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:58:46 -0400
Date: Fri, 8 Jun 2007 11:57:10 -0700
From: Greg KH <greg@kroah.com>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: Richard Hughes <hughsient@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
Message-ID: <20070608185710.GB14372@kroah.com>
References: <1180710270.3782.5.camel@localhost.localdomain> <1180712592.6390.139.camel@localhost.localdomain> <1180713579.12843.8.camel@localhost.localdomain> <1180715004.6390.169.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180715004.6390.169.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 05:23:24PM +0100, Richard Purdie wrote:
> On Fri, 2007-06-01 at 16:59 +0100, Richard Hughes wrote:
> > On Fri, 2007-06-01 at 16:43 +0100, Richard Purdie wrote:
> > > I accept this is basically out of my hands now. Greg/Kay have the
> > > appropriate emails and if they'll let me know which approach they want
> > > to take, I'll apply an appropriate patch. I'd suggest not applying this
> > > patch directly as it introduces a race in the error path it alters.
> > 
> > Sure, I really wanted to convert the class to struct device (which I'm
> > more familiar with) but just tried to do minimal changes. What changes
> > need to be made to avoid a race? Thanks.
> 
> It has nothing to do with the struct device vs. class devices, you need
> to think more carefully about the placement of the list_del().
> 
> My other concerns with this patch are that it exports incorrect
> information on spitz (which I had warned about and I will get bug
> reports about) and that "description" is not really a suitable name for
> a sysfs attribute, "function" might give a better idea of what it
> represents to developers.
> 
> I still question whether either colour or function properties are
> actually particularly useful to userspace other than for naming purposes
> which is why they were part of the device name.
> 
> Anyhow, I'm trying not to say too much more as it will just go in
> circles. I'll await a reply from Greg.

Hm, I thought I made my opinion pretty clear in the beginning.

Why not just do a simple:
	led01
	led02
	led03
	...

and so on?

And use the 'name' field to put the name of your device (disk,
bluetooth, etc.)  This is the way all other busses and devices work, and
I don't think that LEDs are anything more "special" than anything else
in the kernel, right?

So the original patch in this thread is close, but not quite there.

thanks,

greg k-h
