Return-Path: <linux-kernel-owner+w=401wt.eu-S934472AbZJIVcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472AbZJIVcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934453AbZJIVcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:32:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934452AbZJIVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:32:17 -0400
Date: Fri, 9 Oct 2009 14:31:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ehrhardt Christian <ehrhardt@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] mm: make VM_MAX_READAHEAD configurable
Message-Id: <20091009143124.1241a6bc.akpm@linux-foundation.org>
In-Reply-To: <20091009122952.GI9228@kernel.dk>
References: <1255087175-21200-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
	<1255090830.8802.60.camel@laptop>
	<20091009122952.GI9228@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 14:29:52 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Oct 09 2009, Peter Zijlstra wrote:
> > On Fri, 2009-10-09 at 13:19 +0200, Ehrhardt Christian wrote:
> > > From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
> > > 
> > > On one hand the define VM_MAX_READAHEAD in include/linux/mm.h is just a default
> > > and can be configured per block device queue.
> > > On the other hand a lot of admins do not use it, therefore it is reasonable to
> > > set a wise default.
> > > 
> > > This path allows to configure the value via Kconfig mechanisms and therefore
> > > allow the assignment of different defaults dependent on other Kconfig symbols.
> > > 
> > > Using this, the patch increases the default max readahead for s390 improving
> > > sequential throughput in a lot of scenarios with almost no drawbacks (only
> > > theoretical workloads with a lot concurrent sequential read patterns on a very
> > > low memory system suffer due to page cache trashing as expected).
> > 
> > Why can't this be solved in userspace?
> > 
> > Also, can't we simply raise this number if appropriate? Wu did some
> > read-ahead trashing detection bits a long while back which should scale
> > the read-ahead window back when we're low on memory, not sure that ever
> > made it in, but that sounds like a better option than having different
> > magic numbers for each platform.
> 
> Agree, making this a config option (and even defaulting to a different
> number because of an arch setting) is crazy.

Given the (increasing) level of disparity between different kinds of
storage devices, having _any_ default is crazy.

Would be better to make some sort of vaguely informed guess at
runtime, based upon the characteristics of the device.

