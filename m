Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXIUVCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXIUVCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764281AbXIUUw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:52:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:7578 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764353AbXIUUw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:52:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,285,1186383600"; 
   d="scan'208";a="300320125"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Date: Fri, 21 Sep 2007 13:52:24 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E52027D909B@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070921114823.49d00263.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Thread-Index: Acf8gCsqRifBIPbnTz6y0VavAn4AqwACQlGQ
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com> <20070921114823.49d00263.akpm@linux-foundation.org>
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
       <neilb@suse.de>, <yur@emcraft.com>, <saeed.bishara@gmail.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>
X-OriginalArrivalTime: 21 Sep 2007 20:52:24.0700 (UTC) FILETIME=[500F83C0:01C7FC91]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > Fix a couple bugs and provide documentation for the async_tx api.
> >
> > Neil, please 'ack' patch #3.
> >
> > git://lost.foo-projects.org/~dwillia2/git/iop
async-tx-fixes-for-linus
> 
> Well it looks like Neil is on vacation or is hiding from us or
something.
> 
> In which case our options would be to go ahead and merge your #3 with
> our fingers crossed, or wait and do it in 2.6.23.1 or .2.
> 
> How serious is this bug which you're fixing?  Will it affect users
> of "legacy" MD setups, or only those who have enabled fancy dma-engine
> features?
> 
The symptom is raid array that fails to complete a read request.

It has only been triggered by Yuri when he tried a dma-engine
configuration on his PPC platform with PAGE_SIZE=64K, this opens a large
window for the bug to hit.  The window is much smaller but not 100%
closed in the !dma-engine case, although no one else has hit it. 

2.6.22 returned reads from handle_stripe under the stripe lock so this
patch can be seen as 'reverting a botched micro-optimization' versus
'introducing a new way to handle reads'.

> Either way, we need to get #2 (at least) in to Linus.

#2 is less critical and cannot hit with any of the current drivers in
the kernel, so it is ok if this one misses 2.6.23.
