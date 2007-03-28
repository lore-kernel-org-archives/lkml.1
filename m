Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbXC1XoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbXC1XoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934076AbXC1XoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:44:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34559 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933815AbXC1XoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:44:04 -0400
Date: Wed, 28 Mar 2007 16:44:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
In-Reply-To: <20070328223753.GZ8915@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703281636400.14657@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
 <20070328134511.0d61ec8f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com>
 <20070328211658.GE2986@holomorphy.com> <Pine.LNX.4.64.0703281418040.13870@schroedinger.engr.sgi.com>
 <20070328223753.GZ8915@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, William Lee Irwin III wrote:

> As far as kernel compiles being relevant to anything besides
> potentially optimizing a particular major benchmark using gcc as one
> of its components... yeah, right. It's too macro to be a microbenchmark
> of anything and too micro to be pertinent to any meaningful
> macrobenchmark such as those from major benchmark publishers (who can't
> be named for trademark/etc. reasons). Hasn't it been at least 5 years
> since people figured out kernel compiles were complete bulls**t as
> benchmarks along with dbench for other reasons and several others? If
> not, I don't know why I bother with this kernel at all.

All benchmarks have their specific drawbacks. I personally like to do code 
review and see what cachelines are touched but that is basically imagining 
what a cpu does. Ones thinking may be led astray.

> Even so, I already did this and am done with it. It's not like I'm
> not carrying around numerous patches I know will never be merged all
> the time anyway. If you want to back it all out so badly, just do it
> and stop bothering me about it, and I'll merely continue maintaining my
> local patches without ever posting them as I have been for years. I'm
> not at all happy with the NIH situation, either, not that I'm at such a
> loss for ideas to need to contest every petty NIH that flies past.

What is NIH? My main concern is to get the use of page struct fields of 
the slab removed. We have to do special things to page sized allocs 
because of these page struct uses. F.e. the private field is used by 
compound pages and if any of the slabs allocate a higher order page that 
field will be in use.

We certainly see even from the rudimentary tests that I have done that 
the limited pgd, pmd caching has some effect. Could we please see your local 
patches? And I guess that you must have some sort of benchmark that you 
run to test these?
