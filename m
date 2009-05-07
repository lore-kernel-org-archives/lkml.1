Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbZEGKCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbZEGKCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZEGKBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:01:51 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:50813
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752193AbZEGKBu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:01:50 -0400
X-BigFish: VPS-12(zz1432R98dR1805M936fJ873fnzz1202hzzz32i6bh15fn43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KJ9QI0-02-5A9-01
Date: Thu, 7 May 2009 12:01:14 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
Message-ID: <20090507100114.GF4059@amd.com>
References: <20090428150531.GZ17438@amd.com> <1240932530.2567.91.camel@macbook.infradead.org> <20090428160448.GA17438@amd.com> <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 May 2009 10:01:15.0228 (UTC) FILETIME=[C236B1C0:01C9CEFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 04:47:14PM +0900, FUJITA Tomonori wrote:
> On Tue, 28 Apr 2009 18:04:48 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > Yes, it is in effect for other devices. But since its a security feature
> > it only makes sense if it covers all devices.
> 
> For me, IOMMUs are not about security but accessing all memory space
> (there are still lots of devices that are not capable of 64-bit DMA)
> but I agree that this workaround is bad.

Yeah true. Another major reason for having an IOMMU is to enlarge the
physical address range devices can access.

> Do you meant that AMD IOMMU code use the bitmap each device to manage
> address space so enlarging the DMA address space wastes memory?

Its not only the bitmap. There are also the page tables that would waste
memory if the aperture in the AMD IOMMU driver is enlarged to, say, 4GB.
Most devices don't need such a large amount of DMA address space. As I
found out VT-d does not have this problem because they implemented
another allocator which can cover all possible memory.
For the AMD IOMMU I currently implement a kind of a dynamically growing
bitmap allocator to fix this problem.

> >  But unless this problem isn't solved the
> > drivers won't be fixed, I guess.
> > I guess the DRM code in the kernel may have the same problem with IOMMU
> > enabled?
> 
> Looks like the DRM code uses the DMA API.

The proprietary drivers make problems so far. For the ATI one I am in
contact with the developers to try to fix it. But I can't do anything
about the other proprietary driver I am aware of :-(

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

