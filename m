Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYI1TfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYI1TfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 15:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYI1Te7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 15:34:59 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:15683 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYI1Te6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 15:34:58 -0400
X-BigFish: VPS-31(zz1432R98dR1805M1442J936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7X7PH-04-2AK-01
Date: Sun, 28 Sep 2008 21:34:36 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for GART
Message-ID: <20080928193436.GA8386@amd.com>
References: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com> <1222337635-28285-4-git-send-email-joerg.roedel@amd.com> <20080925102012.GA13631@elte.hu> <20080925104212.GA27928@amd.com> <20080927181438.GF1108@elte.hu> <20080927181855.GA11147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080927181855.GA11147@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 28 Sep 2008 19:34:36.0259 (UTC) FILETIME=[3D88B330:01C921A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 08:18:55PM +0200, Ingo Molnar wrote:
> 
> another thing:
> 
> How hard would it be to add an CONFIG_IOMMU_DEBUG option that forces as 
> many DMA requests to go via the IOMMU as possible?
> 
> This slows things down of course so it's only for debugging - but it 
> also makes sure that we utilize the IOMMU code to the maximum - which is 
> not normally the case.
> 
> Would be nice to have it .config driven (default-disabled), so that 
> -tip's randconfig testing can stumble upon it every now and then. I've 
> got GART test-systems - this way we could find certain types of IOMMU 
> breakages sooner.

For AMD IOMMU I disabled the round-robin allocator to stress-test the
code. This means that the address allocation bitmap is always traversed
from the first bit. In consequence the TLB flushing is stressed a lot
(both in hardware and software) because the same DMA addresses are used
again and again. For testing I hardcoded it into the driver but I can
also make it depend on CONFIG_IOMMU_DEBUG.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

