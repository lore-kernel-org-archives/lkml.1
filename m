Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbYGJTa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbYGJTa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYGJTau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:30:50 -0400
Received: from [198.99.130.12] ([198.99.130.12]:56304 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYGJTat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:30:49 -0400
Date: Thu, 10 Jul 2008 15:30:19 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: UML kernel failed to start betvee 2.6.8-rc8 and current git
	sources
Message-ID: <20080710193019.GA20112@c2.user-mode-linux.org>
References: <200807101619.54052.toralf.foerster@gmx.de> <20080710163514.GA17561@c2.user-mode-linux.org> <200807102010.02772.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807102010.02772.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 08:09:59PM +0200, Toralf Förster wrote:
> At Thursday 10 July 2008 18:35:15 Jeff Dike wrote :
> 
> > What's the host?
> 
> tfoerste@n22 ~ $ uname -a
> Linux n22 2.6.25-gentoo-r6 #4 Thu Jul 10 19:49:36 CEST 2008 i686 Intel(R) Pentium(R) M processor 1700MHz GenuineIntel GNU/Linux
> 
> BTW,  this works fine and shows only the config :
> n22 ~ # linux-v2.6.26-rc8-227 --showconfig 
> 
> whereas this failed:
> 
> n22 ~ # linux-v2.6.26-rc9-56 --showconfig
> Locating the bottom of the address space ... 0x0
> Locating the top of the address space ... 0xc0000000

OK, I believe you're seeing the same bug as Uli saw here:

    http://marc.info/?l=linux-kernel&m=121011518003727&w=2

More precise symptoms are here:

     http://marc.info/?l=linux-kernel&m=121011722806093&w=2

I never did figure that one out.  I had the same kernel version, same
toolchain, same everything as far as I could see, and I couldn't
reproduce it, except with a binary that he gave me.

You're seeing it on i386, whereas he saw it on x86_64.

The underlying problem is that somehow the UML initcalls aren't being
run, which is why you're seeing all zeros in the register dump.

If you bisect this, I bet you end up at the no-unit-at-a-time patch
that he ended up at.  And I have no idea what that has to do with
anything.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
