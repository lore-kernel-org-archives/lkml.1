Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZKYLEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZKYLEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZKYLEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:04:39 -0500
Received: from sh.osrg.net ([192.16.179.4]:39068 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZKYLEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:04:39 -0500
Date: Wed, 25 Nov 2009 20:03:56 +0900
To: yinghai@kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B0CFCA6.5070708@kernel.org>
References: <20091125180517P.fujita.tomonori@lab.ntt.co.jp>
	<20091125091026.GA11117@elte.hu>
	<4B0CFCA6.5070708@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091125200337I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 25 Nov 2009 20:03:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 01:45:10 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> >> On Wed, 25 Nov 2009 00:54:34 -0800
> >> Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >>> only remember that SLES 9 SP3 (?) at some point has problem with AMD 
> >>> 10h ( quad core version) when memory > 4 g (with USB controller ?) 
> >>> because the gart code only check K8 device id, and didn't check 10h 
> >>> device id. so gart iommu is not used. and happenly swiotlb code has 
> >>> problem with that kernel version.
> >>>
> >>> thinking we should keep old behavior, until some day we can remove 
> >>> them all.
> >> Why? We are talking about changing 2.6.33 behavior. swiotlb in 2.6.33 
> >> should be the safe option.
> > 
> > If that behavior was relied on for suspected (or real) bugs in the 
> > swiotlb code then i agree that we should do this change. (and fix any 
> > bugs if they still occur.)
> 
> after look at gart_iommu_hole_init() closely,
> 
> should be
> 
> for AMD 64bit, MEM > 4g, no AGP, iommu=soft
> 1. if BIOS have correct gart setting, Kernel will use swiotlb
> 2. if BIOS does not have correct gart setting, Kernel will use swiotlb
> 
> and for the all the cases, the codes after that 
> /* Fix up the north bridges */
> ...
> 
> will disable the translation...

What code are you talking about? GART translation is disabled at boot
time (if not, we are dead because some GART hardware are broken so we
need to fix things before enabling them).


> so even swiotlb=soft is used, gart_iommu_hole_init() still need to
> be called. to make sure aperture is disabled somehow.

I don't think so.
