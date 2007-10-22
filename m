Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbXJVT5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbXJVT5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXJVT5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:57:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54977 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbXJVT5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:57:02 -0400
Date: Mon, 22 Oct 2007 12:56:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
In-Reply-To: <20071022194714.GI27248@parisc-linux.org>
Message-ID: <alpine.LFD.0.999.0710221254550.30120@woody.linux-foundation.org>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru>
 <20071022152912.GA841@linux-mips.org> <20071022112110.105b8e11.akpm@linux-foundation.org>
 <200710222110.34768.arnd@arndb.de>
 <20071022194714.GI27248@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Oct 2007, Matthew Wilcox wrote:
> 
> We certainly don't want to encourage people to blindly make those
> conversions ... and I've seen the results of encouraging kernel janitors
> to do things a certain way.

There's another issue: the "irqsave/irqrestore" versions are much safer 
than the plain "irq" versions, in case the caller already has interrupts 
disabled. 

So anybody making the change not only would need to make the performance 
argument, he'd better not be a janitor that blindly does the change 
without thinking about all call-sites etc..

		Linus
