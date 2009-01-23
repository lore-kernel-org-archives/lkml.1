Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZAWPow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZAWPow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZAWPoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:44:13 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:44036 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbZAWPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:44:12 -0500
Date: Fri, 23 Jan 2009 10:32:29 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <1232616430.14549.11.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0901231030470.32253@qirst.com>
References: <84144f020901140645o68328e01ne0e10ace47555e19@mail.gmail.com>  <20090114150900.GC25401@wotan.suse.de>  <20090114152207.GD25401@wotan.suse.de>  <84144f020901140730l747b4e06j41fb8a35daeaf6c8@mail.gmail.com>  <20090114155923.GC1616@wotan.suse.de> 
 <Pine.LNX.4.64.0901141219140.26507@quilx.com>  <20090115061931.GC17810@wotan.suse.de>  <Pine.LNX.4.64.0901151434150.28387@quilx.com>  <20090116034356.GM17810@wotan.suse.de>  <Pine.LNX.4.64.0901161509160.27283@quilx.com>  <20090119061856.GB22584@wotan.suse.de>
  <alpine.DEB.1.10.0901211903540.18367@qirst.com> <1232616430.14549.11.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Pekka Enberg wrote:

> On Wed, 2009-01-21 at 19:13 -0500, Christoph Lameter wrote:
> > No it cannot because in SLUB objects must come from the same page.
> > Multiple objects in a queue will only ever require a single page and not
> > multiple like in SLAB.
>
> There's one potential problem with "per-page queues", though. The bigger
> the object, the smaller the "queue" (i.e. less objects per page). Also,
> partial lists are less likely to help for big objects because they get
> emptied so quickly and returned to the page allocator. Perhaps we should
> do a small "full list" for caches with large objects?

Right thats why there is need for higher order allocs because that
increases the "queue" sizes. If the pages are larger then also the partial
lists will cover more ground. Much of the tuning in SLUB is the page size
setting (remember you can set the order for each slab in slub!). In
SLAB/SLQB the corresponding tuning is through the queue sizes.

