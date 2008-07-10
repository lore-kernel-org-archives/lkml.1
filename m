Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYGJMza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYGJMza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYGJMzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:55:22 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:9990 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbYGJMzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:55:22 -0400
X-BigFish: VPS-29(zz1432R98dR7efV1805M873fnzz10d3izzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K3SJVT-03-RST-01
Date: Thu, 10 Jul 2008 14:54:39 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 22/34] AMD IOMMU: add domain allocation and deallocation functions
Message-ID: <20080710125439.GO14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-23-git-send-email-joerg.roedel@amd.com> <20080709191459.673a9a4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080709191459.673a9a4c.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 12:54:39.0675 (UTC) FILETIME=[1D6890B0:01C8E28C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 07:14:59PM -0700, Andrew Morton wrote:
> On Thu, 26 Jun 2008 21:27:58 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +static u16 domain_id_alloc(void)
> > +{
> > +	unsigned long flags;
> > +	int id;
> > +
> > +	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
> > +	id = find_first_zero_bit(amd_iommu_pd_alloc_bitmap, MAX_DOMAIN_ID);
> > +	BUG_ON(id == 0);
> > +	if (id > 0 && id < MAX_DOMAIN_ID)
> > +		__set_bit(id, amd_iommu_pd_alloc_bitmap);
> > +	else
> > +		id = 0;
> > +	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
> > +
> > +	return id;
> > +}
> 
> Presumably this is not performance-critical.  If it is, an IDR
> tree would help.

No, its not performance critical. Domain id allocation is only done at
IOMMU initialization currently. In the future it may also be used at
virtual machine creation when we have device passthrough for KVM.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

