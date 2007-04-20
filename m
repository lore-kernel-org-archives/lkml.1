Return-Path: <linux-kernel-owner+w=401wt.eu-S1422989AbXDTGVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422989AbXDTGVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 02:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422996AbXDTGVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 02:21:52 -0400
Received: from holomorphy.com ([66.93.40.71]:38015 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422989AbXDTGVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 02:21:51 -0400
Date: Thu, 19 Apr 2007 23:22:15 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Message-ID: <20070420062215.GE31925@holomorphy.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070420044718.GV2986@holomorphy.com> <Pine.LNX.4.64.0704192220510.16360@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704192220510.16360@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, William Lee Irwin III wrote:
>> Oh dear. Per-file pagesizes are foul. Better to fix up the pagecache's
>> radix tree than to restrict it like this. There are other attacks on the
>> multiple horizontal internal tree node allocation problem beyond
>> outright B+ trees that allow radix trees to continue to be used.

On Thu, Apr 19, 2007 at 10:27:34PM -0700, Christoph Lameter wrote:
> per-file pagesizes are just the granularity that is available. The order
> value is then readily available for all page cache operations. In practice 
> it is likely that filesystems will have one consistent page size. If you 
> look at the ramfs implementation then you will see that is exactly the
> approach taken here. I want to avoid any modifications to key data 
> structures or locking. If possible straight code transformation.

I'm not sure how to say this politely, so please don't take it as a
slight. Hacks to avoid diffsize increases that would result from data
structure code are highly specious. There are typically functionality
or efficiency issues deliberately left unaddressed to accomplish such.
When committing the patch, you generally end up implicitly committed
to later updates to address those issues.

That said, even if some maintainers consciously agree (it's actually
rather clear that my opinion here is not representative of the majority
if anyone else at all), it does still present an issue for "marketing"
patches since diffsize is so easily latched onto as a metric of risk.

Don't worry about it for now. This will do fine.


On Thu, 19 Apr 2007, William Lee Irwin III wrote:
>> I've always wanted the awareness to be pervasive, so it's good to hear
>> there's someone with a common interest. If this effort takes off, I'd be
>> happy to contribute to it. I do wonder what ever happened with the gelato
>> codebase, though.

On Thu, Apr 19, 2007 at 10:27:34PM -0700, Christoph Lameter wrote:
> The superpages? I do not think that we should be getting that complicated 
> here. Maybe we can pick up some ideas at some point.

They're all TLB so picking things up on the TLB side can be done there.
I think they also keep the long format VHPT code updated to recent
mainline, which makes higher-order pages meaningful on ia64 (which with
the region register -based affair they are effectively not).


On Thu, 19 Apr 2007, William Lee Irwin III wrote:
>> I'm afraid this may be approaching an underappreciated research topic.
>> Most sponsors of such research seem to have an active disinterest in
>> getting page replacement to properly interoperate with all this.

On Thu, Apr 19, 2007 at 10:27:34PM -0700, Christoph Lameter wrote:
> Well that is the difference between academia where one gets his Ph.D. for
> superpages, publishes a couple of papers and then its over and real 
> kernel work where this actually will have to work consistently with the 
> rest of the system. Let us thus do small steps towards the goal 
> while keeping things as simple and straightforward as possible.

A more careful reading would reveal this as a criticism of industrial
sponsorship of research, not academia per se. For instance, what IHV
would bother sponsoring research on page replacement, since when
grinding out [trademarked name of major benchmark censored] numbers to
sell their systems, they arrange for page replacement never to happen?


-- wli
