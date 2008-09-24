Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYIXM62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYIXM62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYIXM6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:58:20 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27221 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYIXM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:58:19 -0400
X-BigFish: VPS-28(zz1432R98dR1805M936fOzzzz2f39iz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7PAOV-03-LIR-01
Date: Wed, 24 Sep 2008 14:58:08 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [PATCH 0/3] x86: restore old GART alloc_coherent
Message-ID: <20080924125808.GU24392@amd.com>
References: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 24 Sep 2008 12:58:08.0129 (UTC) FILETIME=[310D1F10:01C91E45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 08:48:34PM +0900, FUJITA Tomonori wrote:
> This pachset is against tip/iommu.
> 
> What this patchset does is restoring old GART alloc_coherent behavior
> (before the alloc_coherent rewrite):
> 
> http://lkml.org/lkml/2008/8/12/200
> 
> Currently, GART alloc_coherent tries to allocate pages with GFP_DMA32
> for a device having dma_masks > 24bit < 32bits. If GART gets an
> address that a device can't access to, GART tries to map the address
> to a virtual I/O address that the device can access to.
> 
> But Andi pointed out, "The GART is somewhere in the 4GB range so you
> cannot use it to map anything < 4GB. Also GART is pretty small."
> 
> http://lkml.org/lkml/2008/9/12/43
> 
> So it's possible that GART doesn't have virtual I/O address space that
> a device can access to. The current behavior might not work for a
> device having dma_masks > 24bit < 32bits. This patchset restores old
> GART alloc_coherent behavior, which doesn't use GART hardware (if an
> user doesn't enable force_iommu option).

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

