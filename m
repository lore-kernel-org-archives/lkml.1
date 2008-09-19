Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbYISSmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbYISSmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYISSmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:42:15 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:34564 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYISSmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:42:14 -0400
Date: Sat, 20 Sep 2008 03:40:34 +0900
To: joro@8bytes.org
Cc: ashok.raj@intel.com, shaohua.li@intel.com, anil.s.keshavamurthy@intel.com,
       muli@il.ibm.com, joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919174339.GA29039@8bytes.org>
References: <20080918102931Z.fujita.tomonori@lab.ntt.co.jp>
	<20080918140350.GE24392@amd.com>
	<20080919174339.GA29039@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920034028S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 19:43:39 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> Hi All,
> 
> FUJITA mentioned that I forgot to discuss this patch with you guys, the
> implementers and maintainers for Intel VT-d and Calgary IOMMU drivers. I
> would like to hear your opinion on that patch. He is right with that.
> The patch is already in tip/iommu but can easily be reverted if there
> are fundamental objections.
> The patch basically moves the iommu=fullflush and iommu=nofullflush
> option from the GART code to pci-dma.c. So we can use these parameters
> in other IOMMU implementations too. Since Intel VT-d is implementing
> also lazy IO/TLB flushing it would benefit from this generic parameter
> too. I am not so sure about Calgary, but we have other parameters for
> iommu= which doesn't affect all hardware IOMMUs.

nofullflush is pointless. It doesn't change any kernel behavior. Yes,
GART has it and we can't remove it because we exported it to
users. But please don't add such pointless option to the generic
options just for GART compatibility.

fullflush might be useful as a generic option to disable lazy IOTLB
flushing. But I'm not sure that Calgary uses it. VT-d already has
'strict' option for it and we can't change it. If VT-d wants to
support both 'strict' and 'fullflush' for disabling lazy IOTLB
flushing, it would make sense. But if VT-d doesn't want, it is useful
only for GART and AMD IOMMU. If so, I don't think that it is very
useful but I'm not against adding it.
