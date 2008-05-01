Return-Path: <linux-kernel-owner+w=401wt.eu-S1764357AbYEAR2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764357AbYEAR2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762188AbYEAR2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:28:04 -0400
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:54741 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759261AbYEAR2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:28:03 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Date: Thu, 1 May 2008 10:27:35 -0700
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de> <200805010930.04799.jbarnes@virtuousgeek.org> <200805011916.07340.mb@bu3sch.de>
In-Reply-To: <200805011916.07340.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011027.36252.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 01, 2008 10:16 am Michael Buesch wrote:
> > So it makes sense to
> > just update the current code to fallback, and update drivers wanting
> > specific mask values to check afterwards.  I hate to inflict that kind of
> > driver wide update on Michael though... :)
>
> Well, that's a lot of work and I'm not sure it's worth it.
> I could live with having dma_set_mask as an API that fails on bad masks
> and dma_request_mask as an API above that which retries. I think that's
> just fine. Drivers can be migrated over time to the new API (or not. That
> can be the driver maintainer's choice).

Oh and for dma_set_mask specifically I don't see that many callers, so 
updating the tree appears doable (meye, aic7xxx, lasai700, qla2xxx, 
sni_53c710, ssb & ehci in my quick look). pci_set_dma_mask otoh is used in 
lots more places (and iirc some platforms implement pci_set_dma_mask in terms 
of dma_set_mask, so small updates would be needed there).

Thanks,
Jesse
