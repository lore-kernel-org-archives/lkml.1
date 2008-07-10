Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYGJNcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYGJNcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbYGJNcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:32:24 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:55048 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132AbYGJNcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:32:21 -0400
X-BigFish: VPS-39(zz1432R98dR7efV1805M179dR873fnzz10d3izzz32i6bh43j)
X-WSS-ID: 0K3SLL9-03-TIW-01
Date: Thu, 10 Jul 2008 15:31:36 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 14/34] AMD IOMMU: clue initialization code together
Message-ID: <20080710133136.GQ14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-15-git-send-email-joerg.roedel@amd.com> <20080709185512.6355159c.akpm@linux-foundation.org> <20080710123747.GK14977@amd.com> <20080710060351.770992cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080710060351.770992cc.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 13:31:36.0285 (UTC) FILETIME=[469C68D0:01C8E291]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 06:03:51AM -0700, Andrew Morton wrote:
> On Thu, 10 Jul 2008 14:37:47 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > > Is there a reason for using __get_free_pages() in this manner everywhere? 
> > > kmalloc() or kzalloc() are unsuitable?
> > 
> > Yes. The device table has to be page aligned and has a maximum size of
> > 2 MB. 
> 
> OK
> 
> > > > +	if (amd_iommu_dev_table == NULL)
> > > > +		goto out;
> > > > +
> > > > +	/*
> > > > +	 * Alias table - map PCI Bus/Dev/Func to Bus/Dev/Func the
> > > > +	 * IOMMU see for that device
> > > > +	 */
> > > > +	amd_iommu_alias_table = (void *)__get_free_pages(GFP_KERNEL,
> > > > +			get_order(alias_table_size));
> > 
> > Hmm, maybe this table will fit into a kmalloc allocation. Its maximum
> > size is 128 kb.
> 
> Might as well keep it all consistent in that case.

Yeah ok, I agree. Thanks for your review and comments. I try to push out
the updates today.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

