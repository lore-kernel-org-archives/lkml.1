Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZCZOMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZCZOMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZCZOMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:12:36 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52011 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZCZOMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:12:35 -0400
Date: Thu, 26 Mar 2009 23:12:43 +0900 (JST)
Message-Id: <20090326.231243.112855442.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090321.212920.25912728.anemo@mba.ocn.ne.jp>
References: <20090318.110154.76582864.nemoto@toshiba-tops.co.jp>
	<e9c3a7c20903181026h1801ef6i945e6ce9ccb36b8a@mail.gmail.com>
	<20090321.212920.25912728.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 21:29:20 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > I think creating a dma_device instance per channel and specifying that
> > device like atmel-mci is the more future-proof way to go.
> 
> Well, I have considered it but it looks overkill for me at that time.
> Maybe time to think again...
> 
> > > And I want to call Channel-3 of DMAC-0 "dma0chan3" even if Channel-2
> > > was assigned to for public memcpy channel.
> > 
> > The problem is you could pass in the chan_id to guarantee 'chan3', but
> > there is no guarantee that you will get 'dma0', as the driver has no
> > knowledge of what other dma devices may be in the system.
> 
> Yes, I do not expect 'dma0'.  My filter function uses
> dev_name(chan->device->dev), which is "txx9dmac.0" in this case.
> 
> Anyway, "one dma-device per channel" manner will make things much simpler.

Unfortunately, not so simple.  If I created a dma_device for each
channel, all chan->chan_id will be 0 and all chan->device->dev points
same platform device.  This makes client driver hard to select the
particular channel.  Making a platform device for each channel will
solve this, but it looks wrong way to go for me.

So I will go back to multiple channels per device style, and try to
simplify "reservation".  While all client should know correct channel
number, the reservation is just for detecting bad configuration.

---
Atsushi Nemoto
