Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbXDJJ4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbXDJJ4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 05:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXDJJ4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 05:56:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45016 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753349AbXDJJ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 05:56:42 -0400
Date: Tue, 10 Apr 2007 04:56:39 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
Message-ID: <20070410095639.GB17269@lnx-holt.americas.sgi.com>
References: <20070409020600.6338BD82F4@pipsqueak.sf.frob.com> <m11wit34fo.fsf@ebiederm.dsl.xmission.com> <20070409173053.GD22997@lnx-holt.americas.sgi.com> <m1r6qtyskk.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6qtyskk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 06:35:39PM -0600, Eric W. Biederman wrote:
> Robin Holt <holt@sgi.com> writes:
> 
> > OK.  I just got the OK from management.  The system we were booting was
> > for research only.  We had NR_CPUS=num_online_cpus()=4096 which were
> > non-hyperthreaded.  With no attached I/O and the tweak I originally
> > posted plus one change Jack has already gotten accepted, the machine
> > booted in approx 12 minutes.
> 
> How much of that time was between the time the kernel was loaded
> and before user space was started?

I am scrambling for my timed boot logs.  All I am finding right now
are boots from 512p machines.  For that machine, it took 178 seconds
to get to mounting the root filesystem and 75 seconds to get to the
login prompt.  Of that 75 seconds, 24 was because an NFS server was
down and 14 was due to PBS taking time to start.


68.994913| Memory: 2074872032k/2082172528k available (9785k code, 7319136k reserved, 5228k data, 672k init)
36.566117| migration_cost=3869,61218,76048
24.074113| mount: RPC: Remote system error - No route to host
13.972892| PBS mom

Those are the long standouts.  There are quite a few lines in the boot
output which take 2 seconds or less, but none of those are too surprising.
Plain and simply, booting that large of a machine has always taken
considerable time.  The first time we booted a 512p, it took nearly an
hour, now that is down to 8 or 9 minutes.

>
> Twelve minutes sounds like a long time for a boot, if you aren't fsck'ing
> filesystems.

Not fsck'ing filesystems (xfs).  One of the NFS servers that was specified
in /etc/fstab was missing, but that is unimportant.

Thanks,
Robin
