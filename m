Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZCELoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZCELoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZCELoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:44:38 -0500
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:50975
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750919AbZCELoi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:44:38 -0500
X-BigFish: VPS-42(z21eWz1432R98dR1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KG17A2-03-B0B-01
Date: Thu, 5 Mar 2009 12:44:25 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] iommu fixes for 2.6.29-rc7
Message-ID: <20090305114425.GC8751@amd.com>
References: <20090305112215.GB8751@amd.com> <20090305114032.GB9548@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090305114032.GB9548@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 Mar 2009 11:44:25.0346 (UTC) FILETIME=[BBC97E20:01C99D87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 12:40:32PM +0100, Ingo Molnar wrote:
> > 
> > Joerg
> > 
> > Here is the full diff:
> > 
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index 5113c08..d7a7c4c 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -23,9 +23,7 @@
> >  #include <linux/debugfs.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/iommu-helper.h>
> > -#ifdef CONFIG_IOMMU_API
> >  #include <linux/iommu.h>
> > -#endif
> >  #include <asm/proto.h>
> >  #include <asm/iommu.h>
> >  #include <asm/gart.h>
> 
> hm, is this one really needed for .29? We are in late-rc freeze 
> mode.
> 
> > diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
> > index 5e039d4..c2d1eed 100644
> > --- a/drivers/base/iommu.c
> > +++ b/drivers/base/iommu.c
> > @@ -31,7 +31,7 @@ void register_iommu(struct iommu_ops *ops)
> >  	iommu_ops = ops;
> >  }
> >  
> > -bool iommu_found()
> > +bool iommu_found(void)
> >  {
> >  	return iommu_ops != NULL;
> >  }
> 
> that's ugly indeed albeit too not critical and not a regression 
> fix. My inclination would be to pull for the .30 merge window.

All this is uncritical. We can merge it in the .30 merge window if its
already too late.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

