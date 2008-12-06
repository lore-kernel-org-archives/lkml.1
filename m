Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYLFUnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYLFUnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 15:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYLFUm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 15:42:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43859 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYLFUm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 15:42:57 -0500
Date: Sat, 6 Dec 2008 20:42:17 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line() (take II)
Message-ID: <20081206204217.GA10788@flint.arm.linux.org.uk>
References: <200812012326.03151.rusty@rustcorp.com.au> <200812031350.46794.rusty@rustcorp.com.au> <200812032121.mB3LL13L021817@agluck-lia64.sc.intel.com> <200812041128.34159.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812041128.34159.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 11:28:32AM +1030, Rusty Russell wrote:
> On Thursday 04 December 2008 05:07:25 Luck, Tony wrote:
> > > I pulled your git tree.  All my test configs build cleanly
> > > for ia64 ... but sadly the first kernel I tested (generic_defconfig)
> > > doesn't boot (no console output at all).
> > >
> > > I'll see if I can figure out what is going on.
> >
> > Aha.
> 
> OK, both appended to git tree.  
> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-boot-params.git
> 
> If noone else complains, I'll fold the fix and ask Stephen to take the tree 
> for linux-next.

One commit in there looks rather dirty:

| commit c3f789e6270db86717ef578fa2383ca59b134108
| Author: Tony Luck <tony.luck@intel.com>
| Date:   Thu Dec 4 11:06:18 2008 +1030
| 
|     Aha.  You are now calling machvec_init_from_cmdline() too early (before
|     efi_init() and io_port_init()) ... so we croak accessing things
|     that have not been set up.  Naive fix is to just move them from
|     setup_arch() to arch_get_boot_command_line().  I can't see how to
|     handle this more cleanly given that you do the rest of the
|     command line parsing before calling setup_arch().
| 
|     With the addition of this patch ia64 bits are
| 
|     Acked-by: Tony Luck <tony.luck@intel.com>

I'm wondering whether the ia64 bits are now green, yellow or maybe they're
taking some terminal exercise by jumping off the cliff like lemmings.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
