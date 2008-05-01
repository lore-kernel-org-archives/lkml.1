Return-Path: <linux-kernel-owner+w=401wt.eu-S1762295AbYEAPm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295AbYEAPm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbYEAPms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:42:48 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:57698 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbYEAPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:42:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Date: Thu, 1 May 2008 17:42:04 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de> <20080501153618.GA470@infradead.org>
In-Reply-To: <20080501153618.GA470@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011742.05302.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008 17:36:18 Christoph Hellwig wrote:
> On Thu, May 01, 2008 at 04:38:15PM +0200, Michael Buesch wrote:
> > This patchset adds API and one user for a "weak" dma_set_mask().
> > Weak means that it will fallback to smaller masks in case the
> > DMA subsystem rejects a big mask.
> > Currently such rejection may happen if the driver requests a 64bit
> > mask on a VIA machine, for example. dma_set_mask_weak() will fallback
> > to 32bit, in that case, and tell the caller about it by modifying the
> > passed mask.
> 
> Why do we need it?  Is the call to set the 32bit mask when it fails
> a too big burden for the driver author?

Yeah. because it has to be done in every driver.
So we put the implementation into a central place, instead of
reimplementing the wheel over and over again. This way we avoid bugs,
like the "b43 broken on VIA boards" in the first place.
Currently every driver requesting a >32bit mask and not retrying with
a lower mask is broken on VIA hardware. I dunno how many of the current
drivers that are, but everybody can easily see that is not a b43-specific
problem that we should solve for b43 only.

-- 
Greetings Michael.
