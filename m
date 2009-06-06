Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZFFNmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZFFNmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 09:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZFFNmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 09:42:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59118 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZFFNmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 09:42:02 -0400
Date: Sat, 6 Jun 2009 14:41:19 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] headers_check fixes
Message-ID: <20090606134119.GB9343@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam> <1244292857.2473.4.camel@ht.satnam> <20090606130210.GA9343@flint.arm.linux.org.uk> <1244295277.2473.15.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244295277.2473.15.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 07:04:37PM +0530, Jaswinder Singh Rajput wrote:
> On Sat, 2009-06-06 at 14:02 +0100, Russell King wrote:
> > On Sat, Jun 06, 2009 at 06:24:17PM +0530, Jaswinder Singh Rajput wrote:
> > > Linus,
> > > 
> > > Please pull headers_check fixes:
> > > 
> > > The following changes since commit 064e38aaded5269e573ac1c765284fd65c8ebd13:
> > >   Linus Torvalds (1):
> > >         Merge git://git.kernel.org/.../mason/btrfs-unstable
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git master
> > > 
> > > Jaswinder Singh Rajput (6):
> > >       headers_check fix: arm, hwcap.h
> > 
> > So inspite of NAKing this patch you send it anyway.
> > 
> 
> Earlier it was already like this, because of Catalin Marinas
> fault (commit f884b1cf578e0) and your ignorance you converted :
> 
>  #ifdef __KERNEL__
>  #ifndef __ASSEMBLY__
> 
> to :
> 
>  #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
> 
> I am just trying to rectify your mistake that __KERNEL__ should not be
> used with other defines to easily export headers to userspace. Whole
> kernel header files are following this protocol. Sam, Arnd and me are
> trying to convince you. Why you need an exception ?

You are not listening.

I believe that there is a much better way to fix this, and that is to
fix the tools.  Having looked at unifdef, I believe that the fix is
almost trivial in nature.

With fixed tools, we don't have to fuck around writing a special dialect
of C to work around their short comings - a dialect which isn't obvious.

What we actually have here is a small number of people who've suddenly
decided that a perfectly good bit of C code is no longer good enough for
their purposes, and are now requiring things to be written to match their
own rules.

Let's fix the tools and then we don't have to ever worry about this
problem again, or require people to write their C code in special ways.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
