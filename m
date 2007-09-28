Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbXI1SFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbXI1SFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXI1SFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:05:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbXI1SE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:04:59 -0400
Date: Fri, 28 Sep 2007 11:04:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: corbet@lwn.net (Jonathan Corbet)
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Chakri n" <chakriin5@gmail.com>
Subject: Re: A unresponsive file system can hang all I/O in the system on
 linux-2.6.23-rc6 (dirty_thresh problem?)
Message-Id: <20070928110445.69e687c0.akpm@linux-foundation.org>
In-Reply-To: <10659.1190986132@lwn.net>
References: <20070927235034.ae7bd73d.akpm@linux-foundation.org>
	<10659.1190986132@lwn.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 07:28:52 -0600 corbet@lwn.net (Jonathan Corbet) wrote:

> Andrew wrote:
> > It's unrelated to the actual value of dirty_thresh: if the machine fills up
> > with dirty (or unstable) NFS pages then eventually new writers will block
> > until that condition clears.
> > 
> > 2.4 doesn't have this problem at low levels of dirty data because 2.4
> > VFS/MM doesn't account for NFS pages at all.
> 
> Is it really NFS-related?  I was trying to back up my 2.6.23-rc8 system
> to an external USB drive the other day when something flaked and the
> drive fell off the bus.  That, too, was sufficient to wedge the entire
> system, even though the only thing which needed the dead drive was one
> rsync process.  It's kind of a bummer to have to hit the reset button
> after the failure of (what should be) a non-critical piece of hardware.
> 
> Not that I have a fix to propose...:)
> 

That's a USB bug, surely.  What should happen is that the kernel attempts
writeback, gets an IO error and then your data gets lost.

