Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbYLJMpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbYLJMpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYLJMpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:45:08 -0500
Received: from ozlabs.org ([203.10.76.45]:41901 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbYLJMpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:45:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kyle McMartin <kyle@infradead.org>
Subject: Re: setup_arch/arch_get_boot_command_line changes
Date: Wed, 10 Dec 2008 23:14:59 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-parisc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200812100850.26728.rusty@rustcorp.com.au> <20081209225931.GA7015@bombadil.infradead.org>
In-Reply-To: <20081209225931.GA7015@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812102315.01416.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2008 09:29:31 Kyle McMartin wrote:
> On Wed, Dec 10, 2008 at 08:50:24AM +1030, Rusty Russell wrote:
> > Rusty Russell (10):
> > <snip>
> >       param: move banner printing to top of start_kernel.    
> > 
> 
> Will this not run afoul of lockdep since it will be attempting to take
> locks before lockdep has initialized?

Hmm, works for me here.  But then, i386_start_kernel -> reserve_ebda_region
->printk already, so that banner is *still* not first line.

> (as an aside, it would be nice if it came after setup_arch, since on
> some horrible platforms, printk_time needs the fpu turned on for
> (integer) division, but there's no arch hook before the first printk, so
> one needs to hijack the start_kernel entrypoint...)

That won't help much, since a failed kernel parameter parse will also call
printk.  I don't think it's sane to call start_kernel without the
ability to do integer division!

Rusty.
