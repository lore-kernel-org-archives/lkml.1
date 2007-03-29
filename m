Return-Path: <linux-kernel-owner+w=401wt.eu-S934285AbXC2Axz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285AbXC2Axz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 20:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934287AbXC2Axy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 20:53:54 -0400
Received: from holomorphy.com ([66.93.40.71]:45250 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934285AbXC2Axy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 20:53:54 -0400
Date: Wed, 28 Mar 2007 17:53:56 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070329005356.GA8915@holomorphy.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328134511.0d61ec8f.akpm@linux-foundation.org> <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com> <20070328211658.GE2986@holomorphy.com> <Pine.LNX.4.64.0703281418040.13870@schroedinger.engr.sgi.com> <20070328223753.GZ8915@holomorphy.com> <Pine.LNX.4.64.0703281636400.14657@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281636400.14657@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, William Lee Irwin III wrote:
>> As far as kernel compiles being relevant to anything besides
>> potentially optimizing a particular major benchmark using gcc as one
>> of its components... yeah, right. It's too macro to be a microbenchmark
>> of anything and too micro to be pertinent to any meaningful
>> macrobenchmark such as those from major benchmark publishers (who can't
>> be named for trademark/etc. reasons). Hasn't it been at least 5 years
>> since people figured out kernel compiles were complete bulls**t as
>> benchmarks along with dbench for other reasons and several others? If
>> not, I don't know why I bother with this kernel at all.

On Wed, Mar 28, 2007 at 04:44:01PM -0700, Christoph Lameter wrote:
> All benchmarks have their specific drawbacks. I personally like to do
> code review and see what cachelines are touched but that is basically
> imagining what a cpu does. Ones thinking may be led astray.

Well, the kernel compiles are just terrible at everything they could
plausibly be used to measure. I could, in principle, develop a benchmark
that simulates a forking server that does many things similar to what a
kernel compile is meant to measure without a number of its stupidities,
but I've got enough to do already.


On Wed, 28 Mar 2007, William Lee Irwin III wrote:
>> Even so, I already did this and am done with it. It's not like I'm
>> not carrying around numerous patches I know will never be merged all
>> the time anyway. If you want to back it all out so badly, just do it
>> and stop bothering me about it, and I'll merely continue maintaining my
>> local patches without ever posting them as I have been for years. I'm
>> not at all happy with the NIH situation, either, not that I'm at such a
>> loss for ideas to need to contest every petty NIH that flies past.

On Wed, Mar 28, 2007 at 04:44:01PM -0700, Christoph Lameter wrote:
> What is NIH? My main concern is to get the use of page struct fields of 
> the slab removed. We have to do special things to page sized allocs 
> because of these page struct uses. F.e. the private field is used by 
> compound pages and if any of the slabs allocate a higher order page that 
> field will be in use.

NIH == "Not Invented Here." Basically a sort of idea theft, often used
to grab credit for patches. You're not the one involved there. That was
a digression. One could say, though, that a solution to the slab issues
is to NIH slab allocators e.g. via quicklist.h/quicklist.c without the
negative connotation.


On Wed, Mar 28, 2007 at 04:44:01PM -0700, Christoph Lameter wrote:
> We certainly see even from the rudimentary tests that I have done
> that the limited pgd, pmd caching has some effect. Could we please
> see your local patches? And I guess that you must have some sort of
> benchmark that you run to test these?

Short answer: No.

Long answer: Most of the local patches are not likely to be of interest
to the world at large. The ones I probably don't mind mentioning so
much are things like ports of ipt_TARPIT.c to -CURRENT, support for
mmap() of /proc/profile, things to make the notsc boot parameter
actually do what you'd expect it to do instead of the kernel ignoring
the option when you actually need it and mucking with the TSC behind
your back, and so on. There are also things I'd rather keep under wraps
so they don't mysteriously appear on lkml a few years later posted by
someone else without any attribution to me (i.e. the NIH's that bother
me). I've not got any of them ported to current mainline anyway, and
some data loss from fried disks seems to have eaten most/all of the
post-2.6.0 revisions of these patches anyway, though I've got compiled
kernels with them on various kernel versions between then and 2.6.10
(not to say that's any impediment to my hammering out fresh ports).


-- wli
