Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZJVOrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZJVOrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbZJVOrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:47:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbZJVOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:47:48 -0400
Subject: Re: [PATCH] intel-iommu: Fix alloc_coherent for pass-through
 devices
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: iommu@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>
In-Reply-To: <1256214241.2842.50.camel@2710p.home>
References: <1256182910.2842.36.camel@2710p.home>
	 <1256192928.2990.10.camel@macbook.infradead.org>
	 <1256214241.2842.50.camel@2710p.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Oct 2009 23:47:47 +0900
Message-Id: <1256222867.2990.47.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 06:24 -0600, Alex Williamson wrote:
> The coherent_dma_mask is independent of the dma_mask and can be set
> separately by the device.  The default for any device that doesn't
> specify one is 32bits.  iommu_should_identity_map() only checks the
> dma_mask, not the coherent_dma_mask. 

Are you telling me that this particular device supports only a 32-bit
coherent DMA mask, but that it _does_ support a 64-bit DMA mask for
non-coherent DMA? On x86?

>  BTW, we skip RMRR setup when doing hardware pass-through, but I can't
> find where they get reloaded if we then end up removing the device
> from the si_domain.  Is this another issue?

Maybe, theoretically. In practice, the whole RMRR thing is just broken
by design anyway. We have to quiesce the offending devices before we
turn on the IOMMU, because BIOSes tend to leave things out of the RMRR
table... and then crash in SMM mode when their DMA goes AWOL. 

-- 
dwmw2

