Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbZAGUvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbZAGUvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZAGUvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:51:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45473
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754432AbZAGUvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:51:31 -0500
Date: Wed, 07 Jan 2009 12:51:33 -0800 (PST)
Message-Id: <20090107.125133.214628094.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: peterz@infradead.org, jack@suse.cz, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, npiggin@suse.de
Subject: Re: Increase dirty_ratio and dirty_background_ratio?
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901070833430.3057@localhost.localdomain>
References: <20090107154517.GA5565@duck.suse.cz>
	<1231345546.11687.314.camel@twins>
	<alpine.LFD.2.00.0901070833430.3057@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Jan 2009 08:39:01 -0800 (PST)

> On Wed, 7 Jan 2009, Peter Zijlstra wrote:
> > 
> > >   So the question is: What kind of workloads are lower limits supposed to
> > > help? Desktop? Has anybody reported that they actually help? I'm asking
> > > because we are probably going to increase limits to the old values for
> > > SLES11 if we don't see serious negative impact on other workloads...
> > 
> > Adding some CCs.
> > 
> > The idea was that 40% of the memory is a _lot_ these days, and writeback
> > times will be huge for those hitting sync or similar. By lowering these
> > you'd smooth that out a bit.
> 
> Not just a bit. If you have 4GB of RAM (not at all unusual for even just a 
> regular desktop, never mind a "real" workstation), it's simply crazy to 
> allow 1.5GB of dirty memory. Not unless you have a really wicked RAID 
> system with great write performance that can push it out to disk (with 
> seeking) in just a few seconds.
> 
> And few people have that.
> 
> For a server, where throughput matters but latency generally does not, go 
> ahead and raise it. But please don't raise it for anything sane. The only 
> time it makes sense upping that percentage is for some odd special-case 
> benchmark that otherwise can fit the dirty data set in memory, and never 
> syncs it (ie it deletes all the files after generating them).
> 
> In other words, yes, 40% dirty can make a big difference to benchmarks, 
> but is almost never actually a good idea any more.

I have to say that my workstation is still helped by reverting this
change and all I do is play around in GIT trees and read email.

It's a slow UltraSPARC-IIIi 1.5GHz machine with a very slow IDE disk
and 2GB of ram.

With the dirty ratio changeset there, I'm waiting for disk I/O
seemingly all the time.  Without it, I only feel the machine seize up
in disk I/O when I really punish it.

Maybe all the dirty I/O is from my not using 'noatime', and if that's
how I should "fix" this then we can ask why isn't it the default? :)

I did mention this when the original changeset went into the tree.

