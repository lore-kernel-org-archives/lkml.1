Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZHBXuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZHBXuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 19:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZHBXuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 19:50:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38910 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZHBXuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 19:50:17 -0400
Date: Sun, 2 Aug 2009 19:50:05 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Scott James Remnant <scott@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern
Message-ID: <20090802235004.GA11903@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <1248880382.23840.78.camel@quest> <20090729201857.GC17410@hmsreliant.think-freely.org> <1249071610.4800.5.camel@wing-commander> <20090801134146.GA19910@localhost.localdomain> <1249151332.6731.5.camel@wing-commander> <20090802002217.GA3012@localhost.localdomain> <1249220996.3638.0.camel@wing-commander>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249220996.3638.0.camel@wing-commander>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 02:49:56PM +0100, Scott James Remnant wrote:
> On Sat, 2009-08-01 at 20:22 -0400, Neil Horman wrote:
> 
> > On Sat, Aug 01, 2009 at 07:28:52PM +0100, Scott James Remnant wrote:
> > > On Sat, 2009-08-01 at 09:41 -0400, Neil Horman wrote:
> > > 
> > > > > > Not without additional work.  If init crashed in the initramfs, I don't think
> > > > > > theres a way to handle that.  If it crashes at some later time, I think it just
> > > > > > gets restarted IIRC.  I'm sure you can change that behavior, but this patch
> > > > > > doesn't address that.
> > > > > > 
> > > > > When the system init daemon crashes, the kernel PANICs.  When not using
> > > > > core_pattern, this is ok, we get a core file - when using apport, as far
> > > > > as I can tell it never waits for apport to finish so we don't get the
> > > > > crash.
> > > > > 
> > > > This is non-sensical.  If init crashes, and the kernel panics, you'll only get a
> > > > core by sheer luck and good fortune.
> > > > 
> > > Or by being a bit clever.  Upstart catches the SIGSEGV and the signal
> > > handler forks a child process, unmasking the signal in that child
> > > process with no signal handler installed.
> > > 
> > I don't see how this works.  How is upstart (which by definition is a child of
> > init (pid 1)) going to catch a SIGSEGV from its parent?  How would any process
> > catch a signal targeted to its parent?
> > 
> Upstart *is* /sbin/init (pid 1)
> 
Ah, so basically, you catch sigsegv, and in the handler fork a child, and return
from the handler in the pid, so that the child crashes.  Yeah, I don't see why
that won't work with this patch.  If pid 1 waits for its child to crash, then
you should serialize on the collection of the core via the pipe.  Of couse, pid
1 will have to make sure that all the sysctls are set appropriately before it
encounters a crash.
Neil

> Scott
> -- 
> Scott James Remnant
> scott@ubuntu.com


