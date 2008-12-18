Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYLRW37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYLRW37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYLRW3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:29:50 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:37022 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750746AbYLRW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:29:49 -0500
Date: Thu, 18 Dec 2008 22:29:36 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: GPIO: Fix probe() error return in gpio driver probes
Message-ID: <20081218222936.GI8032@fluff.org.uk>
References: <20081212152426.745254309@fluff.org.uk> <20081215101616.GB12431@fluff.org.uk> <20081215112226.18f7fb29@hyperion.delvare> <200812181016.28184.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812181016.28184.david-b@pacbell.net>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 10:16:27AM -0800, David Brownell wrote:
> On Monday 15 December 2008, Jean Delvare wrote:
> > 
> > > > > I was thinking that -EINVAL is almost the least informative
> > > > > diagnostic code possible, since so many places return it
> > > > > that it's usually hard to find out *which* invalid parameter
> > > > > triggered ...
> > > > > 
> > > > > Is there a less-overloaded code you could return?
> > > > 
> > > > -EINVAL sounds right to me, all that's really missing is dev_dbg()
> > > > messages in the drivers to log what the exact problem was. 
> 
> Fair enough, though it just papers over how ambiguous -EINVAL is.

Unforunately there's not a lot of choice in errno.h for other options.
 
> > > It might be more acceptable to be dev_err(), that way it will get
> > > printed no matter what debug options have been selected. If so, a
> > > seperate patch is probably in order to make the change.
> > 
> > As far as I can see, such errors would be caused by development-time
> > mistakes, so dev_dbg() seems appropriate. dev_err() would make the
> > binaries larger for all end-users.
> 
> Right, dev_dbg() is the way to go.  I'd ack a version of this patch
> which pairs these -EINVAL changes with dev_dbg() messages to make
> these problems less painful to track down.  dev_err() is much abused.

Ok, I'll try and sort that out for you as soon as possible.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
