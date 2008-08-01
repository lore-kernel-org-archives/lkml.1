Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbYHAUli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbYHAUli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbYHAUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:41:27 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:48610 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbYHAUl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:41:26 -0400
Date: Fri, 1 Aug 2008 22:41:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: m68k build failure
Message-ID: <20080801204157.GA12390@uranus.ravnborg.org>
References: <20080730175233.02dbf021.sfr@canb.auug.org.au> <20080730.010234.193703201.davem@davemloft.net> <20080730084935.GA18545@uranus.ravnborg.org> <20080801153710.815bbb74.sfr@canb.auug.org.au> <Pine.LNX.4.64.0808011551120.30950@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808011551120.30950@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 03:52:22PM +0200, Geert Uytterhoeven wrote:
> 	Hi Stephen,
> 
> On Fri, 1 Aug 2008, Stephen Rothwell wrote:
> > On Wed, 30 Jul 2008 10:49:35 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> > >
> > > Full list of relevant files:
> > > include/asm-m68k/contregs.h:#include <asm-sparc/contregs.h>
> > > include/asm-m68k/fbio.h:#include <asm-sparc/fbio.h>
> > > include/asm-m68k/idprom.h:#include <asm-sparc/idprom.h>
> > 
> > I applied the following patch to today's linux-next.
> 
> Thanks!
> 
> BTW, is there a (good) way to have this without duplicating those header files?

The only solution I can come up with right now is:

Makefile:
ccflags-y += -Iarch/sparc/include

foo.c:
#include <asm/fbio.h>

Disadvantage is that we loose the explicit documentation that this
is header files from another architecture.
So we should at least add a comment saying this.

And the above would not work if the file has same filename,
but then that is not a likely situation either.

	Sam
