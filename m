Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbXKLT5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbXKLT5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXKLT5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:57:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:48909 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbXKLT5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:57:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,406,1188802800"; 
   d="scan'208";a="268939997"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu access overhead
Date: Mon, 12 Nov 2007 11:57:00 -0800
Message-ID: <617E1C2C70743745A92448908E030B2A02EDFBB5@scsmsx411.amr.corp.intel.com>
In-Reply-To: <4738AE04.1030506@cosmosbay.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu access overhead
Thread-Index: AcglZS+dNWNsQcaoSseX3WxVMMLQ0wAADtlw
References: <E1IrWuB-0005nS-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0711121112410.26682@schroedinger.engr.sgi.com> <4738AE04.1030506@cosmosbay.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Christoph Lameter" <clameter@sgi.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "David Miller" <davem@davemloft.net>, <akpm@linux-foundation.org>,
       <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <mathieu.desnoyers@polymtl.ca>, <penberg@cs.helsinki.fi>
X-OriginalArrivalTime: 12 Nov 2007 19:57:01.0976 (UTC) FILETIME=[310B1180:01C82566]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ahh so the need to be able to expand per cpu memory storage on demand 
> > is not as critical as we thought.
> > 
>
> Yes, but still desirable for future optimizations.
>
> For example, I do think using a per cpu memory storage on net_device refcnt & 
> last_rx could give us some speedups.

We do want to keep a very tight handle on bloat in per-cpu
allocations.  By definition the total allocation is multiplied
by the number of cpus.  Only ia64 has outrageous numbers of
cpus in a single system image today ... but the trend in
multi-core chips looks to have a Moore's law arc to it, so
everyone is going to be looking at lots of cpus before long.

-Tony
