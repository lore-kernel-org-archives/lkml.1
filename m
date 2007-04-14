Return-Path: <linux-kernel-owner+w=401wt.eu-S1750985AbXDNIuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985AbXDNIuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXDNIuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:50:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45864 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbXDNIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:50:53 -0400
Date: Sat, 14 Apr 2007 13:43:08 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070414081308.GA20034@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070413015712.GL11115@waste.org> <461EE925.1000301@yahoo.com.au> <20070413022345.GN11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413022345.GN11115@waste.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 09:23:45PM -0500, Matt Mackall wrote:
> On Fri, Apr 13, 2007 at 12:21:25PM +1000, Nick Piggin wrote:
> > Matt Mackall wrote:
> > >On Fri, Apr 13, 2007 at 11:42:29AM +1000, Nick Piggin wrote:
> > 
> > >>If kprobes is simply crappy and doesn't work properly for this, then I
> > >>could accept that. I'm not someone trying to get this info. So why can't
> > >>it be used? (not just for kpagemap, but for clear_refs and all that gunk
> > >>too).
> > >
> > >
> > >kprobes is good for looking at events, but bad for looking at state.
> > >Especially metric shitloads of state.
> > 
> > Why? Why is a kprobes trap significantly more expensive than a read
> > syscall?
> 
> I guess I'm not clear on what you're proposing. From my understanding
> of kprobes (admittedly not an expert), this is hard to do and not a
> very good match.
> 
> > >>Maybe. How about LRU? Reclaim performance is bad, and you want to work out
> > >>which pages keep going off the end of it, or which pages keep getting
> > >>written out via it, or who's pages are on the active list, forcing mine
> > >>out.
> > >
> > >
> > >Those are actually probably a good match for systemtap as they're all 
> > >events.
> > 
> > Traverse the LRU? Which files do they belong to? What process maps them?
> 
> -ENOPARSE.
> 

For non-event based data gathering using kprobes we can have a debugfs file
like /debug/kprobes/snapshot_probe and write a kprobe module with probe at
->write() function and then the user space can trigger the data collection

echo "1" > /debug/kprobes/snapshot_probe

Thus, the actual data collection code can reside in a separate
module or a systemtap script which provides very good post-processing
capabalities, and can be used without recompiling or rebooting the kernel.

Thanks
Maneesh

-- 
Maneesh Soni
Linux Technology Center,
IBM India Systems and Technology Lab, 
Bangalore, India
