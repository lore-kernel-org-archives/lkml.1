Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYKFVXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYKFVXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYKFVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:23:37 -0500
Received: from bu3sch.de ([62.75.166.246]:37708 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYKFVXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:23:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] ssb: Fix DMA-API compilation for non-PCI systems
Date: Thu, 6 Nov 2008 22:23:09 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "John Linville" <linville@tuxdriver.com>,
       "Mike Frysinger" <vapier@gentoo.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200811062149.21841.mb@bu3sch.de> <8bd0f97a0811061316u6b9a330dy279cb7dca679ab73@mail.gmail.com>
In-Reply-To: <8bd0f97a0811061316u6b9a330dy279cb7dca679ab73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811062223.09400.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2008 22:16:00 Mike Frysinger wrote:
> On Thu, Nov 6, 2008 at 15:49, Michael Buesch wrote:
> > --- wireless-testing.orig/include/linux/ssb/ssb.h       2008-08-01 17:26:05.000000000 +0200
> > +++ wireless-testing/include/linux/ssb/ssb.h    2008-11-06 21:45:37.000000000 +0100
> > @@ -427,12 +427,16 @@ static inline int ssb_dma_mapping_error(
> >  {
> >        switch (dev->bus->bustype) {
> >        case SSB_BUSTYPE_PCI:
> > +#ifdef CONFIG_SSB_PCIHOST
> >                return pci_dma_mapping_error(dev->bus->host_pci, addr);
> > +#endif
> > +               break;
> >        case SSB_BUSTYPE_SSB:
> >                return dma_mapping_error(dev->dev, addr);
> >        default:
> > -               __ssb_dma_not_implemented(dev);
> > +               break;
> >        }
> 
> all these functions now read:
> default: break;
> seems kind of pointless ... why not just drop that case completely

Because the compiler complains "not handled all cases...".
And yes, we do want to trigger __ssb_dma_not_implemented() for
these cases.

-- 
Greetings Michael.
