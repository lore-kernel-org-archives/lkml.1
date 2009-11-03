Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbZKCN3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbZKCN3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZKCN3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:29:52 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57071 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZKCN3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:29:52 -0500
Date: Tue, 3 Nov 2009 22:29:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 04/10] module: make MODULE_SYMBOL_PREFIX into a CONFIG option
Message-ID: <20091103132935.GA12841@linux-sh.org>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-5-git-send-email-alan-jenkins@tuffmail.co.uk> <8bd0f97a0911030219y685a1dafy2a8e066d7132ac45@mail.gmail.com> <4AF01F18.8040807@tuffmail.co.uk> <8bd0f97a0911030430s3ecb2467hc52ebac658c39ccd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0911030430s3ecb2467hc52ebac658c39ccd@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 07:30:20AM -0500, Mike Frysinger wrote:
> On Tue, Nov 3, 2009 at 07:16, Alan Jenkins wrote:
> > Mike Frysinger wrote:
> >> On Tue, Nov 3, 2009 at 05:06, Alan Jenkins wrote:
> >>> The next commit will require the use of MODULE_SYMBOL_PREFIX in
> >>> .tmp_exports-asm.S. ??Currently it is mixed in with C structure
> >>> definitions in "asm/module.h". ??Move the definition of this arch option
> >>> into Kconfig, so it can be easily accessed by any code.
> >>>
> >>> This also lets modpost.c use the same definition. ??Previously modpost
> >>> relied on a hardcoded list of architectures in mk_elfconfig.c.
> >>
> >> this should also let us push VMLINUX_SYMBOL() out of
> >> arch/*/kernel/vmlinux.lds.S and into asm-generic/vmlinux.lds.h ...
> >
> > I don't think that's possible.
> >
> > ?? #define VMLINUX_SYMBOL(_sym_) _##_sym_
> >
> > I don't know any "unstringify" operation. ??So I can't convert a string value
> > of CONFIG_SYMBOL_PREFIX to the unquoted underscore we neeed for this macro.
> > ??The same applies for the SYM() macro I use.
> 
> let the build system do the unstringify operation.
> qstrip = $(strip $(subst ",,$(1)))
> CPPFLAGS_vmlinux.lds += -DVMLINUX_SYMBOL_PREFIX=$(call
> qstrip,CONFIG_SYMBOL_PREFIX)
> 
> > If we positively want to keep the generality, I guess I should put
> > MODULE_SYMBOL_PREFIX in a header file of it's own. ??The disadvantage is that
> > it makes it inaccessible to host programs again, like modpost (which
> > currently hardcodes the list of affected architectures in mk_elfconfig.c).
> 
> having it in the arch Kconfig removes any and all possible
> limitations, and it keeps the cruft out of the common init/Kconfig and
> in the arch-specific Kconfig, and avoids a dead symbol
> (HAVE_SYMBOL_PREFIX)

Having it in the Kconfig also makes it a nuisance for platforms that can
use -elf and -linux toolchains for the same tree for different platforms.
It would be nice to have this supported in such a way that we can just
set a flag from the Makefile and have a compiler test that determines
whether it is necessary or not.
