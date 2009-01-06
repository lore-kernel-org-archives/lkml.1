Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbZAFCG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbZAFCG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZAFCGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:06:48 -0500
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:27463 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751293AbZAFCGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:06:47 -0500
Date: Tue, 06 Jan 2009 11:06:42 +0900 (JST)
Message-Id: <20090106.110642.130607183.nemoto@toshiba-tops.co.jp>
To: dan.j.williams@intel.com
Cc: anemo@mba.ocn.ne.jp, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
       maciej.sosnowski@intel.com, ralf@linux-mips.org
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer
 before DMA
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4962B414.8010601@intel.com>
References: <e9c3a7c20901051031y528d0d31r18d44c5096c59e0@mail.gmail.com>
	<20090106.101425.109407744.nemoto@toshiba-tops.co.jp>
	<4962B414.8010601@intel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 18:29:56 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> > Yes, MIPS and ARM do different thing on partial cache line.  But I
> > suppose this belongs to "implementation dependent" area of DMA API so
> > users of the API should not depend on it.  (Well, maybe I'm biased to
> > MIPS ;-))
> > In general, drivers must not put normal data and DMA buffer on same
> > cacheline anyway to avoid unexpected writeback and data loss.  So this
> > ambiguity is not a problem.  IMHO writeback of the partial line for
> > DMA_FROM_DEVICE just _hides_ abusing of the DMA API and potential data
> > loss.
> 
> Hmm... one implementation does the right thing in all cases.

Yes, with additional checking in generic path :-)

> The other silently allows data corruption unless each callsite that
> accidentally or purposely passes cacheline-unaligned buffers adds
> extra maintenance code.  Which implementation are you biased towards
> now? :-).

Hmm... this is generic DMA mapping API (or linux-arch) issue.  Let's
wait comments from arch maintainers.  Ralf ?

---
Atsushi Nemoto
