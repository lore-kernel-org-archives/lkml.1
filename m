Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXCFVGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXCFVGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbXCFVGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:06:38 -0500
Received: from mx1.suse.de ([195.135.220.2]:54521 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbXCFVGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:06:37 -0500
Date: Tue, 6 Mar 2007 13:04:45 -0800
From: Greg KH <greg@kroah.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: kref refcounting breakage in mainline
Message-ID: <20070306210445.GB29164@kroah.com>
References: <20070302005833.949be737.akpm@linux-foundation.org> <20070306002521.GA12164@kroah.com> <1173159802.6955.6.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173159802.6955.6.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 06:43:22AM +0100, Mike Galbraith wrote:
> On Mon, 2007-03-05 at 16:25 -0800, Greg KH wrote:
> 
> > Mike, I've reverted this patch, and I don't see any references leaking.
> > And, as your patch released the reference on the driver, and the
> > module_add_driver() call would not grab a reference to the driver, only
> > the module kobject, I don't see what you were trying to fix with this
> > patch.
> > 
> > Do you have a test case that this fixes?
> 
> What it fixed for me was the hard hang reported below.
> 
> http://lkml.org/lkml/2007/2/16/96

What specific module are you trying to unload that causes the hang?  I
think it might just be a problem with that module, and not with all
others.

So, I'm going to revert your patch and work to try to find the real
cause of this problem.

thanks,

greg k-h
