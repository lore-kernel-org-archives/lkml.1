Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbXKLQpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbXKLQpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbXKLQpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:45:04 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:53998 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbXKLQpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:45:02 -0500
X-Greylist: delayed 2033 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 11:45:02 EST
Date: Mon, 12 Nov 2007 11:11:06 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Yoav Artzi <yoavar@checkpoint.com>
Cc: Adrian Bunk <bunk@kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE on 64bit and 32bit machines
Message-ID: <20071112161106.GB24243@fattire.cabal.ca>
References: <473865BE.2070806@checkpoint.com> <47386DC9.4020905@gmail.com> <47387214.2010200@checkpoint.com> <20071112153908.GK9771@stusta.de> <47387810.3060503@checkpoint.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47387810.3060503@checkpoint.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 05:58:08PM +0200, Yoav Artzi wrote:
> Looking at the source, I see:
> 
> #ifdef CONFIG_4KSTACKS
> #define THREAD_SIZE            (4096)
> #else
> #define THREAD_SIZE        (8192)
> #endif
> 
> 
> So if I configure the option CONFIG_4KSTACK, I will get a 4KB kernel 
> stack. Am I missing something here?
> 

This is only on i386 (32-bit x86...)[1] On x86-64, we have 8K kernel
stacks (THREAD_ORDER 1), and 16K irqstacks (IRQSTACK_ORDER 2).

The relevant defines are found in <asm-x86/page_64.h> for x86_64, and
<asm-x86/thread_info_32.h> for i386.

Cheers,
	Kyle

1. That is, stack size is only configurable on 32bit.
