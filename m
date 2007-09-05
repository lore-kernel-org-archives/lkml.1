Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbXIEG6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbXIEG6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 02:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbXIEG6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 02:58:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51488 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754823AbXIEG6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 02:58:10 -0400
Date: Tue, 4 Sep 2007 23:58:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: tbench regression - Why process scheduler has impact on tbench
 and why small per-cpu slab (SLUB) cache creates the scenario?
In-Reply-To: <1188969725.26438.46.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0709042354290.7527@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang> 
 <Pine.LNX.4.64.0709042053320.7231@schroedinger.engr.sgi.com>
 <1188969725.26438.46.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Zhang, Yanmin wrote:

> On Tue, 2007-09-04 at 20:59 -0700, Christoph Lameter wrote:
> > On Wed, 5 Sep 2007, Zhang, Yanmin wrote:
> > 
> > > 8) kmalloc-4096 order is 1 which means one slab consists of 2 objects. So a
> > 
> > You can change that by booting with slub_max_order=0. Then we can also use 
> > the per cpu queues to get these order 0 objects which may speed up the 
> > allocations because we do not have to take zone locks on slab allocation.
> > 
> > Note also that Andrew's tree has a page allocator pass through for SLUB 
> > for 4k kmallocs bypassing slab completely. That may also address the 
> > issue.
> > 
> > If you want SLUB to handle more objects in the 4k kmalloc cache 
> > without going to the page allocator then you can boot f.e. with
> > 
> > slub_max_order=3 slub_min_objects=8
> I tried this approach. The testing result showed 2.6.23-rc4 is about
> 2.5% better than 2.6.22. It really resovles the issue.
> 
> However, the approach treats the slabs in the same policy. Could we
> implement a per-slab specific approach like direct b)?

I am not sure what you mean by same policy. Same configuration for all 
slabs?

> > Try the ways to address the issue that I mentioned above.
> I really appreciate your kind comments!

Would it be possible to try the two other approaches that I suggested? I 
think both of those may also solve the issue. Try booting with
slab_max_order=0 and see what effect it has. The queues of the page 
allocator can be much larger than what slab has for 4k pages. There is 
really not much of a point in using a slab allocator for page sized 
allocations.


