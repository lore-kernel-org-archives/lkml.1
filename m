Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZGLJiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZGLJiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 05:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZGLJhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 05:37:54 -0400
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:38383 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751333AbZGLJhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 05:37:53 -0400
X-Yahoo-Newman-Id: 536827.91574.bm@omp423.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fziKxwZAew5oxA+l5BfWo02FwRTwW5WUInEUZJ8epP+PBZs/LJhO5K8s8MwiEsVplvMEvJ7qd1k5L226uOlxYRHHI2A+bDXWcAAfJQRIC0JwNmjKSwV7+rTuedTNK7nuzKy6kDsbx4eDaXHSDeqWqHT4qZ9VZXqmStcoCfjl5lM=  ;
X-YMail-OSG: 9Y9_OKMVM1lCOLBQK0XflX84cfSTsbPlo69cOdqFUR.Ng9ziB9MQEYLDI4m4RbKZeuuk9mIut5eZ_aeXdDgoi2bsUaybmHjyWdhTNHxjm1X2m81FNJQ4hF2F0Tt4DU4BgSszm3iNybZwayv1bbYpmOYWcEbYb_0APmkuIdF3wQEqB_DjFPjx3jBPINPAH7IiBQE8rno.3XE9alvZOkNK1hyt1.K7iHyDy0CVZ_XTXsi5.Hdg4Yun.CTPmm5X495hH9NS_JG34rWXBp4I8H8tQ44F8j13FlPVnBxMcQ3nzoMMBGSul6lV
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Date: Sun, 12 Jul 2009 02:37:51 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <20090711170548.GC5205@suse.de> <200907111530.44736.david-b@pacbell.net> <20090712083510.GA24424@pengutronix.de>
In-Reply-To: <20090712083510.GA24424@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907120237.51595.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 July 2009, Uwe Kleine-König wrote:
> 
> > Repeat -- NAK on this.  Use platform_driver_probe() instead.
> > 
> > I really don't like this series of patches.  It's just adding
> > bloat to kernels, in chunks of up to a page per patch.
>
> I'm aware that in some cases platform_driver_probe is better.

Make that "most cases".  It's rare that platform devices get
hotplugged.  Mostly they're set up at system init ... often
it's all done by the time arch_initcall() finishes.


> But as I 
> don't have access to most of the affected platforms I consider it saver.
> That's why I choosed this way.

You do have access to the source tree, and a powerful little
tool called "grep -r" ... which can easily tell you where the
devices for those platforms are defined.  And thus let you see
if a given one happens to be one of the exceptional cases where
platform_driver_probe() won't work.


> The problem with platform_driver_probe 
> is that if a device is added only after the driver is probed the
> device isn't bound.

That's rarely a problem though; it certainly isn't in the case of
the $SUBJECT driver, and others on that platform.  I've pointed
that out to you before.



