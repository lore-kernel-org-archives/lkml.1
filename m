Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbXLVO3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbXLVO3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 09:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXLVO3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 09:29:38 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:34877 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbXLVO3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 09:29:37 -0500
Date: Sat, 22 Dec 2007 15:31:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       trivial@kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 1/3] Remove unused dependency
Message-ID: <20071222143128.GA24659@uranus.ravnborg.org>
References: <1198306931-5258-1-git-send-email-joe@perches.com> <1198306931-5258-2-git-send-email-joe@perches.com> <20071222083323.GA22653@uranus.ravnborg.org> <1198313412.4895.24.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198313412.4895.24.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 12:50:12AM -0800, Joe Perches wrote:
> On Sat, 2007-12-22 at 09:33 +0100, Sam Ravnborg wrote:
> > arch/alpha/boot/mixc.c have:
> > #include "../../../lib/inflate.c"
> 
> Right. thanks.  Sorry for the noise.

It was the removal of the file I objected against - not thremoval of the
dependency.
kbuild will find the dpendency as expressed in the Makefile
all by itself.

> 
> Should the makefiles for the sources that include lib/inflate.c
> have a dependency similar to arm and alpha?
> 
> With:
> arch/alpha/boot/misc.c
> arch/arm/boot/compressed/misc.c
> 
> Without:
> arch/cris/arch-v10/boot/compressed/misc.c
> arch/cris/arch-v32/boot/compressed/misc.c
> arch/h8300/boot/compressed/misc.c
> arch/m32r/boot/compressed/misc.c
> arch/sh/boot/compressed/misc.c
> arch/sh64/boot/compressed/misc.c
> arch/x86/boot/compressed/misc_32.c
> arch/x86/boot/compressed/misc_64.c
> init/do_mounts_rd.c
> init/initramfs.c
>
I looked at how inflate was used:
 
$ grep inflate */boot/Makefile
alpha/boot/Makefile:$(obj)/misc.o: lib/inflate.c
=> redundandt dependency, can be deleted

powerpc/boot/Makefile:zlib       := inffast.c inflate.c inftrees.c
powerpc/boot/Makefile:zlibheader := inffast.h inffixed.h inflate.h inftrees.h infutil.h
powerpc/boot/Makefile:$(addprefix $(obj)/,$(zlib)): $(obj)/%: $(srctree)/lib/zlib_inflate/%
powerpc/boot/Makefile:$(addprefix $(obj)/,$(zlibheader)): $(obj)/%: $(srctree)/lib/zlib_inflate/%
=> I could not see why powerpc had to do so much special magic to
get a working zlib - other archs has less troubles...

Did not llok at all archs but some other had funny stuff to use inflate
and friends too. A cleanup of all this is needed.

	Sam
