Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbXEIXJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbXEIXJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759734AbXEIXIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:08:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:55352 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759672AbXEIXIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:08:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="226356633"
Date: Wed, 9 May 2007 16:06:04 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Call percpu smp cacheline algin interface
Message-ID: <20070509230604.GA6119@linux-os.sc.intel.com>
References: <20070509133328.c79ef48e.akpm@linux-foundation.org> <A29F7A5700A7EA4380E08C1F68C3B6D802B5F702@scsmsx411.amr.corp.intel.com> <20070509155326.5e02f60d.akpm@linux-foundation.org> <Pine.LNX.4.64.0705091556260.1221@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705091556260.1221@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 03:56:57PM -0700, Christoph Lameter wrote:
>  On Wed, 9 May 2007, Andrew Morton wrote:
> > erm, it's not obviosu from all this that the patches are worth proceeding
> > with, are they?

Andrew, There are two advantages with this patch.

1. Space savings.. For me, I really don't worry about this. As VSMP only
uses 4K cacheline alignment and the regular kernels don't use VSMP.

2. data accessed by different cpus gets their own cachelines. 
Both the beginning and end of these data elements will be cacheline
aligned.
i.e., other data which gets referenced heavily by local cpu will not bring
the remote lines to local cpu(no unnecessary cacheline bouncing). This
is important, going forward.

> 
> What was it? 0.5% performance improvement on a synthetic benchmark?
> Process wakeup I believe?

Christoph, don't get confused. The patch which gives 0.5% is already
in linus git tree. This adds a clean infrastructure, to avoid the two
above mentioned issues.

thanks,
suresh
