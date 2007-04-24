Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXDXVr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXDXVr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423123AbXDXVr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:47:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52840
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754180AbXDXVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:47:27 -0400
Date: Tue, 24 Apr 2007 14:47:33 -0700 (PDT)
Message-Id: <20070424.144733.10245273.davem@davemloft.net>
To: rdreier@cisco.com
Cc: ak@suse.de, ashok.raj@intel.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when
 devices cannot address entire range.
From: David Miller <davem@davemloft.net>
In-Reply-To: <adaabwx1mrp.fsf@cisco.com>
References: <200704242312.54738.ak@suse.de>
	<20070424.142351.62664098.davem@davemloft.net>
	<adaabwx1mrp.fsf@cisco.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 24 Apr 2007 14:32:42 -0700

>  > My suggestion would be to allocate top-down in the 32-bit IOMMU space.
> 
> I think that's good for normal things, but it's not unreasonable to
> want to map > 4 GB of memory at once for an Infiniband device.

That's what the DAC interfaces were for, but people wanted to
remoe that since no in-tree users existed.

Devices like that want to essentially map the entire address space,
via pass-thru, not IOMMU mappings.

Clustering cards, such as those made by Dolphin, are another example.

I realize that this doesn't work when we absolutely must use an IOMMU
such as for virtualization which is the whole impetus of the Intel
IOMMU. :-)

> So maybe we would want some heuristics about the size of the mapping
> being requested or the amount of 32-bit space left to decide whether a
> mapping should be below 4 GB.

Perhaps, but as I said heuristics might not be enough here.
