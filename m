Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZDUBGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZDUBGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZDUBG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:06:27 -0400
Received: from fwgate.192.149.94.202.in-addr.arpa ([202.94.149.254]:11708 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752690AbZDUBG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:06:27 -0400
X-Greylist: delayed 1919 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 21:06:26 EDT
Date: Tue, 21 Apr 2009 09:34:21 +0900 (JST)
Message-Id: <20090421.093421.139385711.nemoto@toshiba-tops.co.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: TXx9 Soc DMA Controller driver (v2)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <49ECF040.2000508@intel.com>
References: <e9c3a7c20904181305l5a7ea5dcy881b7faec8e447bf@mail.gmail.com>
	<20090420.033446.65190767.anemo@mba.ocn.ne.jp>
	<49ECF040.2000508@intel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 14:59:28 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> >> There seems to be a lot of ifdef magic in the code based on these
> >> defines.  Can we move this magic and some of the pure definitions to
> >> drivers/dma/txx9dmac.h?  (See the "#ifdefs are ugly" section of
> >> Documentation/SubmittingPatches)
> > OK, I will try to clean them up.  But since I don't want to export
> > internal implementation details, some of the magics will be left in
> > txx9dmac.c, perhaps.
> 
> You only need to hide txx9dmac magic if the header was in
> include/linux/, but since it will be in drivers/dma/ you can assume
> it is private.

Oh I missed that you said driver/dma/txx9dmac.h, not include/asm/txx9/dmac.h.
OK, I will do.

> > The completion callback handler of the first descriptor should be
> > called _after_ the completion of the _last_ child of the descriptor.
> > Also I use desc_node for both dc->queue, dc->active_list and
> > txd.tx_list.  So if I putted all children to dc->queue or
> > dc->active_list, txx9dmac_descriptor_complete() (or its caller) will
> > be more complex.
> > Or do you mean adding another list_head to maintain txd.tx_list?  Or
> > something another at all?
> 
> The piece I was missing was that it would make
> txx9dmac_descriptor_complete() more complex.  So, I am fine with the
> leaving the current implementation.

Thanks.  I will add some comments about that.

---
Atsushi Nemoto
