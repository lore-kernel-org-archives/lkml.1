Return-Path: <linux-kernel-owner+w=401wt.eu-S932734AbXA1SDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbXA1SDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 13:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbXA1SDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 13:03:06 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:58332
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXA1SDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 13:03:05 -0500
Date: Sun, 28 Jan 2007 10:01:32 -0800
To: "Martin J. Bligh" <mbligh@mbligh.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@hill9.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: lockmeter
Message-ID: <20070128180132.GA1647@gnuppy.monkey.org>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128152404.GB9196@elte.hu> <45BCD4C9.2030302@mbligh.org> <20070128170407.GA1526@infradead.org> <45BCDF88.2020504@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BCDF88.2020504@mbligh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 09:38:16AM -0800, Martin J. Bligh wrote:
> Christoph Hellwig wrote:
> >On Sun, Jan 28, 2007 at 08:52:25AM -0800, Martin J. Bligh wrote:
> >>Mmm. not wholly convinced that's true. Whilst i don't have lockmeter
> >>stats to hand, the heavy time in __d_lookup seems to indicate we may
> >>still have a problem to me. I guess we could move the spinlocks out
> >>of line again to test this fairly easily (or get lockmeter upstream).
> >
> >We definitly should get lockmeter in.  Does anyone volunteer for doing
> >the cleanup and merged?
> 
> On second thoughts .. I don't think it'd actually work for this since
> the locks aren't global. Not that it shouldn't be done anyway, but ...
> 
> ISTR we still thought dcache scalability was a significant problem last
> time anyone looked at it seriously - just never got fixed. Dipankar?

My lock stat stuff shows dcache to a be a problem under -rt as well. It
is keyed off the same mechanism as lockdep. It's pretty heavily hit
under even normal loads relative to other kinds of lock overhead even
for casual file operations on a 2x system. I can't imagine how lousy
it's going to be under real load on a 8x or higher machine.

However, this pathc is -rt only and spinlock times are meaningless under
it because of preemptiblity.

bill

