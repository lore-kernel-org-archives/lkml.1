Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbXJ0QIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbXJ0QIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbXJ0QIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:08:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56856 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXJ0QIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:08:00 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <20071027160203.GA5709@kroah.com>
References: <1193410087.6914.34.camel@twins>
	 <1193411451.2431.13.camel@lov.site> <1193412147.27652.2.camel@twins>
	 <1193412788.2431.22.camel@lov.site> <1193412836.27652.11.camel@twins>
	 <1193414147.2431.35.camel@lov.site> <1193429066.5648.35.camel@lappy>
	 <1193447889.5648.44.camel@lappy> <20071027024033.GB29039@kroah.com>
	 <1193474399.27652.15.camel@twins>  <20071027160203.GA5709@kroah.com>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 18:07:18 +0200
Message-Id: <1193501238.5648.75.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-10-27 at 09:02 -0700, Greg KH wrote:

> Ah, I see a few problems.  Here, try this version instead.  It's
> compile-tested only, and should be a lot simpler.
> 
> Note, we still are not setting the parent to the new bdi structure
> properly, so the devices will show up in /sys/devices/virtual/ instead
> of in their proper location.  To do this, we need the parent of the
> device, which I'm not so sure what it should be (block device?  block
> device controller?)

The problem is that not every bdi has a sysfs represented parent, hence
the class suggestion. For block devices it is indeed the block device
itself, but for example the NFS client's server descriptor does not have
a sysfs representation.

> Let me know if this works better, I'm off to a kids birthday party for
> the day, but will be around this evening...

Hehe, do enjoy! Thanks.


