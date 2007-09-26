Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbXIZT3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbXIZT3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbXIZT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:29:17 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:61244 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbXIZT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:29:15 -0400
X-IronPort-AV: E=Sophos;i="4.21,198,1188802800"; 
   d="scan'208";a="402059027"
To: Grant Grundler <grundler@parisc-linux.org>
Cc: akepner@sgi.com, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 0/4] allow drivers to flush in-flight DMA
X-Message-Flag: Warning: May contain useful information
References: <20070925235843.GK30013@sgi.com>
	<20070926064950.GB30430@colo.lackof.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 26 Sep 2007 12:29:12 -0700
In-Reply-To: <20070926064950.GB30430@colo.lackof.org> (Grant Grundler's message of "Wed, 26 Sep 2007 00:49:50 -0600")
Message-ID: <adabqbpted3.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Sep 2007 19:29:12.0977 (UTC) FILETIME=[84D3C810:01C80073]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Can we define this API to provide the same semantics as the memory
 > that dma_alloc_coherent() returns?

No, definitely not.  The property of the mapping here is all about
ordering with respect to other DMAs (from the same device) and nothing
to do with coherency between the CPU's and device's view of the memory.

 > Sorry - this feels like a "color of the shed" argument, but isn't
 > this about DMA ordering attribute?
 > "dmaflush" is an action and not an attribute to me.

I guess I don't love the "dmaflush" name, but the property of these
mappings is exactly that DMA into one of these mappings also performs
the action of flushing other in-flight DMAs.  However I guess your
point is a good one: the effect really desired is that DMAs to these
mappings become visible strictly after earlier DMAs, and we don't care
exactly how the effect is obtained.

No good idea of a better name though.

 - R.
