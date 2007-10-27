Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXJ0CmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXJ0CmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 22:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbXJ0CmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 22:42:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49045 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbXJ0Cl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 22:41:59 -0400
Date: Fri, 26 Oct 2007 19:40:33 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Message-ID: <20071027024033.GB29039@kroah.com>
References: <1191407872.5572.7.camel@lappy> <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins> <1193411451.2431.13.camel@lov.site> <1193412147.27652.2.camel@twins> <1193412788.2431.22.camel@lov.site> <1193412836.27652.11.camel@twins> <1193414147.2431.35.camel@lov.site> <1193429066.5648.35.camel@lappy> <1193447889.5648.44.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193447889.5648.44.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 03:18:08AM +0200, Peter Zijlstra wrote:
> 
> On Fri, 2007-10-26 at 22:04 +0200, Peter Zijlstra wrote:
> > This crashes and burns on bootup, but I'm too tired to figure out what I
> > did wrong... will give it another try tomorrow..
> 
> Ok, can't sleep.. took a look. I have several problems here.
> 
> The thing that makes it go *boom* is the __ATTR_NULL. Removing that
> makes it boot. Albeit it then warns me of multiple duplicate sysfs
> objects, all named "bdi".
> 
> For some obscure reason this device interface insists on using the
> bus_id as name (?!), and further reduces usability by limiting that to
> 20 odd characters.
> 
> This makes it quite useless. I tried fudging around that limit by using
> device_rename and kobject_rename, but to no avail.
> 
> Really, it should not be this hard to use, trying to expose a handfull
> of simple integers to userspace should not take 8h+ and still not work.
> 
> Peter, who thinks sysfs is contorted mess beyond his skill. I'll stick
> to VM and scheduler code, that actually makes sense.

Heh, that's funny :)

I'll look at this and see what I can come up with.  Would you just like
a whole new patch, or one against this one?

thanks,

greg k-h
