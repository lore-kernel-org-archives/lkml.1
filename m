Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYK0Po6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYK0Po6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbYK0Pnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:43:33 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:23584 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbYK0Pnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:43:31 -0500
X-BigFish: VPS-27(z1039oz1432R98dR4015M1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KB010A-04-BBZ-01
Date: Thu, 27 Nov 2008 16:43:24 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: amit.shah@redhat.com, dwmw2@infradead.org, mingo@redhat.com,
       weidong.han@intel.com, avi@redhat.com
Subject: Re: [osrc-patches] [PATCH 0/9] Factor VT-d KVM functions into a generic API
Message-ID: <20081127154324.GM1386@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 27 Nov 2008 15:43:24.0390 (UTC) FILETIME=[E20A7860:01C950A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 04:40:45PM +0100, Joerg Roedel wrote:
> Hi,
> 
> this patch series makes the current KVM device passthrough code generic
> enough so that other IOMMU implementation can also plug into this code.
> It works by factoring the functions Vt-d code exports to KVM into a
> generic interface which allows different backends.
> 
> This a basic implementation of a generic interface. It can and should be
> improved later to support more types of hardware IOMMUs then VT-d and
> AMD IOMMU.
> 
> Since I have no VT-d hardware available these patches are only compile
> tested for now.
> 
> Please review, comment and test these patches.

For testing, the patches can be pulled against avi/master from

git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-api

> 
> Thanks,
> 
> Joerg
> 
> diffstat:
> 
>  arch/ia64/Kconfig               |    3 +
>  arch/ia64/kvm/Makefile          |    2 +-
>  arch/x86/Kconfig                |    3 +
>  arch/x86/include/asm/kvm_host.h |    3 +-
>  arch/x86/kvm/Makefile           |    2 +-
>  drivers/base/Makefile           |    1 +
>  drivers/base/iommu.c            |   94 +++++++++++++++++++
>  drivers/pci/intel-iommu.c       |   91 ++++++++++++++++++
>  include/linux/iommu.h           |  100 ++++++++++++++++++++
>  virt/kvm/iommu.c                |  193 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/vtd.c                  |  191 --------------------------------------
> 
> 
> _______________________________________________
> osrc-patches mailing list
> osrc-patches@elbe.amd.com
> https://ddcwww.amd.com/mailman/listinfo/osrc-patches

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

