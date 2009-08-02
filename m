Return-Path: <linux-kernel-owner+w=401wt.eu-S1751693AbZHBAW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbZHBAW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 20:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZHBAW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 20:22:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56200 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZHBAWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 20:22:22 -0400
Date: Sat, 1 Aug 2009 20:22:17 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Scott James Remnant <scott@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern
Message-ID: <20090802002217.GA3012@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <1248880382.23840.78.camel@quest> <20090729201857.GC17410@hmsreliant.think-freely.org> <1249071610.4800.5.camel@wing-commander> <20090801134146.GA19910@localhost.localdomain> <1249151332.6731.5.camel@wing-commander>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249151332.6731.5.camel@wing-commander>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 01, 2009 at 07:28:52PM +0100, Scott James Remnant wrote:
> On Sat, 2009-08-01 at 09:41 -0400, Neil Horman wrote:
> 
> > > > Not without additional work.  If init crashed in the initramfs, I don't think
> > > > theres a way to handle that.  If it crashes at some later time, I think it just
> > > > gets restarted IIRC.  I'm sure you can change that behavior, but this patch
> > > > doesn't address that.
> > > > 
> > > When the system init daemon crashes, the kernel PANICs.  When not using
> > > core_pattern, this is ok, we get a core file - when using apport, as far
> > > as I can tell it never waits for apport to finish so we don't get the
> > > crash.
> > > 
> > This is non-sensical.  If init crashes, and the kernel panics, you'll only get a
> > core by sheer luck and good fortune.
> > 
> Or by being a bit clever.  Upstart catches the SIGSEGV and the signal
> handler forks a child process, unmasking the signal in that child
> process with no signal handler installed.
> 
I don't see how this works.  How is upstart (which by definition is a child of
init (pid 1)) going to catch a SIGSEGV from its parent?  How would any process
catch a signal targeted to its parent?

> So it's really a child of init that core dumps, just ignore the signal
> handler off the top of the stack trace and it's just as good as a core
> dump from the init daemon itself.
> 
Ok, setting asside that I don't see how you can do what your describing above,
if you're forking a crashing process so that it crashes in exactly the same way,
that makes a bit of sense.

> Meanwhile the real init daemon (pid 1) wait()s on its child, and then
> once it's reaped it exits itself - and then the kernel PANICs.
> 
> 
> This works just fine with ordinary core files, because the kernel does
> at least write out the core file beforehand.  With apport we don't get
> this wait, thus I was hoping your patch would have that effect.
> 
Well, again setting asside that I don't see how you're doing what you say above,
my patch does what you're hoping it does.  It can be configured to wait on the
crashing processes until its the pipe reader is exited.

Neil

> Scott
> -- 
> Scott James Remnant
> scott@ubuntu.com


