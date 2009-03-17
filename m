Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbZCQCUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbZCQCUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 22:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZCQCUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 22:20:23 -0400
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:59660 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752900AbZCQCUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 22:20:22 -0400
Date: Tue, 17 Mar 2009 11:20:19 +0900 (JST)
Message-Id: <20090317.112019.147212126.nemoto@toshiba-tops.co.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1237240246.27945.6.camel@dwillia2-linux.ch.intel.com>
References: <20090313.011950.61509382.anemo@mba.ocn.ne.jp>
	<20090313.231659.41197617.anemo@mba.ocn.ne.jp>
	<1237240246.27945.6.camel@dwillia2-linux.ch.intel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 14:50:46 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> > And above "continue" looks buggy anyway.  Keeping incomplete channels
> > in device->channels list looks very dangerous...
> 
> Yes it does.  Here is the proposed fix:
> ----->
> dmaengine: fail device registration if channel registration fails
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Atsushi points out:
> "If alloc_percpu or kzalloc failed, chan_id does not match with its
> position in device->channels list.
> 
> And above "continue" looks buggy anyway.  Keeping incomplete channels
> in device->channels list looks very dangerous..."
> 
> Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thanks, but it seems a hole sill exists.  If alloc_percpu or kzalloc
for the first channel failed, when idr_ref will be freed ?

Hmm.. why idr_ref is dynamically allocated?  Just putting it in
dma_device makes thing more simple, no?

---
Atsushi Nemoto
