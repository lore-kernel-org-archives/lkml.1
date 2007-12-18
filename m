Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXLRLB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXLRLB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXLRLBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:01:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbXLRLBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:01:48 -0500
Date: Tue, 18 Dec 2007 03:01:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] initrd: Fix virtual/physical mix-up in overwrite test
Message-Id: <20071218030131.8b272833.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712161148340.5869@anakin>
References: <Pine.LNX.4.64.0712161148340.5869@anakin>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2007 11:51:00 +0100 (CET) Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On recent kernels, I get the following error when using an initrd:
> 
> | initrd overwritten (0x00b78000 < 0x07668000) - disabling it.
> 
> My Amiga 4000 has 12 MiB of RAM at physical address 0x07400000 (virtual
> 0x00000000).
> The initrd is located at the end of RAM: 0x00b78000 - 0x00c00000 (virtual).
> The overwrite test compares the (virtual) initrd location to the (physical)
> first available memory location, which fails.
> 
> This patch converts initrd_start to a page frame number, so it can be safely
> compared with min_low_pfn.
> 
> Before the introduction of discontiguous memory support on m68k
> (12d810c1b8c2b913d48e629e2b5c01d105029839), min_low_pfn was just left
> untouched by the m68k-specific code (zero, I guess), and everything worked
> fine.

breaks x86.

init/main.c: In function 'start_kernel':
init/main.c:601: error: implicit declaration of function 'virt_to_pfn'
init/main.c:603: warning: format '%08lx' expects type 'long unsigned int', but argument 2 has type 'int'
