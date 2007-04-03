Return-Path: <linux-kernel-owner+w=401wt.eu-S966091AbXDCSLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966091AbXDCSLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966104AbXDCSLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:11:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38255 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966091AbXDCSLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:11:01 -0400
Date: Tue, 3 Apr 2007 20:11:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403181100.GE23689@one.firstfloor.org>
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403173505.GD23689@one.firstfloor.org> <461292BF.5020803@redhat.com> <20070403175827.GA24033@one.firstfloor.org> <4612977D.4060903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4612977D.4060903@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 11:05:49AM -0700, Ulrich Drepper wrote:
> Andi Kleen wrote:
> >> There is an inexpensive solution: finally make the vdso concept a bit
> >> more flexible.  You could add a vdso call to get the processor count.
> >> The vdso code itself can use a data page mapped in from the kernel.
> > 
> > The ELF aux vector is exactly that already.
> 
> No.  The aux vector cannot be changed after the process is changed.  The
> memory belong to the process and not the kernel.  It must be possible at
> any time to get the correct information even if the system changed.

That's probably debatable, but ok.

I would be opposed for adding another page per process at least
because the per process memory footprint in Linux is imho already
too large.
 
> >> This page (read-only at userlevel) would contain global information such
> >> as processor count and topology.
> > 
> > You would still need an event notification mechanism, won't you?
> 
> No, why?  The vdso call would be so inexpensive (just a simple function
> call) that it can be done whenever a topology-based decision has to be
> made.  Use cookies to determine whether nothing has been changed since
> the last call etc.

But how would that mix with the OpenMP use case where you have
thread pools that normally don't make decisions afer startup, but 
just stay around? I think for those you would need events of some sort
to start or remove threads as needed. 

Asking the kernel every time you submit some work to the threads
would probably not fly.
 
> > If you want it cheap look for some other way.
> 
> Well, who's brace enough to submit sys_sysconf() again?

If there's a good use case fine for me. However I suspect it's
either "slow is ok" or "want it very fast" where even a syscall
would hurt.

-Andi
