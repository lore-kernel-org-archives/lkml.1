Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540AbXCGFjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbXCGFjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 00:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbXCGFjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 00:39:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:33341 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751540AbXCGFjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 00:39:09 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ONIYfVgjOqHOJCYbQ8XJueCx9vgtcDYiba2Vivz
	DB4lo4ssv4Wo39
Subject: Re: kref refcounting breakage in mainline
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070306210445.GB29164@kroah.com>
References: <20070302005833.949be737.akpm@linux-foundation.org>
	 <20070306002521.GA12164@kroah.com>
	 <1173159802.6955.6.camel@Homer.simpson.net>
	 <20070306210445.GB29164@kroah.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 06:38:57 +0100
Message-Id: <1173245937.6613.26.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 13:04 -0800, Greg KH wrote:
> On Tue, Mar 06, 2007 at 06:43:22AM +0100, Mike Galbraith wrote:
> > On Mon, 2007-03-05 at 16:25 -0800, Greg KH wrote:
> > 
> > > Mike, I've reverted this patch, and I don't see any references leaking.
> > > And, as your patch released the reference on the driver, and the
> > > module_add_driver() call would not grab a reference to the driver, only
> > > the module kobject, I don't see what you were trying to fix with this
> > > patch.
> > > 
> > > Do you have a test case that this fixes?
> > 
> > What it fixed for me was the hard hang reported below.
> > 
> > http://lkml.org/lkml/2007/2/16/96
> 
> What specific module are you trying to unload that causes the hang?  I
> think it might just be a problem with that module, and not with all
> others.

It's ipmi_si that's hanging, waits for completion that never comes.

> So, I'm going to revert your patch and work to try to find the real
> cause of this problem.

Yeah, my stab at it seems busted.  I'll take another poke at it to see
if I can find out why (post 725522b5453dd680412f2b6463a988e4fd148757)
I'm left with a reference.

	-Mike

