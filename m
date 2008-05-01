Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbYEAReM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbYEAReM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYEARdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:33:54 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:40467 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYEARdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:33:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Date: Thu, 1 May 2008 19:33:08 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Christoph Hellwig <hch@infradead.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de> <200805011916.07340.mb@bu3sch.de> <200805011027.36252.jbarnes@virtuousgeek.org>
In-Reply-To: <200805011027.36252.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011933.09061.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008 19:27:35 Jesse Barnes wrote:
> On Thursday, May 01, 2008 10:16 am Michael Buesch wrote:
> > > So it makes sense to
> > > just update the current code to fallback, and update drivers wanting
> > > specific mask values to check afterwards.  I hate to inflict that kind of
> > > driver wide update on Michael though... :)
> >
> > Well, that's a lot of work and I'm not sure it's worth it.
> > I could live with having dma_set_mask as an API that fails on bad masks
> > and dma_request_mask as an API above that which retries. I think that's
> > just fine. Drivers can be migrated over time to the new API (or not. That
> > can be the driver maintainer's choice).
> 
> Oh and for dma_set_mask specifically I don't see that many callers, so 
> updating the tree appears doable (meye, aic7xxx, lasai700, qla2xxx, 
> sni_53c710, ssb & ehci in my quick look). pci_set_dma_mask otoh is used in 
> lots more places (and iirc some platforms implement pci_set_dma_mask in terms 
> of dma_set_mask, so small updates would be needed there).

I was thinking about also adding a "request" call to the PCI DMA API,
as we have the same retry-issue there.

-- 
Greetings Michael.
