Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYGaTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYGaTcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYGaTcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:32:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51651 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753957AbYGaTcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:32:06 -0400
Date: Thu, 31 Jul 2008 14:32:04 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on
	num_possible_cpus().
Message-ID: <20080731193204.GG9663@sgi.com>
References: <20080731170022.GE9663@sgi.com> <m1prot297c.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1prot297c.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 11:35:19AM -0700, Eric W. Biederman wrote:
> Robin Holt <holt@sgi.com> writes:
> 
> > For large cpu configurations, we find the number of pids in a pidhash
> > bucket cause things like 'ps' to perform slowly.  Raising pidhash_shift
> > from 12 to 16 cut the time for 'ps' in half on a 2048 cpu machine.
> >
> > This patch makes the upper limit scale based upon num_possible_cpus().
> > For machines 128 cpus or less, the current upper limit of 12 is
> > maintained.
> 
> It looks like there is a magic limit we are dancing around.
> 
> Can we please make the maximum for the hash table size be based
> on the maximum number of pids.  That is fls(PID_MAX_LIMIT) - 6?

I am happy to base it upon whatever you think is correct.  So long as it
goes up for machines with lots of cpus, that will satisfy me.  It is
probably as much a problem on smaller machines, but if you have _THAT_
many pids in use, you are probably oversubscribing many other resources
and don't really care.  That limit will essentially become a constant
(compiler may even do that for us but I have not checked any arch other
that ia64).  Should I just replace the 12 with a 16 or 17 or some new
magic number?

Thanks,
Robin
