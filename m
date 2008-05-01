Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbYEAQas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbYEAQas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbYEAQal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:30:41 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:38682 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753167AbYEAQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:30:40 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Date: Thu, 1 May 2008 09:30:04 -0700
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de> <20080501155826.GA11188@infradead.org> <200805011807.26036.mb@bu3sch.de>
In-Reply-To: <200805011807.26036.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010930.04799.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 01, 2008 9:07 am Michael Buesch wrote:
> On Thursday 01 May 2008 17:58:26 Christoph Hellwig wrote:
> > On Thu, May 01, 2008 at 05:47:26PM +0200, Michael Buesch wrote:
> > > We've discussed that and this behaviour is not acceptable, as the
> > > driver must know about a possible fallback in case it can do 32bit DMA
> > > more efficiently than 64bit DMA, for example.
> >
> > That's what we have dma_get_required_mask() for.  See
> > Documentation/DMA-API.txt.
>
> So well. I'm still unsure about the advantage of having some opencoded
> probe loop in the driver, instead of implementing it in a common place
> and doing all of it with a single API call.
> We can still call dma_get_required_mask() and adjust the mask to that
> in dma_set_mask_weak(). That can _additionally_ be done there.

So I think we're agreed that we want some core function to fall back to 
different mask values, but yeah, making it take dma_get_required_mask into 
account would also be good.

Most drivers just do the fallback themselves, right?  So it makes sense to 
just update the current code to fallback, and update drivers wanting specific 
mask values to check afterwards.  I hate to inflict that kind of driver wide 
update on Michael though... :)

Jesse
