Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbXI3UWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbXI3UWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXI3UWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:22:32 -0400
Received: from thunk.org ([69.25.196.29]:44658 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXI3UWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:22:31 -0400
Date: Sun, 30 Sep 2007 16:22:25 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <ak@suse.de>
Cc: Joshua Brindle <method@manicmethod.com>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20070930202225.GC9358@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Andi Kleen <ak@suse.de>,
	Joshua Brindle <method@manicmethod.com>,
	Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
	torvalds@linux-foundation.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>
References: <46FEEBD4.5050401@schaufler-ca.com> <200709301939.57542.ak@suse.de> <20070930190742.GB9358@thunk.org> <200709302205.58017.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709302205.58017.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 10:05:57PM +0200, Andi Kleen wrote:
> > but a cluster of Linux machines in a rack is roughly the same size of
> > a huge Unix server tens year ago --- and it's not like Ethernet is any
> > more secure than the PCI bus.  
> 
> PCI busses normally don't have routers to networks outside the box connected
> to them. 

The whole *point* is that the routers are interconnecting boxes inside
the cluster, and none of them connect to the outside world.  It's no
different than a SCSI cable connecting to JBOD in a separate box, or a
Fiber Channel router connected to a SAN network connecting to a
storrage array.  The SCSI or FC buses aren't encrypted either, and the
in the Fiber channel case we have a router --- yet people aren't
stressing out that we're not encrpying the traffic over the Storage
Area Network?  Why?  Because it's understood the network stays inside
the machine room.  The same thing can true for Ethernet --- think
iSCSI, for example.

> > So don't be so quick to dismiss something like 
> > CIPSO out of hand, just because it doesn't use IPSEC.
> 
> With your argumentation we could also just disable all security
> in these situations (as in null LSM to save some overhead); after all these 
> systems are protected by armed guards.  If someone gets past the guards
> they could connect their laptop to the network and fake all the "secured"
> packets. If you assume that won't happen why do you need computer security at all?

If you get past all of the guards, you can usually reboot in single
user mode, and get root anyway.  If you have physical access to the
computer, you're generally doomed anyway, unless you are willing to
pay the cost of encrypting everything on every single disk platter.
(And yes, in the more paranoid environments, where it's too expensive
to have 7x24 armed guards, maybe that makes sense.)

The point of something like CIPSO is because you want to label the
packets so the otherside knows how they should be treated.  We don't
encrypt unix permission bits on most on-disk filesystems, either.  Yet
I haven't heard people saying that just because someone could break
into a machine room, disconnect the JBOD from the computer, hook up
the JBOD to their laptop, and futz with the Unix permission bits,
rehook up the JBOD and reboot, that Unix permission bits are useless,
and we should leave all files at mode 777 --- since clearly we're not
secure against someone who can break into the machine room.....  

I *hope* that sounds absurd, right?

					- Ted

