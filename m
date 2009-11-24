Return-Path: <linux-kernel-owner+w=401wt.eu-S934492AbZKYADM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492AbZKYADM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934439AbZKYADL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:03:11 -0500
Received: from sh.osrg.net ([192.16.179.4]:52735 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934417AbZKYADK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:03:10 -0500
Date: Wed, 25 Nov 2009 08:57:43 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, yinghai@kernel.org, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix gart iommu using for amd 64 bit system
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091124152645.GD21821@elte.hu>
References: <4B0BB892.9080401@kernel.org>
	<20091124225000H.fujita.tomonori@lab.ntt.co.jp>
	<20091124152645.GD21821@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091125085730S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 25 Nov 2009 08:57:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 16:26:45 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > > don't think user will like to use SWIOTLB instead of swiotlb.
> > 
> > I doubt that users care about a way to fix their problems.
> 
> As far as swiotlb vs. GART goes, arguably a non-bouncing hw based 
> solution (GART) is superior to a bouncing one (swiotlb), right?

Yeah, but GART is not a real IOMMU that always does address
translation. If users want performance, they need 64bit DMA capable
devices to skip GART. With such devices, GART and SWIOTLB are same.

So this hacky GART workaround is useful for only people who use non
64bit DMA devices and broken BIOS with GART. IMO, it's not worth
having the workaround.
