Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbXIRVCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbXIRVCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXIRVCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:02:08 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:50526 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXIRVCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kaaaj5v7WnN9VIIV+Z2pE5uY7at7YgC2aCqK7f/LyZ4qvGCrjXt5W85yMm5MN2KdtLchiPM7ovGm3NvWKkY/GNRZjZ9ZWoWSMncvtbpxNF89A7K4BCY8q//69KvbRNZu1ylfrktv2RRF2oipKxVU/rrm6VfNMOcbR4/XGAKLQn4=
Message-ID: <43e72e890709181402x7335d0acp306cf576fac6c070@mail.gmail.com>
Date: Tue, 18 Sep 2007 17:02:06 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	 <20070918113401.6a8a737f@the-village.bc.nu>
	 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
	 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>
	 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
	 <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com>
	 <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 18 Sep 2007, Luis R. Rodriguez wrote:
> >
> > An extra branch is created on MMIO-only devices on read/writes on the
> > IO_COND macro using this interface -- or is this optimized out?
>
> Umm. Does anybody actually have any performance numbers?
>
> The thing is, those things are *cheap* compared to the IO. And any
> high-performance device will be using DMA for the real IO, so we're not
> generally even talking about any performance-critical stuff.

ACK but do we really need to benchmark this if we *know* we are
creating unnecessary branches? How about Jeff's suggestion of
introducing pci_mmio_map() ? This way we leave the current
documenation as it is and just introduce this for MMIO-only devices.
No benchmarks are necessary then, and no need to confuse people with
the old API.

  Luis
