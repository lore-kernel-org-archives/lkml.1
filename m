Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbXJYP3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbXJYP3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbXJYP3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:29:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:48331 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978AbXJYP3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:29:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,328,1188802800"; 
   d="scan'208";a="358158910"
Date: Thu, 25 Oct 2007 08:15:56 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: mgross@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, anil.s.keshavamurthy@intel.com
Subject: Re: [PATCH] intel-iommu: Fix array overflow
Message-ID: <20071025151555.GE18751@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <s5htzoirywg.wl%tiwai@suse.de> <20071024233037.GA18079@linux.intel.com> <s5htzofbqh5.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5htzofbqh5.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 09:31:02AM +0200, Takashi Iwai wrote:
> At Wed, 24 Oct 2007 16:30:37 -0700,
> Mark Gross wrote:
> > 
> > On Tue, Oct 23, 2007 at 10:57:51AM +0200, Takashi Iwai wrote:
> > > Fix possible array overflow:
> > > 
> > > drivers/pci/intel-iommu.c: In function ‘dmar_get_fault_reason’:
> > > drivers/pci/intel-iommu.c:753: warning: array subscript is above array bounds
> > > drivers/pci/intel-iommu.c: In function ‘iommu_page_fault’:
> > > drivers/pci/intel-iommu.c:753: warning: array subscript is above array bounds
> > > 
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > 
> > > ---
> > >  drivers/pci/intel-iommu.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> > > index b3d7031..e4b0a0d 100644
> > > --- a/drivers/pci/intel-iommu.c
> > > +++ b/drivers/pci/intel-iommu.c
> > > @@ -749,8 +749,8 @@ static char *fault_reason_strings[] =
> > >  
> > >  char *dmar_get_fault_reason(u8 fault_reason)
> > >  {
> > > -	if (fault_reason > MAX_FAULT_REASON_IDX)
> > > -		return fault_reason_strings[MAX_FAULT_REASON_IDX];
> > > +	if (fault_reason >= MAX_FAULT_REASON_IDX)
> > > +		return fault_reason_strings[MAX_FAULT_REASON_IDX - 1];
> > 
> > This looks like what the code meant to implement.
> 
> I think not.  The size of fault_reason_strings[] is
> MAX_FAULT_REASON_IDX, not + 1.  So gcc warning is correct.
> Maybe the main problem is that the constant name is confusing...
Yup, GCC warning is correct. the size of fault_reason_strings[]
is MAX_FAULT_REASON_IDX and hence the max array that can be 
referenced is [MAX_FAULT_REASON_IDX -1], hence the fix by
Takashi is correct.

-Anil
