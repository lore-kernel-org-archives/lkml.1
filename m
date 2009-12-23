Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZLWRSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZLWRSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZLWRSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:18:10 -0500
Received: from kroah.org ([198.145.64.141]:55867 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZLWRSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:18:07 -0500
Date: Wed, 23 Dec 2009 09:17:31 -0800
From: Greg KH <greg@kroah.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression, 2.6.33-rc1->current git] NULL pointer in
 usb_serial_probe() introduced by the recent kfifo changes
Message-ID: <20091223171731.GA7535@kroah.com>
References: <200912230251.31568.rjw@sisk.pl>
 <20091223053734.GC22808@kroah.com>
 <1261555848.22729.41.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261555848.22729.41.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 09:10:48AM +0100, Stefani Seibold wrote:
> Am Dienstag, den 22.12.2009, 21:37 -0800 schrieb Greg KH:
> > On Wed, Dec 23, 2009 at 02:51:31AM +0100, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > Something like the patch below is necessary to fix a new NULL pointer deref
> > > in usb_serial_probe() that appeared after the recent kfifo changes (in short,
> > > the kfifo changes modified the semantics of kfifo_alloc() that
> > > usb_serial_probe() reiled on).
> > 
> > What semantic changed?  I thought that the kfifo patches came with
> > patches that also fixed up any changed that were needed.  What went
> > wrong here?
> > 
> 
> This one is a new user of the kfifo API, so it forget to port it to the
> new kfifo API.
> 
> Please make the write_fifo in place. Here is my patch to fix the
> regression and full ported version.

Thanks, I'll queue this up and send it to Linus later today.

greg k-h
