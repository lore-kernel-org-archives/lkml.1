Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYCLNc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYCLNc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYCLNcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:32:22 -0400
Received: from zux006-051-205.adsl.green.ch ([81.6.51.205]:29897 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbYCLNcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:32:21 -0400
X-Greylist: delayed 1451 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 09:32:21 EDT
Date: Wed, 12 Mar 2008 13:11:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080312131133.60e99d29@the-village.bc.nu>
In-Reply-To: <200803102050.40567.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<20080310092213.7ba878b3@core>
	<200803102050.40567.phillips@phunq.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Nice fiction - stuff crashes eventually - not that this isn't useful. For
> > a long time simply loading a 2-3GB Ramdisk off hard disk has been a good
> > way to build things like compile engines where loss of state is not bad.
> 
> Right, and now with ramback you will be able to preserve that state and
> have the performance too.  It is a wonderful world.

Actually no - ramback would be useless to this. You might crash and end
up with untrustworthy on disk state - not worth the risk.

> > Ext3 is only going to help you if the ramdisk writeback respects barriers
> > and ordering rules ?
> 
> I was alluding to to e2fsck's amazing repair ability, not ext3's journal.

Oh you mean "pray hard". e2fsck works well with typical disk style
failures, it is not robust against random chunks vanishing. I know this
as I've worked on and debugged a case where a raid card rebooted silently
and threw out the write back cache.

> > /bin/cp from initrd
> 
> But that does not satisfy the requirement you snipped:

True but its a lot simpler.

> More accurately: in general, cannot transfer directly.  The ramdisk may

DMA ?

> > suck all the content back in presumably a log structure is not a big
> > concern ?
> 
> Sorry, I failed to parse that.

I was suggesting that you want log structure for the writeback disk so
that you keep coherency and can recover it, an issue you seem intent on
ignoring in the interest of speed over any kind of practical usability.
> 
> > >  * Per chunk locking is not feasible for a terabyte scale ramdisk.
> > 
> > And we care  8) ?
> 
> "640K should be enough for anyone"
> 
> http://www.violin-memory.com/products/violin1010.html <- 504 GB ramdisk

Ok so almost nobody cares

> The finer the granularity the faster the ramdisk syncs to backing
> store.  The only attraction of coarse granularity I know of is

False. Disks are ops/second devices not bits/second.

> Your comment re fs chunk size reveals that I have failed to
> communicate the most basic principle of the ramback design: the
> backing store is not expected to represent a consistent filesystem

No I get that. You've ignored the fact I'm suggesting that design choice
is dumb.

> state during normal operation.  Only the ramdisk needs to maintain a
> consistent state, which I have taken care to ensure.  You just need
> to believe in your battery, Linux and the hardware it runs on.  Which
> of these do you mistrust?

In a big critical environment - all three.

Alan
