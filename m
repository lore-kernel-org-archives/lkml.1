Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZCUM31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZCUM31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZCUM3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:29:19 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:61034 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZCUM3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:29:18 -0400
Date: Sat, 21 Mar 2009 21:29:20 +0900 (JST)
Message-Id: <20090321.212920.25912728.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20903181026h1801ef6i945e6ce9ccb36b8a@mail.gmail.com>
References: <e9c3a7c20903171823g1e6c42b9t5f042d550a6ddd47@mail.gmail.com>
	<20090318.110154.76582864.nemoto@toshiba-tops.co.jp>
	<e9c3a7c20903181026h1801ef6i945e6ce9ccb36b8a@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 10:26:13 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> > The atmel-mci does not select "channel".  It just pick the first
> > usable channel of the dma_device specified by platform_data.  I
> > suppose dw_dmac is symmetric (it can use any channel for any slave).
> 
> You are right, it does not hardwire the channel, but it does hardwire
> the device, see at32_add_device_mci [1].
> 
> > But TXx9 SoC DMAC channels are hardwired to each peripheral devices.
> 
> I think creating a dma_device instance per channel and specifying that
> device like atmel-mci is the more future-proof way to go.

Well, I have considered it but it looks overkill for me at that time.
Maybe time to think again...

> > And I want to call Channel-3 of DMAC-0 "dma0chan3" even if Channel-2
> > was assigned to for public memcpy channel.
> 
> The problem is you could pass in the chan_id to guarantee 'chan3', but
> there is no guarantee that you will get 'dma0', as the driver has no
> knowledge of what other dma devices may be in the system.

Yes, I do not expect 'dma0'.  My filter function uses
dev_name(chan->device->dev), which is "txx9dmac.0" in this case.

Anyway, "one dma-device per channel" manner will make things much simpler.

---
Atsushi Nemoto
