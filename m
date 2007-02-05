Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbXBENe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbXBENe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932445AbXBENe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:34:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55006 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbXBENe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:34:56 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070205084523.GA21858@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 05 Feb 2007 13:34:48 +0000
Message-Id: <1170682488.29759.795.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 09:45 +0100, Ingo Molnar wrote:
>     LD      vmlinux
>   drivers/built-in.o: In function `cafe_nand_remove':
>   cafe.c:(.text+0x19277a): undefined reference to `nand_release'
>   drivers/built-in.o: In function `cafe_nand_cmdfunc':
>   cafe.c:(.text+0x193036): undefined reference to `nand_wait_ready'
>   drivers/built-in.o: In function `cafe_nand_probe':
>   cafe.c:(.text+0x19359e): undefined reference to `nand_scan_ident'
>   cafe.c:(.text+0x193658): undefined reference to `nand_scan_tail'
>   distcc[1703] ERROR: compile (null) on localhost failed
>   make: *** [vmlinux] Error 1

> so here's the fix for the 3 affected MTD drivers: DOC2000, DOC2001 and 
> DOC2001PLUS.

Er, what?

For a start, the affected driver is the new CAFÉ NAND controller, not
the old versions of the DiskOnChip drivers which don't even use the
generic NAND code anyway.

Secondly, please don't _ever_ use 'select'. If ESR's Aunt Tillie
_really_ needs to configure a new kernel for her $100 laptop, but she
lacks the wit to realise that she might need to ask for NAND flash
support if she wants to be able to enable the NAND flash controller,
then I really couldn't care less.

We now have a fairly arbitrary mix of 'select' and proper dependencies
throughout the kernel, and it's getting harder and harder to configure a
minimal kernel by turning off subsystems we don't want, because
something 'helpfully' turns then back on again.

We could do with some coherent guidelines on _when_ to use 'select' and
when to use normal dependencies. Personally, I'm quite happy to tell
Aunt Tillie to go screw herself and for that guidance to be to _never_
use 'select'.

The correct fix is at
http://git.infradead.org/?p=mtd-2.6.git;a=commitdiff;h=aa8f1278553c554f1fb3fd6fb0987dd547c7d7cf;hp=4285431fb658263e98942ce2320b0b26eddcc06d

-- 
dwmw2

