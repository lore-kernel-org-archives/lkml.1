Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbXHJCBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbXHJCBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbXHJCAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:00:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46447 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbXHJCAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:00:42 -0400
Date: Thu, 9 Aug 2007 19:00:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: rcutorture xtime usage
Message-ID: <20070810020040.GK8424@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070810013146.GD18938@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810013146.GD18938@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 03:31:46AM +0200, Adrian Bunk wrote:
> On Thu, Aug 09, 2007 at 01:51:06AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc2-mm1:
> >...
> > +allow-rcutorture-to-handle-synchronize_sched.patch
> >...
> >  2.6.23 queue
> >...
> 
> All drivers were converted to no longer use xtime directly since it 
> might be quite outdated, but this patch adds a usage of xtime.tv_nsec
> as RNG...

This code doesn't care if the time is outdated, as it is simply
periodically perturbing an RNG, but OK.

So, what interface are we supposed to be using instead?  I cannot use
get_random_bytes() due to locking issues.  This is not a cryptographically
secure usage, so the perturbation does not need to be extremely high
quality.

On x86, I would just grab the low-order bits of the TSC, but all of the
world is not an x86.  ;-)

							Thanx, Paul
