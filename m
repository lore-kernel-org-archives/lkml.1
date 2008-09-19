Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYISKWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYISKWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYISKVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:21:54 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60545 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYISKVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:21:54 -0400
Date: Fri, 19 Sep 2008 19:21:09 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919062946.GH27426@8bytes.org>
References: <20080918140350.GE24392@amd.com>
	<20080919081020S.fujita.tomonori@lab.ntt.co.jp>
	<20080919062946.GH27426@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080919192100G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 08:29:46 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > index c2e00ee..569527e 100644
> > > --- a/Documentation/kernel-parameters.txt
> > > +++ b/Documentation/kernel-parameters.txt
> > > @@ -888,6 +888,10 @@ and is between 256 and 4096 characters. It is defined in the file
> > >  		nomerge
> > >  		forcesac
> > >  		soft
> > > +		fullflush
> > > +			Flush IO/TLB at every deallocation
> > > +		nofullflush
> > > +			Flush IO/TLB only when addresses are reused (default)
> > 
> > I'm not sure about making 'nofullflush' a generic option. Enabling
> > nofullflush option doesn't change anything. So what's the point of the
> > option?
> 
> Backwards compatability with the GART code. These two options are
> basically just moved from the GART code to pci-dma.c. But otherwise its
> pointless, I can remove it if everybody else agrees.

The compatibility with the GART code doesn't mean that we need to have
this pointless option as a common option. You can make 'fullflush' a
common option and the meaningless 'nofullflush' can live in GART.
