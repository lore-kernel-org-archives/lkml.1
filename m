Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbXJJQsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbXJJQsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXJJQsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:48:37 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53176 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbXJJQsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:48:36 -0400
X-Originating-Ip: 99.236.101.138
Date: Wed, 10 Oct 2007 12:44:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: cleaning up "make headers_install" for various architectures
Message-ID: <Pine.LNX.4.64.0710101234340.32502@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  there are a number of architectures that generate warnings (and, in
one case, an error) if you try to do:

  $ make ARCH=whatever headers_install

when you don't have an appropriate cross-compiler installed.  this
doesn't seem to make sense as you shouldn't have to do any actual
cross-compiling if you're just trying to install headers, should you?

  the examples (i already mentioned the ia64 example on that list):


$ make ARCH=m68k headers_install
make: m68k-linux-gnu-gcc: Command not found
  CHK     include/linux/version.h
  HOSTCC  scripts/unifdef
  MKDIR   include
  ... etc etc ...


$ make ARCH=h8300 headers_install
make: h8300-elf-gcc: Command not found
make: h8300-elf-gcc: Command not found
  CHK     include/linux/version.h
make[1]: `scripts/unifdef' is up to date.
  UNIFDEF include/asm/page.h
  ... etc etc ...


$ make ARCH=sparc64 headers_install
/bin/sh: sparc64-linux-gcc: command not found
make: sparc64-linux-gcc: Command not found
  CHK     include/linux/version.h
make[1]: `scripts/unifdef' is up to date.
  MKDIR   include/asm-sparc64
  ... etc etc ...


$ make ARCH=ia64 headers_install
/home/rpjday/k/git/arch/ia64/scripts/check-segrel.S: Assembler messages:
/home/rpjday/k/git/arch/ia64/scripts/check-segrel.S:1: Error: unknown pseudo-op: `.rodata'
/home/rpjday/k/git/arch/ia64/scripts/check-segrel.S:2: Error: no such instruction: `data4 @segrel(start)'
objdump: '/tmp/out3703': No such file/home/rpjday/k/git/arch/ia64/scripts/toolchain-flags: line 19: [: !=:
unary operator expected


  the final example, parisc, just plain fails:

$ make ARCH=parisc headers_install
/home/rpjday/k/git/scripts/gcc-version.sh: line 16: hppa-linux-gcc: command not found
/home/rpjday/k/git/scripts/gcc-version.sh: line 17: hppa-linux-gcc: command not found
/home/rpjday/k/git/arch/parisc/Makefile:39: *** Sorry, GCC v3.3 or above is required..  Stop.


rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
