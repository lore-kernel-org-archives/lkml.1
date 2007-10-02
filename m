Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbXJBH43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbXJBH43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbXJBH4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:56:21 -0400
Received: from waste.org ([66.93.16.53]:33448 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbXJBH4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:56:20 -0400
Date: Tue, 2 Oct 2007 02:55:49 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Message-ID: <20071002075549.GH19691@waste.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <p733awu6nva.fsf@bingen.suse.de> <20071001233225.88c67e8b.akpm@linux-foundation.org> <20071002070110.GA30490@one.firstfloor.org> <20071002001809.0a814d0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002001809.0a814d0b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 12:18:09AM -0700, Andrew Morton wrote:
> > > If so, that might be OK - the app just needs a reliable way of working out
> > > whether it's on a 32- or 64-bit kernel?
> > 
> > That would be ugly and a little error prone (would this case really be 
> > tested in user space normally?) but might work.
> 
> I guess it wouldn't be too hard for a 64-bit kernel to fake up 32-bit data
> for 32-bit userspace.  For each architecture :( But let's see what Matt
> thinks.

Grumble. The options are:

a) export it in the kernel's native size and have userspace figure it
out
b) add a header
c) lie to 32-bit apps on 64-bit kernels
d) always export 32 bits
e) always export 64 bits

I started with (a), switched to (b), and then Alan and Dave convinced
me to switch back to (a). I don't think (c) is desireable, especially
as it means having two code paths. (d) would work until memory got
large enough that PFNs didn't fit in 32 bits. (e) would be ok all
around, except for the extra overhead. Ho hum.

-- 
Mathematics is the supreme nostalgia of our time.
