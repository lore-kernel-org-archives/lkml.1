Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbZI1PKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbZI1PKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZI1PKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:10:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:34159 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZI1PKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:10:34 -0400
Subject: Re: Linux 2.6.32-rc1 compile error
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Wolfgang Erig <Wolfgang.Erig@gmx.de>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090928143451.GA22949@erig.dyndns.org>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	 <20090928143451.GA22949@erig.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Sep 2009 20:40:09 +0530
Message-Id: <1254150609.16585.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfgang,

Can you please check, following patch fix your problem. (This is
untested)

On Mon, 2009-09-28 at 16:34 +0200, Wolfgang Erig wrote:
> ------------ snip ------------
>   CC      kernel/time/tick-oneshot.o
>   CC      kernel/time/tick-sched.o
>   LD      kernel/time/built-in.o
>   CC      kernel/futex.o
>   CC      kernel/rtmutex.o
>   CC      kernel/dma.o
>   CC      kernel/smp.o
>   CC      kernel/spinlock.o
>   CC      kernel/uid16.o
>   CC      kernel/module.o
> kernel/module.c:1995: warning: type defaults to ‘int’ in declaration of ‘Elf_Hdr’
> kernel/module.c:1995: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
> kernel/module.c: In function ‘load_module’:
> kernel/module.c:2203: error: ‘strmap’ undeclared (first use in this function)
> kernel/module.c:2203: error: (Each undeclared identifier is reported only once
> kernel/module.c:2203: error: for each function it appears in.)
> kernel/module.c:2239: error: ‘symoffs’ undeclared (first use in this function)
> kernel/module.c:2239: error: implicit declaration of function ‘layout_symtab’
> kernel/module.c:2240: error: ‘stroffs’ undeclared (first use in this function)
> make[1]: *** [kernel/module.o] Fehler 1
> make: *** [kernel] Fehler 2
> 
> seemed to be a strange .config, which is attached.
> 

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Mon, 28 Sep 2009 20:14:37 +0530
Subject: [PATCH] module: fix compilation errors

Fix following compilation errors :
  kernel/module.c:1995: warning: type defaults to ‘int’ in declaration of ‘Elf_Hdr’
  kernel/module.c:1995: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
  kernel/module.c: In function ‘load_module’:
  kernel/module.c:2203: error: ‘strmap’ undeclared (first use in this function)
  kernel/module.c:2203: error: (Each undeclared identifier is reported only once
  kernel/module.c:2203: error: for each function it appears in.)
  kernel/module.c:2239: error: ‘symoffs’ undeclared (first use in this function)
  kernel/module.c:2239: error: implicit declaration of function ‘layout_symtab’
  kernel/module.c:2240: error: ‘stroffs’ undeclared (first use in this function)
  make[1]: *** [kernel/module.o] Fehler 1
  make: *** [kernel] Fehler 2

Reported-by: Wolfgang Erig <Wolfgang.Erig@gmx.de>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 5a29397..0034621 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1992,7 +1992,7 @@ static inline unsigned long layout_symtab(struct module *mod,
 					  Elf_Shdr *sechdrs,
 					  unsigned int symindex,
 					  unsigned int strindex,
-					  const Elf_Hdr *hdr,
+				   	  const Elf_Ehdr *hdr,
 					  const char *secstrings,
 					  unsigned long *pstroffs,
 					  unsigned long *strmap)
@@ -2081,9 +2081,8 @@ static noinline struct module *load_module(void __user *umod,
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
-#ifdef CONFIG_KALLSYMS
 	unsigned long symoffs, stroffs, *strmap;
-#endif
+
 	mm_segment_t old_fs;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
-- 
1.6.0.6



