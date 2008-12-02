Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYLBJjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYLBJjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 04:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYLBJjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 04:39:12 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:54580 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYLBJjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 04:39:10 -0500
Date: Tue, 2 Dec 2008 10:23:30 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line()
Message-ID: <20081202102330.7c3215a8@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200812021243.38862.rusty@rustcorp.com.au>
References: <200812012326.03151.rusty@rustcorp.com.au>
	<20081201131807.GD28971@flint.arm.linux.org.uk>
	<200812021243.38862.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Dec 2008 09:23:41.0888 (UTC) FILETIME=[AAAD4C00:01C9545F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Monday 01 December 2008 23:48:07 Russell King wrote:
> > So there's quite a bit which needs to be done to get at the command line.
> > Basically, what's required is:
> >
> > - convert param struct to tag list
> > - if no tag list, use default tag list
> > - run machine specific fixups which may set memory layout
> > - if memory layout has been set, kill off any memory atags to prevent it
> >   being overwritten
> > - parse all atags which includes setting the command line if such a tag
> >   is found
> >
> > Then, and only then can you be sure that you have the right command line.  
> 
>    Thanks for the clue donation.  I've read the code harder now.  Tricky.

I think avr32 might need something similar as it also gets the command
line from a tag list. But we never really do anything tricky with those
tags, so I think it should work to simply move the call to parse_tags()
from setup_arch() into arch_get_boot_command_line().

Haavard
