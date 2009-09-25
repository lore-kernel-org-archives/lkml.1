Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZIYHyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZIYHyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZIYHyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:54:20 -0400
Received: from ozlabs.org ([203.10.76.45]:52159 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbZIYHyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:54:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] module: Fix up CONFIG_KALLSYMS=n build.
Date: Fri, 25 Sep 2009 17:24:20 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20090925034557.GA12810@linux-sh.org> <2375c9f90909242349u7daa7b1epae52fb0da6c92b7d@mail.gmail.com>
In-Reply-To: <2375c9f90909242349u7daa7b1epae52fb0da6c92b7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909251724.21416.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 04:19:22 pm Américo Wang wrote:
> On Fri, Sep 25, 2009 at 11:45 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> > Starting from commit 4a4962263f07d14660849ec134ee42b63e95ea9a
> > "reduce symbol table for loaded modules (v2)", the kernel/module.c build
> > is broken with CONFIG_KALLSYMS disabled.
> >
> >  CC      kernel/module.o
> > kernel/module.c:1995: warning: type defaults to 'int' in declaration of 'Elf_Hdr'
> > kernel/module.c:1995: error: expected ';', ',' or ')' before '*' token
> > kernel/module.c: In function 'load_module':
> > kernel/module.c:2203: error: 'strmap' undeclared (first use in this function)
> > kernel/module.c:2203: error: (Each undeclared identifier is reported only once
> > kernel/module.c:2203: error: for each function it appears in.)
> > kernel/module.c:2239: error: 'symoffs' undeclared (first use in this function)
> > kernel/module.c:2239: error: implicit declaration of function 'layout_symtab'
> > kernel/module.c:2240: error: 'stroffs' undeclared (first use in this function)
> > make[1]: *** [kernel/module.o] Error 1
> > make: *** [kernel/module.o] Error 2
> >
> > There are three different issues:
> >
> >    - layout_symtab() takes a const Elf_Ehdr
> >
> >    - layout_symtab() needs to return a value
> >
> >    - symoffs/stroffs/strmap are referenced by the load_module() code
> >      despite being ifdefed out, which seems unnecessary given the noop
> >      behaviour of layout_symtab()/add_kallsyms() in the case of
> >      CONFIG_KALLSYMS=n.
> >
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > Cc: Jan Beulich <jbeulich@novell.com>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> 
> Indeed.
> 
> Acked-by: WANG Cong <amwang@redhat.com>

And this completes the set:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks Paul!

Cheers,
Rusty.
