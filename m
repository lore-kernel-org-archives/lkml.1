Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbXICMhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbXICMhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXICMgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:36:52 -0400
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:44700 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbXICMgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:36:51 -0400
Message-ID: <46DBFFB0.3080204@l4x.org>
Date: Mon, 03 Sep 2007 14:36:00 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jeff Dike <jdike@linux.intel.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc5 regression: uml on x86_64 compile error
References: <20070903104619.GR16016@stusta.de>
In-Reply-To: <20070903104619.GR16016@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Commit d1254b12c93e1e586137a2ffef71fd33cf273f35 causes the following 
> compile error (found at [1]):
> 
> <--  snip  -->
> 
> ...
> CC      fs/binfmt_elf.o
> In file included from fs/binfmt_elf.c:30:
> include/linux/elfcore.h: In function ‘elf_core_copy_regs’:
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
> make[2]: *** [fs/binfmt_elf.o] Error 1

That may actually be a toolchain/build system problem. It's a i486 chroot in
which the compile happens. Host is x86_64 though as reported by uname. And I
use gcc 4.0 as HOSTCC, while CC is gcc 4.1.2.

# gcc -v
Using built-in specs.
Target: i486-linux-gnu
Configured with: ../src/configure -v 
--enable-languages=c,c++,fortran,objc,obj-c++,treelang --prefix=/usr 
--enable-shared --with-system-zlib --libexecdir=/usr/lib 
--without-included-gettext --enable-threads=posix --enable-nls 
--program-suffix=-4.1 --enable-__cxa_atexit --enable-clocale=gnu 
--enable-libstdcxx-debug --enable-mpfr --with-tune=i686 
--enable-checking=release i486-linux-gnu
Thread model: posix
gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
# uname -m
x86_64


Jan
