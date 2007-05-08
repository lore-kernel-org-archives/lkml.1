Return-Path: <linux-kernel-owner+w=401wt.eu-S967352AbXEHLp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967352AbXEHLp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967321AbXEHLpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:45:54 -0400
Received: from lazybastard.de ([212.112.238.170]:44267 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967171AbXEHLpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:45:53 -0400
Date: Tue, 8 May 2007 13:41:30 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 0/2] LogFS take two
Message-ID: <20070508114129.GA20637@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <1178609977.3042.288.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1178609977.3042.288.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 09:39:37 +0200, Thomas Gleixner wrote:
> 
> > Motivation 2:
> > 
> > Flash is becoming increasingly common in standard PC hardware.  Nearly
> > a dozen different manufacturers have announced Solid State Disks
> > (SSDs), the OLPC and the Intel Classmate no longer contain hard disks
> > and ASUS announced a flash-only Laptop series for regular consumers.
> 
> With a hardware controller which allows no direct access to the flash.
> 
> > And that doesn't even mention the ubiquitous USB-Sticks, SD-Cards,
> > etc.
> 
> which again do not allow direct access to the flash

I know that and I have talked to manufacturers.  Not allowing direct
access is common practice today, but I didn't encounter much opposition
against allowing it in the future.  What appears to be holding them back
is that there would be absolutely no value in it right now.  With direct
flash access, which filesystem should users choose for their 32GB SSD?

> > Flash behaves significantly different to hard disks.  In order to use
> > flash, the current standard practice is to add an emulation layer and
> > an old-fashioned hard disk filesystem.  As can be expected, this is
> > eating up some of the benefits flash can offer over hard disks.
> > 
> > In principle it is possible to achieve better performance with a flash
> > filesystem than with the current emulated approach. 
> 
> Err, where does JFFS2 use a block emulation layer ?

It doesn't.  Motivation 2 is about SSDs, USB sticks, SD-Cards, etc.
JFFS2 is motivation 1.

> Are you going to make logfs play with UBI ?

It is not very high on my priority list.

> > Handling of read/write/erase errors currently is BUG().  It is on my
> > list, no need to remind me. :)
> > 
> > Overall I consider this to be -mm material.
> 
> I don't. It seems fs developers tend to have their own view of how to
> get stuff mainline.

Maybe.  My view is that I have to solve any problems found until people
consider the code good enough by whatever metric.  The final criterium
appears to be quite fuzzy.

> The code is far from being useful on real world hardware. The error
> handling via BUG() is just making it useless. 

On NOR hardware?  How many write/erase failures does one commonly
encounter there?  Those things will need to get sorted, sure.  But
I doubt whether LogFS is useless on _all_ hardware because of this.

> Also please fix the coding style and other issues from the seperate
> review.

Sure.

> Some useful comments would make a functional review way easier.

Common problem.  Implementor doesn't know what comments would be useful
and reviewer doesn't know where to start without useful comments.  I
will try to add some and would love to see suggestions.

> >   It would be good to get
> > some review and have the usual allyesconfig crowd build it 
> 
> make allyesconfig does not work for you ?

It does.  But I don't have a coverity license, just to give one example.

Jörn

-- 
The wise man seeks everything in himself; the ignorant man tries to get
everything from somebody else.
-- unknown
