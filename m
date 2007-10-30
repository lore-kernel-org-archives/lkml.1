Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbXJ3VcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbXJ3VcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXJ3VcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:32:17 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54506 "EHLO
	outbound9-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbXJ3VcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:32:16 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Tue, 30 Oct 2007 15:33:23 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: linux-fbdev-devel@lists.sourceforge.net
cc: linux-info@geode.amd.com, linux-kernel@vger.kernel.org,
       tibor.osztodi@bbraun.com
Subject: Re: Use the correct MSR number for panel support
Message-ID: <20071030213323.GE14814@cosmic.amd.com>
References: <20071026145301.14168.19412.stgit@cosmic.amd.com>
 <472674B0.9080001@zytor.com>
MIME-Version: 1.0
In-Reply-To: <472674B0.9080001@zytor.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 30 Oct 2007 21:32:06.0835 (UTC)
 FILETIME=[5208B830:01C81B3C]
X-WSS-ID: 6B397D5D07S877545-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/07 17:02 -0700, H. Peter Anvin wrote:
> Jordan Crouse wrote:
> > From: Jordan Crouse <jordan.crouse@amd.com>
> > 
> > A relatively recent version of the Geode LX datasheet listed the wrong
> > address for one of the MSRs that controls TFT panels, resulting in 
> > breakage.  This patch corrects the MSR address.
> > 
> > Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
> > ---
> > 
> >  drivers/video/geode/lxfb.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/video/geode/lxfb.h b/drivers/video/geode/lxfb.h
> > index 6c227f9..ca13c48 100644
> > --- a/drivers/video/geode/lxfb.h
> > +++ b/drivers/video/geode/lxfb.h
> > @@ -33,7 +33,7 @@ void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
> >  
> >  #define MSR_LX_GLD_CONFIG    0x48002001
> >  #define MSR_LX_GLCP_DOTPLL   0x4c000015
> > -#define MSR_LX_DF_PADSEL     0x48000011
> > +#define MSR_LX_DF_PADSEL     0x48002011
> >  #define MSR_LX_DC_SPARE      0x80000011
> >  #define MSR_LX_DF_GLCONFIG   0x48002001
> >  
> 
> Please put MSR indicies in <asm-x86/msr-index.h> and/or a separate 
> include file.

The Geode has zillions upon zillions of MSRs (all of them being Geode 
specific), so putting them in asm-x86/msr-index.h would be a bad idea
for both you and me.  But tossing them into a asm-x86/geode-msr.h file
would be good for 2.6.25.  I'll get working on that.

In the mean time, this particular #define is already in the tree, and this
patch fixes serious breakage, so I would really like to see it hit 2.6.24,
if we can.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


