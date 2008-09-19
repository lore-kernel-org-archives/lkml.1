Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYIST1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYIST1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYIST1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:27:35 -0400
Received: from 8bytes.org ([88.198.83.132]:41075 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbYIST1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:27:34 -0400
Date: Fri, 19 Sep 2008 21:27:32 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: ashok.raj@intel.com, shaohua.li@intel.com, anil.s.keshavamurthy@intel.com,
       muli@il.ibm.com, joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       "Woodhouse, David" <david.woodhouse@intel.com>
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
Message-ID: <20080919192732.GI27426@8bytes.org>
References: <20080918102931Z.fujita.tomonori@lab.ntt.co.jp> <20080918140350.GE24392@amd.com> <20080919174339.GA29039@8bytes.org> <20080920034028S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080920034028S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 03:40:34AM +0900, FUJITA Tomonori wrote:
> On Fri, 19 Sep 2008 19:43:39 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
> 
> > Hi All,
> > 
> > FUJITA mentioned that I forgot to discuss this patch with you guys, the
> > implementers and maintainers for Intel VT-d and Calgary IOMMU drivers. I
> > would like to hear your opinion on that patch. He is right with that.
> > The patch is already in tip/iommu but can easily be reverted if there
> > are fundamental objections.
> > The patch basically moves the iommu=fullflush and iommu=nofullflush
> > option from the GART code to pci-dma.c. So we can use these parameters
> > in other IOMMU implementations too. Since Intel VT-d is implementing
> > also lazy IO/TLB flushing it would benefit from this generic parameter
> > too. I am not so sure about Calgary, but we have other parameters for
> > iommu= which doesn't affect all hardware IOMMUs.
> 
> nofullflush is pointless. It doesn't change any kernel behavior. Yes,
> GART has it and we can't remove it because we exported it to
> users. But please don't add such pointless option to the generic
> options just for GART compatibility.

I think maybe we can remove it completly. It doesn't change any behavior
for GART too and as an unknown option it will be silently ignored by the
command line parser. So removing this option completly will not break
the user interface, imho.
 
> fullflush might be useful as a generic option to disable lazy IOTLB
> flushing. But I'm not sure that Calgary uses it. VT-d already has
> 'strict' option for it and we can't change it. If VT-d wants to
> support both 'strict' and 'fullflush' for disabling lazy IOTLB
> flushing, it would make sense. But if VT-d doesn't want, it is useful
> only for GART and AMD IOMMU. If so, I don't think that it is very
> useful but I'm not against adding it.

I think it will be usefull for VT-d too. As Ingo stated some time ago,
it makes sense to have a common set of options independent of the
specific type of hardware IOMMU in the system. And all hardware IOMMUs
for x86 implement lazy IO/TLB flushing. Only Calgary does not allow to
disable it. So iommu=fullflush is a good candidate for a common
parameter.

Joerg

