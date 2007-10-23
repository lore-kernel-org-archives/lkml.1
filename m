Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbXJWSFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbXJWSFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXJWSFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:05:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38707 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbXJWSE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:04:59 -0400
Message-ID: <471E37B4.9010604@zytor.com>
Date: Tue, 23 Oct 2007 11:04:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86 gart: rename symbols only used for the GART	implementation
References: <11931612933917-git-send-email-joerg.roedel@amd.com> <1193161293928-git-send-email-joerg.roedel@amd.com> <200710231943.47157.ak@suse.de> <20071023174711.GC6697@amd.com> <20071023175908.GD7793@redhat.com>
In-Reply-To: <20071023175908.GD7793@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Tue, Oct 23, 2007 at 07:47:11PM +0200, Joerg Roedel wrote:
>  > On Tue, Oct 23, 2007 at 07:43:47PM +0200, Andi Kleen wrote:
>  > > On Tuesday 23 October 2007 19:41:33 Joerg Roedel wrote:
>  > > > This patch renames the 4 symbols iommu_hole_init(), iommu_aperture,
>  > > > iommu_aperture_allowed, iommu_aperture_disabled.
>  > > > 
>  > > > It replaces the iommu_ with gart_ in the symbol name. All these symbols are
>  > > > only used for the GART implementation of IOMMUs.
>  > > 
>  > > That makes it still potentially conflicting with the AGP GART code.
>  > 
>  > Maybe yes. But the AGP GART driver conflicts with the GART IOMMU config
>  > option. So I don't see a problem here.
>  
> It shouldn't.  It's perfectly feasible to use both IOMMU and GART for AGP at
> the same time.
> 

And even if did, it's a big difference between being not able to compile 
in two drivers in the same kernel and not being able to use them at the 
same time.

Now, it looks to me the AGP GART code mostly calls itself agpgart.

	-hpa
