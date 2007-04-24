Return-Path: <linux-kernel-owner+w=401wt.eu-S1423131AbXDXVcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423131AbXDXVcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423132AbXDXVcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:32:54 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:21315 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423131AbXDXVcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:32:52 -0400
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="770580007:sNHT46574924"
To: David Miller <davem@davemloft.net>
Cc: ak@suse.de, ashok.raj@intel.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices cannot address entire range.
X-Message-Flag: Warning: May contain useful information
References: <200704242133.16219.ak@suse.de>
	<20070424203304.GB27911@linux-os.sc.intel.com>
	<200704242312.54738.ak@suse.de>
	<20070424.142351.62664098.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 24 Apr 2007 14:32:42 -0700
In-Reply-To: <20070424.142351.62664098.davem@davemloft.net> (David Miller's message of "Tue, 24 Apr 2007 14:23:51 -0700 (PDT)")
Message-ID: <adaabwx1mrp.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2007 21:32:43.0073 (UTC) FILETIME=[178F7310:01C786B8]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > My suggestion would be to allocate top-down in the 32-bit IOMMU space.

I think that's good for normal things, but it's not unreasonable to
want to map > 4 GB of memory at once for an Infiniband device.

So maybe we would want some heuristics about the size of the mapping
being requested or the amount of 32-bit space left to decide whether a
mapping should be below 4 GB.

 - R.
