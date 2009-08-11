Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbZHKSxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbZHKSxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZHKSx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:53:29 -0400
Received: from kroah.org ([198.145.64.141]:37674 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbZHKSx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:53:27 -0400
Date: Tue, 11 Aug 2009 11:30:03 -0700
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: mmotm 2009-08-06-00-30 uploaded
Message-ID: <20090811183003.GA4333@kroah.com>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
 <20090807134659.GA2093@darkstar>
 <20090807094944.eed4bfb8.akpm@linux-foundation.org>
 <a8e1da0908080313k65f51185u7329e293a95861a7@mail.gmail.com>
 <20090811140824.GA2067@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090811140824.GA2067@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 10:08:24PM +0800, Dave Young wrote:
> On Sat, Aug 08, 2009 at 06:13:53PM +0800, Dave Young wrote:
> > On Sat, Aug 8, 2009 at 12:49 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > > On Fri, 7 Aug 2009 21:47:00 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> > >
> > >> Hi, andrew
> > >>
> > >> Booting with this release, init (maybe getty?) reports something like:
> > >>
> > >> INIT: open /dev/console failed with input/output error
> > >>
> > >> 2.6.31-rc5 is fine.
> > >>
> > >> Any hints to find the root problem?
> > >
> > > Not really, sorry.  Might be tty changes in linux-next?
> > 
> > I bisected linux-next, find following patch as a result
> > 
> > commit 65b8c7d9be5862ff8ac839607b444b6f6b11d2fb
> > Author: Alan Cox <alan@linux.intel.com>
> > Date:   Thu Aug 6 09:58:02 2009 +1000
> > 
> >     cyclades: use the full port_close function
> > 
> > But, I did not select cyclades in my .config, nor do i have the hardware. Weird.
> 
> The above result is wrong, it's a mistake.
> 
> After a whole day's testing and debugging with linux-2.6 git tree and tty patch series, I found the patch causing this issue. 
> --
> From: Alan Cox <alan@linux.intel.com>
> Subject: tty: make the kref destructor occur asynchronously
> --

So if you revert this one patch, everything goes back to working
properly?

Alan, any ideas?

thanks,

greg k-h
