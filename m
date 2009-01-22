Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZAVJa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZAVJa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZAVJaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:30:46 -0500
Received: from mga10.intel.com ([192.55.52.92]:51702 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754087AbZAVJaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:30:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,305,1231142400"; 
   d="scan'208";a="659185985"
Subject: Re: [patch] SLQB slab allocator
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1232616430.14549.11.camel@penberg-laptop>
References: <84144f020901140645o68328e01ne0e10ace47555e19@mail.gmail.com>
	 <20090114150900.GC25401@wotan.suse.de>
	 <20090114152207.GD25401@wotan.suse.de>
	 <84144f020901140730l747b4e06j41fb8a35daeaf6c8@mail.gmail.com>
	 <20090114155923.GC1616@wotan.suse.de>
	 <Pine.LNX.4.64.0901141219140.26507@quilx.com>
	 <20090115061931.GC17810@wotan.suse.de>
	 <Pine.LNX.4.64.0901151434150.28387@quilx.com>
	 <20090116034356.GM17810@wotan.suse.de>
	 <Pine.LNX.4.64.0901161509160.27283@quilx.com>
	 <20090119061856.GB22584@wotan.suse.de>
	 <alpine.DEB.1.10.0901211903540.18367@qirst.com>
	 <1232616430.14549.11.camel@penberg-laptop>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 17:30:38 +0800
Message-Id: <1232616638.11429.131.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 11:27 +0200, Pekka Enberg wrote:
> Hi Christoph,
> 
> On Mon, 19 Jan 2009, Nick Piggin wrote:
> > > > > You only go to the allocator when the percpu queue goes empty though, so
> > > > > if memory policy changes (eg context switch or something), then subsequent
> > > > > allocations will be of the wrong policy.
> > > >
> > > > The per cpu queue size in SLUB is limited by the queues only containing
> > > > objects from the same page. If you have large queues like SLAB/SLQB(?)
> > > > then this could be an issue.
> > >
> > > And it could be a problem in SLUB too. Chances are that several allocations
> > > will be wrong after every policy switch. I could describe situations in which
> > > SLUB will allocate with the _wrong_ policy literally 100% of the time.
> 
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
That helps definitely. We could use a batch to control the list size.


