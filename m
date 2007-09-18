Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXIRUbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXIRUbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXIRUbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:31:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbXIRUbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:31:01 -0400
Date: Tue, 18 Sep 2007 13:30:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
In-Reply-To: <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com> 
 <20070918113401.6a8a737f@the-village.bc.nu> 
 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com> 
 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org> 
 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com> 
 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
 <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Luis R. Rodriguez wrote:
> 
> An extra branch is created on MMIO-only devices on read/writes on the
> IO_COND macro using this interface -- or is this optimized out?

Umm. Does anybody actually have any performance numbers? 

The thing is, those things are *cheap* compared to the IO. And any 
high-performance device will be using DMA for the real IO, so we're not 
generally even talking about any performance-critical stuff. 

Quite frankly, if performance is a _real_ reason to avoid 
ioread*/iowrite*, I'll happily accept read*/write*, but it would be needed 
to be backed up by real numbers. Can you even measure it?

I would definitely *not* encourage the notion that people should use 
readl/writel because of "performance reasons". That may be valid for some 
fbcon driver, but those drivers go to other extremes (ie they use 
"__raw_writel()" etc, and MTRR's etc).

If you don't use write-combining memory regions, the performance argument 
is not really valid.

			Linus
