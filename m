Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYISQqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYISQqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYISQpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:45:55 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26888 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYISQpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:45:54 -0400
X-BigFish: VPS-22(z1039oz1432R98dR1805M936fQzz10d3izz2f39iz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7GBW2-03-TE5-01
Date: Fri, 19 Sep 2008 18:45:41 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080919164541.GS24392@amd.com>
References: <20080920012322R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080920012322R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 16:45:41.0707 (UTC) FILETIME=[272709B0:01C91A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 01:23:30AM +0900, FUJITA Tomonori wrote:
> This patch against tip/x86/iommu virtually reverts
> 2842e5bf3115193f05dc9dac20f940e7abf44c1a. But just reverting the
> commit breaks AMD IOMMU so this patch also includes some fixes.
 
NACK.

> The above commit adds new two options to x86 IOMMU generic kernel boot
> options, fullflush and nofullflush. But such change that affects all
> the IOMMUs needs more discussion (all IOMMU parties need the chance to
> discuss it):

It affects only IOMMUs which use the iommu_fullflush variable. This are
GART, which used it since ages, and AMD IOMMU which was introduced by
the above commit. It absolutly makes sense to have command line parameters
which make sense for more than one or most of the IOMMUs in x86 into
'iommu='. Ingo agreed with this, see http://lkml.org/lkml/2008/6/30/155
I agree with that too. The commit you are trying to revert here was a
step into this direction.

> http://lkml.org/lkml/2008/9/19/106
> 
> For me, adding these boot parameters doesn't make sense.

May be true for nofullflush. For fullflush it makes sense to have it in
the generic code since all x86 hardware IOMMUs except Calgary can make
use of it. 

> All the hardware IOMMUs could use 'fullflush' for lazy IOTLB flushing
> but Calgary doesn't support it. Intel VT-d has the different option
> for it (and we can't rename it). So it might be useful for only GART
> and AMD IOMMU.

We can keep the current Intel option and have iommu=fullflush in
parallel. It could also affect Intel IOMMU.

> 'nofullflush' definitely is pointless. 'nofullflush' option doesn't
> change any kernel behavior and it was added just for GART
> compatibility. We should not have such generic meaningless option just
> for GART.

So why do you keep it in this patch then?

> This patch removes the fullflush and nofullflush from the generic
> kernel boot options and adds 'fullflush' support for AMD IOMMU.

I disagree. Keep it in the generic code.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

