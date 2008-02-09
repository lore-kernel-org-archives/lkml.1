Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYBILlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYBILlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbYBILli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:41:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:42985 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752775AbYBILlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:41:37 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+8HgchWn+8Tv4tymrxPa2wSjXeMoJJNZsp5Tf4Ib
	Bg4r5LHPzgvzAZ
Date: Sat, 9 Feb 2008 12:41:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] prevent gpio chip drivers from unloading while used
In-Reply-To: <200802081714.18795.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0802091240160.4147@axis700.grange>
References: <Pine.LNX.4.64.0802081159580.5301@axis700.grange>
 <200802081601.10673.david-b@pacbell.net> <Pine.LNX.4.64.0802090132010.8364@axis700.grange>
 <200802081714.18795.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, David Brownell wrote:

> > Yes, that's what I'm saying. I had a GPIO in use and rmmod-ed pca953x. It 
> > did produce an error message
> > 
> > pca953x 0-0041: gpiochip_remove() failed, -16
> > 
> > , but rmmod completed.
> 
> Doesn't that seem buglike to you?
> 
> Oh, right -- the module exit code will ignore that status, it doesn't
> even have a way to report failures any more.  Crap.
> 
> So it looks like we have no choice but to do this.  Can you make sure
> all the rmmod-capable gpio_chip drivers support this?  Ignore the SOC
> support, that never supports rmmod -- just the stuff in drivers/gpio.

As long as you find these two patches acceptable, I'll cook up an 
incremental patch to fix those.

> > AFAIU, the only 2 ways currently to prevent rmmod  
> > from completing, are: increment module use-count, then the respective 
> > module_exit() function is not called at all and rmmod fails with -EBUSY. 
> > Or block in rmmod until the resource becomes free. None of these has 
> > happened. BTW, I think, there's the same problem with i2c adapter drivers.
> 
> Right.  In fact, every time you'd expect driver removal errors to
> cause module removal to fail.   Maybe this is part of that whole
> "should we even *support* rmmod" discussion, which I tuned out.

We don't want to start another one here, do we?:-)

Thanks
Guennadi
---
Guennadi Liakhovetski
