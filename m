Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbYHNUC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbYHNUC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYHNUCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:02:49 -0400
Received: from 8bytes.org ([88.198.83.132]:59951 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbYHNUCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:02:48 -0400
Date: Thu, 14 Aug 2008 22:02:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/4] AMD IOMMU: use status bit instead of memory write-back for completion wait
Message-ID: <20080814200247.GA26988@8bytes.org>
References: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com> <1218736518-25301-2-git-send-email-joerg.roedel@amd.com> <200808142035.32422.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808142035.32422.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 08:35:30PM +0200, Ingo Oeser wrote:
> Hi Joerg,
> 
> On Thursday 14 August 2008, Joerg Roedel wrote:
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index 22d7d05..028e945 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -122,9 +119,15 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
> >  
> >  	while (!ready && (i < EXIT_LOOP_COUNT)) {
> >  		++i;
> > -		cpu_relax();
> 
> Could you elaborate, why you had to remove this?
> 
> Busy waiting loops should always do cpu_relay()
> to reduce heat procution and power consumption while idle.

I removed it because its not idling anymore in that loop imho. It reads
data from MMIO and does a small calculation with it.

Joerg

