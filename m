Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbYGUJqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbYGUJqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYGUJqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:46:11 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:43894 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbYGUJqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:46:10 -0400
Date: Mon, 21 Jul 2008 12:46:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Sam Ravnborg <sam@ravnborg.org>,
       David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 21
Message-ID: <20080721094605.GA22914@cs181140183.pp.htv.fi>
References: <20080721181725.9269fac4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080721181725.9269fac4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 06:17:25PM +1000, Stephen Rothwell wrote:
>...
> This tree fails to build for ARCH=sparc (i.e. 32bit) with a 64bit gcc
> v3.4.5 - it tries to use the 64bit header files.  This may be an artifact
> of one of my merge fixups, but I don't actually think so.
>...

I can reproduce it, and it's not related to anything you did.

The failing command is:

<--  snip  -->

...
  sparc64-linux-gcc -E -Wp,-MD,arch/sparc/kernel/.vmlinux.lds.d  -nostdinc -isystem /usr/local/DIR/gcc-sparc64-4.3.1/lib/gcc/sparc64-linux/4.3.1/include -D__KERNEL__ -I/TMP/git/sparc-2.6/include -Iinclude -I/TMP/git/sparc-2.6/include2 -Iinclude2  -I/TMP/git/sparc-2.6/include -include include/linux/autoconf.h -P -C -Usparc -D__ASSEMBLY__ -o arch/sparc/kernel/vmlinux.lds /TMP/git/sparc-2.6/arch/sparc/kernel/vmlinux.lds.S
In file included from include2/asm/page.h:4,
                 from /TMP/git/sparc-2.6/arch/sparc/kernel/vmlinux.lds.S:4:
/TMP/git/sparc-2.6/include/asm-sparc/page_64.h:11:2: error: #error No page size specified in kernel configuration
make[2]: *** [arch/sparc/kernel/vmlinux.lds] Error 1

<--  snip  -->

David, Sam, can you look at this?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

