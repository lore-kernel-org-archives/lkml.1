Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZKMPXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZKMPXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZKMPXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:23:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34968 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZKMPXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:23:50 -0500
Date: Fri, 13 Nov 2009 15:21:55 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Martin Michlmayr <tbm@cyrius.com>, sam@ravnborg.org,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       akpm@linux-foundation.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] Add support for LZO-compressed kernels for ARM
Message-ID: <20091113152155.GC27752@flint.arm.linux.org.uk>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com> <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com> <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com> <20091112125938.GA19698@deprecation.cyrius.com> <20091113142917.GA12149@Chamillionaire.breakpoint.cc> <20091113145008.GN13296@deprecation.cyrius.com> <20091113145349.GA2201@pc-ran3241.res.insa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113145349.GA2201@pc-ran3241.res.insa>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 03:54:00PM +0100, Albin Tonnerre wrote:
> On Fri, 13 Nov 2009 14:50 +0000, Martin Michlmayr wrote :
> > * Sebastian Andrzej Siewior <sebastian@breakpoint.cc> [2009-11-13 15:29]:
> > > > # For __aeabi_uidivmod
> > > >-lib1funcs = $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.o
> > > >+lib1funcs = arch/$(SRCARCH)/lib/lib1funcs.o
> > > 
> > > +lib1funcs = $(obj)/arch/$(SRCARCH)/lib/lib1funcs.o
> > > 
> > > This is untested but it should refer to obj because you break out of
> > > tree builds (O=) if you don't :)
> > 
> > With this I get:
> >  make[4]: *** No rule to make target `arch/arm/boot/compressed/arch/arm/lib/lib1funcs.o', needed by `arch/arm/boot/compressed/vmlinux'.  Stop.
> 
> Sam: what's the correct way to solve this issue?

We already have something similar - with the font support.  Just do this:

lib1funcs = $(obj)/lib1funcs.o

$(obj)/lib1funcs.S: $(srctree)/arch/arm/lib/lib1funcs.S FORCE
        $(call cmd,shipped)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
