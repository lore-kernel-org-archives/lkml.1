Return-Path: <linux-kernel-owner+w=401wt.eu-S2992897AbXDDOxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992897AbXDDOxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992900AbXDDOxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:53:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47335 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992897AbXDDOxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:53:09 -0400
Date: Wed, 4 Apr 2007 09:51:45 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: getting processor numbers
Message-ID: <20070404145145.GA24831@sgi.com>
References: <461286D6.2040407@redhat.com> <20070403131623.c6831607.akpm@linux-foundation.org> <20070403190458.18165884.pj@sgi.com> <20070404064732.GF355@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404064732.GF355@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Apr 04, 2007 at 02:47:32AM -0400, Jakub Jelinek wrote:
> On Tue, Apr 03, 2007 at 07:04:58PM -0700, Paul Jackson wrote:
> > There are really at least four "number of CPUs" answers here, and we
> > should be aware of which we are providing.  There are, in order of
> > decreasing size:
> >  1) the size of the kernels cpumask_t (NR_CPUS),
> >  2) the maximum number of CPUs that might ever be hotplugged into a
> >     booted system,
> >  3) the current number of CPUs online in that system, and
> >  4) the number of CPUs that the current task is allowed to use.
>
> sysconf(_SC_NPROCESSORS_CONF) should IMHO return (2) (this currently
> scans /proc/cpuinfo on alpha and sparc{,64} for ((ncpus|CPUs) probed|cpus detected)
> and for the rest just returns sysconf(_SC_NPROCESSORS_ONLN)).
> Neither of the sysconf returned values should be affected by affinity.

I'm looking at an ia64 system, and when a cpu is hot-unplugged it is removed
from /proc/cpuinfo.  Wouldn't /sys/devices/system/cpu/ be a better
source for 2) ?

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
