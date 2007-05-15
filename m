Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbXEOP6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbXEOP6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 11:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbXEOP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 11:58:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756557AbXEOP6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 11:58:07 -0400
Date: Tue, 15 May 2007 08:57:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: andrew hendry <andrew.hendry@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
In-Reply-To: <d45a3acc0705142210w3982c14ep8afac73c1352ec7e@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0705150855270.16401@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
  <d45a3acc0705142114t2ed13889p5ed97740782d2821@mail.gmail.com> 
 <alpine.LFD.0.98.0705142135390.6739@woody.linux-foundation.org>
 <d45a3acc0705142210w3982c14ep8afac73c1352ec7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 May 2007, andrew hendry wrote:
>
> almost, highstart_pfn is used in a few printks
> 
> arch/i386/mm/discontig.c: In function 'setup_memory':
> arch/i386/mm/discontig.c:314: error: 'highstart_pfn' undeclared (first
> use in this function)
> arch/i386/mm/discontig.c:314: error: (Each undeclared identifier is
> reported only once
> arch/i386/mm/discontig.c:314: error: for each function it appears in.)

Gaah. highstart_pfn is declared in <asm/highmem.h>, but that one is 
protected by a

	#ifdef CONFIG_HIGHMEM
	#include <asm/highmem.h>

in <linux/highmem.h>, so even though we include highmem.h, we never see 
the declaration.

Your config is insane, but anyway, does it compile if you just add back 
the extra "unnecessary" declaration of highstart_pfn?

		Linus
