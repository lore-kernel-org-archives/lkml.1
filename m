Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbYHKPFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbYHKPFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYHKPFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:05:41 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48089 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYHKPFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:05:40 -0400
Date: Mon, 11 Aug 2008 18:03:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, David Woodhouse <dwmw2@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: RFC: killing ksyms.c
Message-ID: <20080811150358.GC3338@cs181140183.pp.htv.fi>
References: <200808111606.44103.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200808111606.44103.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 04:06:43PM +0200, Arnd Bergmann wrote:
> I saw this conversation on IRC when I came back to my screen, and
> managed to dig out an older patch of mine:
> 
> [19:03:13] <willy> at some point we really need to forbid that
> [19:03:28] <willy> bit hard at this point with things like memcpy()
> [19:04:36] <willy> could do it with a script of some kind and
>            either a whitelist of filenames (arch/*/kernel/ksyms.c
>            can export anything) or of functions (anywhere can
>            EXPORT_SYMBOL(memcpy)).
> [Sun Aug 10 2008] [19:07:35] <viro> I suspect that we really want
>            to teach *.S how to do exports
> [Sun Aug 10 2008] [19:07:58] <viro> and kill ksyms.c
> [Sun Aug 10 2008] [19:12:47] <dwmw2_gone> if we do the -fwhole-program
>            --combine thing we'll make it hard anyway
> 
> I compile-tested this on powerpc, 32 and 64 bit, and it should be usable as
> an example for other architectures.
> The idea is to provide an EXPORT_SYMBOL macro for assembly that
> behaves in the same way as the C version, and then export every
> symbol from the file that defines it.
>...

On some architectures the kernel is linked with libgcc and symbols from 
libgcc are EXPORT_SYMBOL'ed.

> 	Arnd <><

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

