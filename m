Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbXLTUV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbXLTUV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXLTUVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:21:49 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:41194 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbXLTUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:21:48 -0500
Subject: Re: [ofa-general] iommu dma mapping alignment requirements
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
Reply-To: benh@au1.ibm.com
To: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>,
       linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Wen Xiong <wenxiong@us.ibm.com>, Olof Johansson <olof@lixom.net>,
       Paul Mackerras <pmac@au1.ibm.com>
In-Reply-To: <476AC2A5.8060200@opengridcomputing.com>
References: <476AA2E2.5010007@opengridcomputing.com>
	 <adalk7pz1ck.fsf@cisco.com> <476ABE60.9030805@opengridcomputing.com>
	 <476AC2A5.8060200@opengridcomputing.com>
Content-Type: text/plain
Organization: IBM Ozlabs
Date: Fri, 21 Dec 2007 07:21:01 +1100
Message-Id: <1198182061.6779.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 13:29 -0600, Steve Wise wrote:

> Or based on the alignment of vaddr actually...

The later wouldn't be realistic. What I think might be necessay, though
it would definitely cause us problems with running out of iommu space
(which is the reason we did the switch down to 4K), is to provide
alignment to the real page size, and alignement to the allocation order
for dma_map_consistent.

It might be possible to -tweak- and only provide alignment to the page
size for allocations that are larger than IOMMU_PAGE_SIZE. That would
solve the problem with small network packets eating up too much iommu
space though.

What do you think ?

Ben.


