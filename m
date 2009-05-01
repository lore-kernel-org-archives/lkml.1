Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbZEAQNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbZEAQNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZEAQM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:12:56 -0400
Received: from kroah.org ([198.145.64.141]:33265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbZEAQMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:12:55 -0400
Date: Fri, 1 May 2009 09:09:51 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wedgwood <cw@f00f.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090501160951.GA17433@kroah.com>
References: <1241097822.2516.3.camel@poy> <20090501065754.GA30626@puku.stupidest.org> <20090501140108.GA20846@kroah.com> <20090501155342.GA28350@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501155342.GA28350@puku.stupidest.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 08:53:42AM -0700, Chris Wedgwood wrote:
> On Fri, May 01, 2009 at 07:01:08AM -0700, Greg KH wrote:
> 
> > Right now it does, and it takes about 1-2 seconds to do so depending
> > on the hardware.
> 
> The code I have only does block devices right now, but it could do
> more.  Even if it was 10x slower it wouldn't be close to 1-2 seconds.

You usually need to do more.  We started out just only doing block
devices, but you also need the memory devices, and console, and a few
others as well.

After all that, you have already written another tool, which seems like
overkill when we can do it all in the kernel so much easier and simpler.

> > Which is over double the time it takes to boot the kernel entirely
> > these days, so it is quite noticable.
> 
> So the kernel takes 500-1000ms then?  That seems really high.

Yes, we can boot a kernel in 500-1000ms on some pretty low end, crappy
disk controller/device laptops these days.  Yes, it's not as fast as we
would like it, but we are working on making it even faster.  I think
Arjan has some pending patches to resolve some of the remaining issues
that are present for machines with "legacy" input devices that we need
to get merged.

thanks,

greg k-h
