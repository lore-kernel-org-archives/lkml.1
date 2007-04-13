Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbXDMMVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbXDMMVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXDMMVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:21:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53073 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbXDMMV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:21:29 -0400
Date: Fri, 13 Apr 2007 17:54:58 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413122458.GB30280@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070413015712.GL11115@waste.org> <461EE925.1000301@yahoo.com.au> <20070413022345.GN11115@waste.org> <461EF0EC.4090908@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461EF0EC.4090908@yahoo.com.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 12:54:36PM +1000, Nick Piggin wrote:
> Matt Mackall wrote:
> >On Fri, Apr 13, 2007 at 12:21:25PM +1000, Nick Piggin wrote:
> >
> >>Matt Mackall wrote:
> >>
> >>>On Fri, Apr 13, 2007 at 11:42:29AM +1000, Nick Piggin wrote:
> >>
> >>>>If kprobes is simply crappy and doesn't work properly for this, then I
> >>>>could accept that. I'm not someone trying to get this info. So why can't
> >>>>it be used? (not just for kpagemap, but for clear_refs and all that gunk
> >>>>too).
> >>>
> >>>
> >>>kprobes is good for looking at events, but bad for looking at state.
> >>>Especially metric shitloads of state.
> >>
> >>Why? Why is a kprobes trap significantly more expensive than a read
> >>syscall?
> >
> >
> >I guess I'm not clear on what you're proposing. From my understanding
> >of kprobes (admittedly not an expert), this is hard to do and not a
> >very good match.
> 
> But you have an idea that it is bad for exposing lots of data. Why?
> (I'm not a kprobes expert either, these are not rhetorical questions)

You could tie your kprobe module to use relay channels. Kprobe handlers
run lockless and using the per-cpu relay channels will provide a fast
transport mechanism for exposing lots of data.

http://relayfs.sourceforge.net/examples.html#tprintk_kprobes is an
example using the earlier relayfs interface. It shouldn't be that hard
to change it to use the newer relay stuff.

AFAIK acme is using a similar mechanism for ctracer
(http://oops.ghostprotocols.net:81/blog/?p=50)

Ananth
