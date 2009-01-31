Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZAaOwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZAaOwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZAaOwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:52:32 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:54516 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbZAaOwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:52:31 -0500
Date: Sat, 31 Jan 2009 23:52:30 +0900 (JST)
Message-Id: <20090131.235230.90118475.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: hskinnemoen@atmel.com, kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel-mci: fix initialization of dma slave data
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090131.210651.126573837.anemo@mba.ocn.ne.jp>
References: <20090130230248.2402.65405.stgit@dwillia2-linux.ch.intel.com>
	<20090131.210651.126573837.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 21:06:51 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > The conversion of atmel-mci to dma_request_channel missed the initialization
> > of the channel dma_slave information.  dma_request_channel, along with the
> > filter_fn, find the channel with the proper capabilities, then it is up to the
> > driver to update the dw_dma_chan with its slave data.
> > 
> > Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Thanks.  This patch disclose struct dw_dma_chan to its client.  But
> the struct seems too private for me.  Maybe we need some generic
> method to pass slave information?  Any idea or plan?

Also, it seems too late to initialize dwc->dws after returning from
dma_request_channel().  The alloc_chan_resources routine of dw_dmac
driver needs dmc->dws and it is called from dma_request_channel() via
dma_chan_get().

---
Atsushi Nemoto
