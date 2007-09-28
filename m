Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXI1QPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXI1QPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXI1QPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:15:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbXI1QPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:15:42 -0400
Date: Fri, 28 Sep 2007 09:15:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch] x86: improved memory barrier implementation
In-Reply-To: <20070928170719.2f617a7a@the-village.bc.nu>
Message-ID: <alpine.LFD.0.999.0709280911100.3579@woody.linux-foundation.org>
References: <20070928154832.GB12538@wotan.suse.de>
 <20070928170719.2f617a7a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Sep 2007, Alan Cox wrote:
> 
> However 
> - You've not shown the patch has any performance gain

It would be nice to see this.

> - You've probably broken Pentium Pro

Probably not a big deal, but yeah, we should have that broken-ppro option.

> - and for modern processors its still not remotely clear your patch is
> correct because of NT stores.

This one I disagree with. The *old* code doesn't honor NT stores *either*. 

The fact is, if you use NT stores and then depend on ordering, it has 
nothing what-so-ever to do with spinlocks or smp_[rw]mb. You need to use 
the DMA barriers (ie the non-smp ones).

The non-temporal stores should be basically considered to be "IO", not any 
normal memory operation.

		Linus
