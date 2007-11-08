Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbXKHRQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbXKHRQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759567AbXKHRQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:16:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759541AbXKHRQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:16:29 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/6] MN10300: Add the MN10300 architecture to Linux kernel
	[try #4]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Thu, 08 Nov 2007 17:16:12 +0000
Message-ID: <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add the MEI/Panasonic MN10300/AM33 architecture to the Linux
kernel.

The first patch suppresses A.OUT support in the kernel if CONFIG_BINFMT_AOUT=n
and CONFIG_IA32_AOUT=n and CONFIG_BINFMT_AOUT32=n.  MN10300 does not support
the AOUT binfmt, so the ELF binfmt should not be permitted to go looking for
AOUT libraries to load, nor should random bits of the kernel depend on
asm/a.out.h.

The fifth patch adds the architecture itself, to be selected by ARCH=mn10300 on
the make command line.

The patches can also be downloaded from:

	http://people.redhat.com/~dhowells/mn10300/mn10300-arch.tar.bz2


A suitable toolchain can be downloaded from:

	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/

The latest is currently:

	am33-04r2-5/tools/i686-pc-linux-gnulibc2.3-x-am33_2.0-linux-gnu.tar.bz2

Changes:

 (*) Split out the JEDEC chip addition, the net2280 namespace clash fix, the
     UART type ID allocation and the ASB2303 flash handler into separate
     patches.

 (*) Don't use #ifdef __mn10300__ when CONFIG_MN10300 is available.

 (*) Juggled the kprobe headers a bit.

 (*) Moved the Kbuild patch hunks from the main patch to the A.OUT suppression
     patch as they relate to {asm,linux}/a.out.h.

 (*) Reworked the A.OUT suppression patch to not have conditionally exported
     symbols, depending on module configuration.  aout_dump_thread() is inlined
     instead.

David
