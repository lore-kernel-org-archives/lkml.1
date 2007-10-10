Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbXJJViP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbXJJViP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbXJJViA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:38:00 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42419 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbXJJVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:37:59 -0400
X-Originating-Ip: 99.236.101.138
Date: Wed, 10 Oct 2007 17:33:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: Sam Ravnborg <sam@ravnborg.org>,
       parisc-linux-request@lists.parisc-linux.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: parisc arch makefile clean-up needed [Was: cleaning up "make
 headers_install" for various architectures]
In-Reply-To: <20071010202128.GG2730@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0710101729001.17053@localhost.localdomain>
References: <Pine.LNX.4.64.0710101234340.32502@localhost.localdomain>
 <20071010095954.79c39a73.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0710101324230.6071@localhost.localdomain>
 <20071010183858.GA2270@uranus.ravnborg.org> <20071010202128.GG2730@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, Matthew Wilcox wrote:

> On Wed, Oct 10, 2007 at 08:38:58PM +0200, Sam Ravnborg wrote:
> > parisc arch Makefile needs some love and care...
>
> None of your comments actually address the thing that he was having
> problems with:
>
> ifneq ($(call cc-ifversion, -lt, 0303, "bad"),)
> $(error Sorry, GCC v3.3 or above is required.)
> endif
>
> Now, compiler.h has some checks like:
>
> #elif __GNUC__ == 3 && __GNUC_MINOR__ >= 2
> # include <linux/compiler-gcc3.h>
> #else
> # error Sorry, your compiler is too old/not recognized.
> #endif
>
> But it doesn't permit us to rule out gcc 3.3 unless we patch compiler.h.
> There's no asm/compiler.h, for example.

hmmmm ... actually, there is ... sort of:

$ find include -name compiler.h
include/asm-alpha/compiler.h
include/asm-mips/compiler.h
include/linux/compiler.h

$ grep -r "asm/compiler.h" *
arch/mips/kernel/cpu-bugs64.c:#include <asm/compiler.h>
arch/mips/kernel/time.c:#include <asm/compiler.h>
arch/mips/au1000/common/time.c:#include <asm/compiler.h>
arch/alpha/kernel/sys_sio.c:#include <asm/compiler.h>
include/asm-alpha/mmu_context.h:#include <asm/compiler.h>
include/asm-alpha/core_marvel.h:#include <asm/compiler.h>
include/asm-alpha/core_t2.h:#include <asm/compiler.h>
... lots more alpha stuff ...

  so there does appear to be some precedent for an asm/compiler.h.
for better or worse.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
