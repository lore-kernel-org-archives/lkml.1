Return-Path: <linux-kernel-owner+w=401wt.eu-S1751401AbZITElI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbZITElI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 00:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZITElI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 00:41:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbZITElH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 00:41:07 -0400
Subject: Re: Current git fails to boot with VT-D enabled due to flood of
 DMAR errors
From: David Woodhouse <dwmw2@infradead.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB5B07B.5090506@gmail.com>
References: <4AB5B07B.5090506@gmail.com>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 21:41:08 -0700
Message-Id: <1253421668.6317.83.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 22:32 -0600, Robert Hancock wrote:
> On an Asus P7P55D Pro-based system (Lynnfield CPU), with Intel VT-d 
> enabled in the BIOS, on 2.6.30.5 (the previous version I tested) I get 
> these lines in dmesg:
> 
> DMAR:Host address width 36
> DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed90000
> DMAR:RMRR base: 0x00000000000e4000 end: 0x00000000000e7fff
> DMAR:RMRR base: 0x00000000bf7ec000 end: 0x00000000bf7fffff
> Not all IO-APIC's listed under remapping hardware
> 
> In current -git, I get these lines as well, but then I get this:
> 
> DRHD: handling fault status reg ffffffff
> DMAR:[DMA Read] Request device [ff:1f.7] fault addr fffffffffffff000
> DMAR:[fault reason 255] Unknown
> 
> The last two lines repeat in a continuous flood and the system doesn't 
> boot. This happens even if I pass "intel_iommu=off" (which seems like 
> it's already the default).
> 
> Could be a kernel bug or a BIOS bug, but in the latter case we should 
> probably deal with it better. The registers all reading FF seems like 
> maybe the registers are disabled or something..

This ought to be 'fixed' in linux-next by this commit:
http://git.infradead.org/iommu-2.6.git/commitdiff/0815565ad

Please try linux-next or the iommu tree from
git://git.infradead.org/iommu-2.6.git

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

