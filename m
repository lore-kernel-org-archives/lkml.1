Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbYGJM0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbYGJM0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYGJM0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:26:24 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:45365 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYGJM0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:26:23 -0400
X-BigFish: VPS-29(zz1432R98dR7efV1805M873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3SIJK-03-QR5-01
Date: Thu, 10 Jul 2008 14:25:53 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 04/34] AMD IOMMU: add data structures to manage the IOMMUs in the system
Message-ID: <20080710122553.GJ14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-5-git-send-email-joerg.roedel@amd.com> <20080709184342.1ffb0ff0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080709184342.1ffb0ff0.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 12:25:53.0955 (UTC) FILETIME=[18CC9730:01C8E288]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 06:43:42PM -0700, Andrew Morton wrote:
> On Thu, 26 Jun 2008 21:27:40 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds the data structures which will contain the information read
> > from the ACPI table.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu_init.c |   17 +++++++++++++++++
> >  1 files changed, 17 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> > index 6fce5ab..0ad8cf9 100644
> > --- a/arch/x86/kernel/amd_iommu_init.c
> > +++ b/arch/x86/kernel/amd_iommu_init.c
> > @@ -99,3 +99,20 @@ struct ivmd_header {
> >  	u64 range_length;
> >  } __attribute__((packed));
> >  
> > +static int __initdata amd_iommu_disable;
> > +
> > +u16 amd_iommu_last_bdf;
> > +struct list_head amd_iommu_unity_map;
> > +unsigned amd_iommu_aperture_order = 26;
> > +int amd_iommu_isolate;
> > +
> > +struct list_head amd_iommu_list;
> > +struct dev_table_entry *amd_iommu_dev_table;
> > +u16 *amd_iommu_alias_table;
> > +struct amd_iommu **amd_iommu_rlookup_table;
> > +struct protection_domain **amd_iommu_pd_table;
> > +unsigned long *amd_iommu_pd_alloc_bitmap;
> > +
> > +static u32 dev_table_size;
> > +static u32 alias_table_size;
> > +static u32 rlookup_table_size;
> 
> hm, one would expect to see the header file which declares the globals in
> the same patch as the .c file which defines them.  Whatever.
> 
> What locks the list_heads?  It would be good to add a code comment at the
> definition site describing that locking.

True. I will add comments that describes the locking of the driver too.
The amd_iommu_list is not locked for example because it is only used at
driver initialization time or at resume (when its finally implemented).
The list elements itself have their own locks as well as the protection
domains.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

