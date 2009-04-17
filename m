Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbZDQNU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbZDQNU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbZDQNUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:20:15 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:52151 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754812AbZDQNUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:20:14 -0400
Date: Fri, 17 Apr 2009 15:20:10 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Doug Chapman <doug.chapman@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       squashfs-devel@lists.sourceforge.net
Subject: Re: [PATCH] squashfs broken when pageszie > blocksize
In-Reply-To: <49E3C209.5030705@lougher.demon.co.uk>
Message-ID: <alpine.LRH.2.00.0904171518040.28718@vixen.sonytel.be>
References: <1239652637.1127.10.camel@oberon> <49E3C209.5030705@lougher.demon.co.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009, Phillip Lougher wrote:
> Doug Chapman wrote:
> > Squashfs is broken on any system where the pageszie is larger than either
> > the block size of the squashfs image or larger than the metadata size
> > (8192).
> > This is easily fixed by ensuring cache->pages is always > 0.
> > 
> > Signed-off-by: Doug Chapman <doug.chapman@hp.com>
> > Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
> 
> Good catch.  BTW what is the page size on ia64?

A quick grep on PAGE_{SIZE,SHIFT} in asm/page.h shows:

ia64, mips, sh: 4/8/16/64 KiB
parisc: 4/16/64 KiB
alpha, cris: 8 KiB
powerpc: 4/16/64/256 KiB

> For completeness there should also be a mount time check that
> the block size used in the Squashfs filesystem is at least as
> large as the pagesize.  This doesn't matter for metadata
> (size 8192), but does matter for data blocks, because Squashfs
> read_page doesn't handle block_size < pagesize.
> 
> Squashfs read_page used to handle block_size < pagesize but I
> removed that code when I removed filesystem support for block_sizes
> < 4K.  If ia64 users (or any other architecture with larger than
> 4K pagesizes) want to use Squashfs filesystems with blocksizes less
> than their pagesize, then I can put that code back in.

So I think it's a good idea to resurrect that code...

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
