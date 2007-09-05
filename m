Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbXIEKqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbXIEKqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 06:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbXIEKqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 06:46:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58936 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755454AbXIEKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 06:46:00 -0400
Date: Wed, 5 Sep 2007 03:45:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: tbench regression - Why process scheduler has impact on tbench
 and why small per-cpu slab (SLUB) cache creates the scenario?
In-Reply-To: <1188983603.26438.55.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0709050342520.8127@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang> 
 <Pine.LNX.4.64.0709042053320.7231@schroedinger.engr.sgi.com> 
 <1188969725.26438.46.camel@ymzhang>  <Pine.LNX.4.64.0709042354290.7527@schroedinger.engr.sgi.com>
 <1188983603.26438.55.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Zhang, Yanmin wrote:

> > > However, the approach treats the slabs in the same policy. Could we
> > > implement a per-slab specific approach like direct b)?
> > 
> > I am not sure what you mean by same policy. Same configuration for all 
> > slabs?
> Yes.

Ok. I could add the ability to specify parameters for some slabs.

> > Would it be possible to try the two other approaches that I suggested? I 
> > think both of those may also solve the issue. Try booting with
> > slab_max_order=0
> 1) I tried slab_max_order=0 and the regression becomes 12.5%. It's still 
> not good.
> 
> 2) I apllied patch 
> slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch to kernel 
> 2.6.23-rc4. The new testing result is much better, only 1% less than 
> 2.6.22.

Ok. That seems to indicate that we should improve the alloc path in the 
page allocator. The page allocator performance needs to be competitive on 
page sized allocations. The problem will be largely going away when we 
merge the pass through patch in 2.6.24.
