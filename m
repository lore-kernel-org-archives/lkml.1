Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYGJMN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYGJMN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbYGJMNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:13:15 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:63619 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbYGJMNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:13:14 -0400
X-BigFish: VPS-29(zz1432R98dR7efV1805M873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3SHXN-03-Q9U-01
Date: Thu, 10 Jul 2008 14:12:22 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 02/34] AMD IOMMU: add header file for driver data structures and defines
Message-ID: <20080710121221.GH14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-3-git-send-email-joerg.roedel@amd.com> <20080709183823.52bbfd37.akpm@linux-foundation.org> <20080709185055.3b47c4db@infradead.org> <20080709193601.347134bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080709193601.347134bf.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 12:12:22.0141 (UTC) FILETIME=[34EB9AD0:01C8E286]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 07:36:01PM -0700, Andrew Morton wrote:
> On Wed, 9 Jul 2008 18:50:55 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Wed, 9 Jul 2008 18:38:23 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Thu, 26 Jun 2008 21:27:38 +0200 Joerg Roedel
> > > <joerg.roedel@amd.com> wrote:
> > > 
> > > > +/* helper macros */
> > > > +#define LOW_U32(x) ((x) & ((1ULL << 32)-1))
> > > > +#define HIGH_U32(x) (LOW_U32((x) >> 32))
> > > 
> > > Please avoid putting general-purpose helpers into private header
> > > files.
> > 
> > especially broken helpers.
> > 
> > A >> 32 on something that may be a 32 bit entry is bad; int32 >> 32...
> > gcc can (and does!) optimize that out.
> > 
> > (because it first gets translated into a SHR x86 instruction which then
> > notices it's encoded as a zero shift.. which then gets deleted)
> > 
> 
> Well yeah.  upper_32_bits() gets it all corect.  We could do a
> lower_32_bits() I suppose, if it's useful.

Ok cool, I agree. I will replace the HIGH_U32 macro with the
upper_32_bits() function and the other one with lower_32_bits() if it
exists. Who will take the patch for the introduction of that function?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

