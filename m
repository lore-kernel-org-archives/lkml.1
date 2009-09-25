Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZIYIOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZIYIOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZIYIOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:14:06 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35702 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZIYIOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:14:04 -0400
Date: Fri, 25 Sep 2009 10:14:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Am?rico Wang <xiyou.wangcong@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: Fix up CONFIG_KALLSYMS=n build.
Message-ID: <20090925081403.GA2736@merkur.ravnborg.org>
References: <20090925034557.GA12810@linux-sh.org> <2375c9f90909242349u7daa7b1epae52fb0da6c92b7d@mail.gmail.com> <200909251724.21416.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200909251724.21416.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 05:24:20PM +0930, Rusty Russell wrote:
> On Fri, 25 Sep 2009 04:19:22 pm Américo Wang wrote:
> > On Fri, Sep 25, 2009 at 11:45 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> > > Starting from commit 4a4962263f07d14660849ec134ee42b63e95ea9a
> > > "reduce symbol table for loaded modules (v2)", the kernel/module.c build
> > > is broken with CONFIG_KALLSYMS disabled.
> > >
> > >  CC      kernel/module.o
> > > kernel/module.c:1995: warning: type defaults to 'int' in declaration of 'Elf_Hdr'
> > > kernel/module.c:1995: error: expected ';', ',' or ')' before '*' token
> > > kernel/module.c: In function 'load_module':
> > > kernel/module.c:2203: error: 'strmap' undeclared (first use in this function)
> > > kernel/module.c:2203: error: (Each undeclared identifier is reported only once
> > > kernel/module.c:2203: error: for each function it appears in.)
> > > kernel/module.c:2239: error: 'symoffs' undeclared (first use in this function)
> > > kernel/module.c:2239: error: implicit declaration of function 'layout_symtab'
> > > kernel/module.c:2240: error: 'stroffs' undeclared (first use in this function)
> > > make[1]: *** [kernel/module.o] Error 1
> > > make: *** [kernel/module.o] Error 2
> > >
> > > There are three different issues:
> > >
> > >    - layout_symtab() takes a const Elf_Ehdr
> > >
> > >    - layout_symtab() needs to return a value
> > >
> > >    - symoffs/stroffs/strmap are referenced by the load_module() code
> > >      despite being ifdefed out, which seems unnecessary given the noop
> > >      behaviour of layout_symtab()/add_kallsyms() in the case of
> > >      CONFIG_KALLSYMS=n.
> > >
> > > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > > Cc: Jan Beulich <jbeulich@novell.com>
> > > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > Indeed.
> > 
> > Acked-by: WANG Cong <amwang@redhat.com>
> 
> And this completes the set:
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Hmm, I expected you to take this patch and forward to Linus?
In which case I had expected to see a "S-o-b".

	Sam
