Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYIPNVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYIPNVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYIPNVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:21:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:59788 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbYIPNVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:21:07 -0400
Date: Tue, 16 Sep 2008 22:20:40 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about
 virtual mappings
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <87hc8grjuf.fsf@basil.nowhere.org>
References: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<87hc8grjuf.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080916222032O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 02:54:32 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> 
> > Currently, gart IOMMU ignores device's dma_mask when it does virtual
> > mappings. So it could give a device a virtual address that the device
> > can't access to.
> 
> Huh? That is what the need_iommu() logic in gart_map_sg()
> does. An I'm not aware of any bugs in this area.

What the need_iommu() does is seeing if GART needs to do virtual
mappings or not.

(After need_iommu() checking) What this patchset does is to guarantee
that GART provides a virtual address that a device can access to.


> Did you actually see that failure in practice? I don't see
> how it could happen.

No, I did not. This patchset does the right thing theoretically, I
think, but if such problem never happens for GART, I'll drop the patch
for GART. Joerg?
