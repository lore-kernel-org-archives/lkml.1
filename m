Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZFFXYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZFFXYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 19:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZFFXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 19:24:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50267 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbZFFXY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 19:24:29 -0400
Date: Sun, 7 Jun 2009 00:24:15 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] headers_check fixes
Message-ID: <20090606232415.GB4813@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam> <1244292857.2473.4.camel@ht.satnam> <20090606130210.GA9343@flint.arm.linux.org.uk> <1244299177.2473.21.camel@ht.satnam> <20090606214711.GA4813@flint.arm.linux.org.uk> <20090606221223.GA20945@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090606221223.GA20945@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 12:12:23AM +0200, Sam Ravnborg wrote:
> Hi Russell.
> 
> On Sat, Jun 06, 2009 at 10:47:11PM +0100, Russell King wrote:
> > Right, below is a patch to unifdef.c which allows it to work out if
> > an #if expression always evaluates true or false for symbols which
> > are being undefined/always defined.
> > 
> > The patch is slightly more complicated than I'd hoped because unifdef
> > needs to see lines fully evaluated - doing otherwise causes it to
> > mark the line as "dirty" and copy it over no matter what.
> > 
> > What follows this email is the diff of what effect it has on the
> > headers copied over - as can be seen, all resulting changes are of
> > net benefit.
> 
> You beat me on this one.
> I was looking into supportting short_circuit_and/short_circuit_or too.
> Your patch looks better - thanks!
> 
> >From my very limited testing this patch suffers from a problem I faced too.
> When you run it on for example hwcap.h or my sample file:
> #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
>   int a;
> #endif
> 
> then the return code of the program is 1 so we do not copy the file.

That's correct.  If unifdef removes any lines, the exit code is 1, not
zero.  This happens with the unmodified unifdef as well, so I'm not
changing that behaviour.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
