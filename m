Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZKCNrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZKCNrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZKCNrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:47:08 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50131 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZKCNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:47:07 -0500
Date: Tue, 3 Nov 2009 22:46:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 04/10] module: make MODULE_SYMBOL_PREFIX into a CONFIG option
Message-ID: <20091103134652.GB12841@linux-sh.org>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-5-git-send-email-alan-jenkins@tuffmail.co.uk> <8bd0f97a0911030219y685a1dafy2a8e066d7132ac45@mail.gmail.com> <4AF01F18.8040807@tuffmail.co.uk> <8bd0f97a0911030430s3ecb2467hc52ebac658c39ccd@mail.gmail.com> <20091103132935.GA12841@linux-sh.org> <8bd0f97a0911030539s582598d6k2f78693bbfa559b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0911030539s582598d6k2f78693bbfa559b0@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 08:39:29AM -0500, Mike Frysinger wrote:
> On Tue, Nov 3, 2009 at 08:29, Paul Mundt wrote:
> > Having it in the Kconfig also makes it a nuisance for platforms that can
> > use -elf and -linux toolchains for the same tree for different platforms.
> > It would be nice to have this supported in such a way that we can just
> > set a flag from the Makefile and have a compiler test that determines
> > whether it is necessary or not.
> 
> what arch is this an issue for ?  the only symbol prefixed arches are
> Blackfin and H8300, and they dont provide toolchains that omit the
> prefix.
> 
No, those are the only symbol prefixed platforms enabled in the kernel at
present because neither one ships different toolchains.

The symbol prefixing itself is more an artifact of a -elf target
contrasted with a -linux one than anything "platform" specific. Thus, any
nommu platform using a bare metal or -elf toolchain can easily be used
for building the kernel if this can be supported in a clean way. As such,
a config option is not useful.

> trying to enable symbol prefix support dynamically based on the
> toolchain is a bad idea and pretty fragile.  the arch-specific
> assembly code would have to be all rewritten to wrap all C-visible
> symbols with a macro like VMLINUX_SYMBOL().
> 
There is nothing fragile about it, symbols are either prefixed or they
aren't. The common case for things like the syscall table obiously have
to be wrapped, but so what? C_SYMBOL_PREFIX() used to be the norm back in
the day, so it obiously worked well enough for the common case.

> i say let anyone who actually has such a system and wants to do such a
> crazy ass thing put together a working arch first before we worry
> about it.  the current code doesnt preclude dynamic hooking anyways
> (manually adding -DCONFIG_xxx to CPPFLAGS).

You talk about fragile bad ideas and then throw out defining Kconfig
variables from Makefiles? This simply has no place in the Kconfig space,
as it is now and always has been a toolchain property, not an
architectural/platform one.

The other thing you seem to have ignored is that pretty much everyone has
such a system, it's only crippled platforms like blackfin and h8300 that
don't support toolchains without the prefix.
