Return-Path: <linux-kernel-owner+w=401wt.eu-S966210AbXDCTlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966210AbXDCTlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966212AbXDCTlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:41:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966210AbXDCTlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:41:08 -0400
Date: Tue, 3 Apr 2007 15:40:58 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403194058.GD355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403174457.GA15704@linux-os.sc.intel.com> <46129619.8050107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46129619.8050107@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:59:53AM -0700, Ulrich Drepper wrote:
> Siddha, Suresh B wrote:
> > Not all of the cpu* directories in /sys/devices/system/cpu may be
> > online.
> 
> Brilliant.  You people really know how to create user interfaces.  So
> now in any case per CPU another stat/access syscall is needed to check
> the 'online' pseudo-file?  With this the readdir solution is only
> marginally faster than parsing /proc/cpuinfo which means, it's
> unacceptably slow.

Note that glibc actually parses /proc/stat in preference of /proc/cpuinfo
ATM, because /proc/stat is at least uniform while parsing /proc/cpuinfo
needs a special parser for each architecture.  And /proc/stat reading
is even slower than /proc/cpuinfo, on x86_64 reading/parsing /proc/stat
takes about 450usec, while e.g. stat64 on /sys/devices/system/cpu
is just 2.5usec.
But if that can't be trusted as the number of online CPUs, can
somebody please add a short file to proc or sysfs which will contain
the number of online and number of configured CPUs?

See e.g. http://openmp.org/pipermail/omp/2007/000714.html
where the first time after second g++ invocation is with omp_set_dynamic (1)
and ought to be about as fast as omp_set_dynamic (0) case with the same
number of threads, but it is far slower due to slow
sysconf (_SC_NPROCESSORS_ONLN).

	Jakub
