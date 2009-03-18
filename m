Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZCRCCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZCRCCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZCRCB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:01:59 -0400
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:52317 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752890AbZCRCB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:01:58 -0400
Date: Wed, 18 Mar 2009 11:01:54 +0900 (JST)
Message-Id: <20090318.110154.76582864.nemoto@toshiba-tops.co.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20903171823g1e6c42b9t5f042d550a6ddd47@mail.gmail.com>
References: <e9c3a7c20903171002n50964148v8366fa2f00e3164c@mail.gmail.com>
	<20090318.094935.238694196.nemoto@toshiba-tops.co.jp>
	<e9c3a7c20903171823g1e6c42b9t5f042d550a6ddd47@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
Organization: TOSHIBA Personal Computer System Corporation
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 18:23:46 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> Now, back to the issue at hand.  Does your driver still need direct
> control over chan->chan_id, or can it now rely on the fact that
> dma_async_device_register() will fail if a channel is not initialized?
>  Or, just use some platform_data to identify the channel in the same
> manner as atmel-mci?

Yes, I still want to control chan->chan_id.

The atmel-mci does not select "channel".  It just pick the first
usable channel of the dma_device specified by platform_data.  I
suppose dw_dmac is symmetric (it can use any channel for any slave).
But TXx9 SoC DMAC channels are hardwired to each peripheral devices.

And I want to call Channel-3 of DMAC-0 "dma0chan3" even if Channel-2
was assigned to for public memcpy channel.

---
Atsushi Nemoto
