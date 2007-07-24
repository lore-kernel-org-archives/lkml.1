Return-Path: <linux-kernel-owner+w=401wt.eu-S1765209AbXGXM3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765209AbXGXM3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbXGXM3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:29:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34243 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbXGXM3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:29:17 -0400
Date: Tue, 24 Jul 2007 14:30:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: i386 section mismatch warnings
Message-ID: <20070724123029.GA15462@uranus.ravnborg.org>
References: <46A5536E.6010606@garzik.org> <20070724014512.GO21668@ftp.linux.org.uk> <46A5AEE0.1070202@googlemail.com> <20070724080847.GA13804@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724080847.GA13804@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 10:08:47AM +0200, Sam Ravnborg wrote:
> On Tue, Jul 24, 2007 at 09:48:48AM +0200, Gabriel C wrote:
> > Al Viro wrote:
> > > On Mon, Jul 23, 2007 at 09:18:38PM -0400, Jeff Garzik wrote:
> > >> make allmodconfig on i386:
> > >>
> > >> WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to 
> > > 
> > > Ignore.  vmlinux.o ones are interesting; so are ones in modules.
> > > vmlinux ones are either duplicates of vmlinux.o or false positives.
> > 
> > allyesconfig has a lot Section mismatch warnings , are these false positive too ?
> > 
> > 
> > http://lkml.org/lkml/2007/7/22/312
> 
> The first group are to be solved.
> The last group can be ignored.
> 
> I have saved your original mail but not yet looked into any of them.
> I assume that a few hours work can bring down the list considerably but
> I was sidetracked by a book (HP7) ;-)

Took a closer look at the warnings.
modpost gets confused on the weired section mames: .init.text.1, .init.text.3 etc.

See for example:

WARNING: vmlinux.o(.data+0x4b38): Section mismatch: reference to .init.text.3:powernow_cpu_init (between 'powernow_driver' and 'minimum
                                                                 ^^^^^^^^^^^^

This is easy to ignore but anyone that knows why we suddenly have a number following
the section name in a few cases?

	Sam
