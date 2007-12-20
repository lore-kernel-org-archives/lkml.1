Return-Path: <linux-kernel-owner+w=401wt.eu-S938396AbXLTSR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938396AbXLTSR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763842AbXLTSRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:17:19 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:40247 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761807AbXLTSRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:17:18 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2007 13:17:18 EST
To: Steve Wise <swise@opengridcomputing.com>
Cc: Benjamin Herrenschmidt <bherren@au1.ibm.com>, linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Wen Xiong <wenxiong@us.ibm.com>
Subject: Re: [ofa-general] iommu dma mapping alignment requirements
X-Message-Flag: Warning: May contain useful information
References: <476AA2E2.5010007@opengridcomputing.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 20 Dec 2007 10:07:39 -0800
In-Reply-To: <476AA2E2.5010007@opengridcomputing.com> (Steve Wise's message of "Thu, 20 Dec 2007 11:14:10 -0600")
Message-ID: <adalk7pz1ck.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Dec 2007 18:07:39.0663 (UTC) FILETIME=[354C11F0:01C84333]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > It appears that my problem boils down to a single host page of memory
 > that is mapped for dma, and the dma address returned by dma_map_sg()
 > is _not_ 64KB aligned.  Here is an example:

 > My first question is: Is there an assumption or requirement in linux
 > that dma_addressess should have the same alignment as the host address
 > they are mapped to?  IE the rdma core is mapping the entire 64KB page,
 > but the mapping doesn't begin on a 64KB page boundary.

I don't think this is explicitly documented anywhere, but it certainly
seems that we want the bus address to be page-aligned in this case.
For mthca/mlx4 at least, we tell the adapter what the host page size
is (so that it knows how to align doorbell pages etc) and I think this
sort of thing would confuse the HW.

 - R.
