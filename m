Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbZD1QF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbZD1QF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbZD1QFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:05:13 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:29460
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932586AbZD1QFL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:05:11 -0400
X-BigFish: VPS-36(zz1432R98dR936eQ1805M1442J936fKzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KITJBY-04-5VC-01
Date: Tue, 28 Apr 2009 18:04:48 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, fujita.tomonori@lab.ntt.co.jp, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
Message-ID: <20090428160448.GA17438@amd.com>
References: <20090428150531.GZ17438@amd.com> <1240932530.2567.91.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1240932530.2567.91.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Apr 2009 16:04:49.0038 (UTC) FILETIME=[0E8A32E0:01C9C81B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 04:28:50PM +0100, David Woodhouse wrote:
> On Tue, 2009-04-28 at 17:05 +0200, Joerg Roedel wrote:
> 
> For that device, yes. The IOMMU still catches errors from _other_
> devices, of course.

Yes, it is in effect for other devices. But since its a security feature
it only makes sense if it covers all devices.

> Is the reason you're doing this actually because of broken drivers? Or
> just because of the performance implications? I've heard both cited as
> reasons for the 1:1 mapping... and if it's mostly the former, then
> perhaps the best way for me to help you is to stop enabling the option
> in Fedora (rawhide, at least), so that the buggy drivers get _fixed_ and
> you don't get stuck with "it works on Intel, why can't you make it
> work?" reports?

Currently some graphics drivers don't work with IOMMU enabled because
they don't use the DMA-API. The silently assume that device addess ==
physical address.
I don't know how it is solved for VT-d but for AMD IOMMU the available
DMA memory address space is limited per device. This is a problem for
graphics card drivers because, as developers told me, they may need
gigabytes of DMA memory. I am currently thinking about ways to fix that
without enlarging the DMA address space for each device (which would be
a huge waste of memory). But unless this problem isn't solved the
drivers won't be fixed, I guess.
I guess the DRM code in the kernel may have the same problem with IOMMU
enabled?

> > 	* Implement a kernel command line option to enable/disable the
> > 	  workaround (what should be default?)
> > 	* Use the IOMMU-API and write a kernel module which creates a
> > 	  direct mapped protection domain and assigns the graphics
> > 	  cards to it (need to be done carefully to not break graphics 
> > 	  drivers which do everything right and use the DMA-API)
> > 	* Any other great idea?
> 
> I think I also prefer your second option. I don't like having this as a
> hack in the IOMMU code.

Ok, so I will implement such a module and send the code around for
discussion.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

