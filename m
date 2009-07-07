Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbZGGHtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbZGGHtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZGGHsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:48:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42894 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbZGGHsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:48:54 -0400
Date: Tue, 7 Jul 2009 08:48:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
	in dma_sync_*_for_cpu
Message-ID: <20090707074821.GB6995@n2100.arm.linux.org.uk>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906301448.55064.arnd@arndb.de> <20090630140945.0784e174@lxorguk.ukuu.org.uk> <200906301538.44684.arnd@arndb.de> <d82e647a0907061854l7d862191w1a9aa667eca7abb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0907061854l7d862191w1a9aa667eca7abb5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 09:54:20AM +0800, Ming Lei wrote:
> 2009/6/30 Arnd Bergmann <arnd@arndb.de>:
> > On Tuesday 30 June 2009, Alan Cox wrote:
> > Well, not even that. dma-mapping-common.h only makes sense on architectures
> > that have multiple dma-mapping implementations (parisc, mips, arm, powerpc,
> 
> It seems that there is only one dma-mmaping implementation on ARM, doesn't it?
> Is it necessary that using dma-mapping-common.h on ARM?

ARM has two (normal, and dma bounce), and in the long run we need to do
cache handling on unmap as well as map due to CPU speculative fetches.
