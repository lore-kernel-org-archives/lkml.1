Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbXJWSL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbXJWSL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXJWSLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:11:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXJWSLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:11:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/4] x86 gart: rename symbols only used for the =?iso-8859-1?q?GART=09implementation?=
Date: Tue, 23 Oct 2007 20:10:54 +0200
User-Agent: KMail/1.9.6
Cc: Dave Jones <davej@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
References: <11931612933917-git-send-email-joerg.roedel@amd.com> <20071023175908.GD7793@redhat.com> <471E37B4.9010604@zytor.com>
In-Reply-To: <471E37B4.9010604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710232010.55074.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2007 20:04:36 H. Peter Anvin wrote:
> Dave Jones wrote:
> > On Tue, Oct 23, 2007 at 07:47:11PM +0200, Joerg Roedel wrote:
> >  > On Tue, Oct 23, 2007 at 07:43:47PM +0200, Andi Kleen wrote:
> >  > > On Tuesday 23 October 2007 19:41:33 Joerg Roedel wrote:
> >  > > > This patch renames the 4 symbols iommu_hole_init(), iommu_aperture,
> >  > > > iommu_aperture_allowed, iommu_aperture_disabled.
> >  > > > 
> >  > > > It replaces the iommu_ with gart_ in the symbol name. All these symbols are
> >  > > > only used for the GART implementation of IOMMUs.
> >  > > 
> >  > > That makes it still potentially conflicting with the AGP GART code.
> >  > 
> >  > Maybe yes. But the AGP GART driver conflicts with the GART IOMMU config
> >  > option. So I don't see a problem here.
> >  
> > It shouldn't.  It's perfectly feasible to use both IOMMU and GART for AGP at
> > the same time.
> > 
> 
> And even if did, it's a big difference between being not able to compile 
> in two drivers in the same kernel and not being able to use them at the 
> same time.

You can already compile them in all. The functions are not really
conflicting -- otherwise allyesconfig would not work.

I think his goal was to get an prefix that describes the module uniquely.
gart_* clearly does not fulfill that criteria.

So basically he's replacing an ambigious-with-other-IOMMU-implementations
prefix with an ambigious-with-AGP prefix. Seems like a rather pointless
change.

-And
