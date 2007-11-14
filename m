Return-Path: <linux-kernel-owner+w=401wt.eu-S1761250AbXKNAS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250AbXKNAS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbXKNASr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:18:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbXKNASq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:18:46 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/9] MN10300: Add the MN10300 architecture to Linux kernel
	[try #6]
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Wed, 14 Nov 2007 00:18:32 +0000
Message-ID: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add the MEI/Panasonic MN10300/AM33 architecture to the Linux
kernel.

The first four patches make it possible to suppress A.OUT support in the kernel
for an arch (CONFIG_ARCH_SUPPORTS_AOUT must be set to 'y' to unsuppress).
MN10300 does not support the AOUT binfmt, so the ELF binfmt should not be
permitted to go looking for AOUT libraries to load, nor should random bits of
the kernel depend on asm/a.out.h.

The fifth patch adds support for a flash chip not previously attested.

The sixth patch fixes a namespace collision in the net2280 USB driver.

The seventh patch allocates a couple of UART port type IDs.

The eighth patch adds the architecture itself, to be selected by ARCH=mn10300
on the make command line.

The ninth patch adds a map driver for the flashes on the ASB2303 board.

The patches can also be downloaded from:

	http://people.redhat.com/~dhowells/mn10300/mn10300-arch.tar.bz2


A suitable toolchain can be downloaded from:

	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/

The latest is currently:

	am33-04r2-5/tools/i686-pc-linux-gnulibc2.3-x-am33_2.0-linux-gnu.tar.bz2

Changes:

 (*) Split the A.OUT suppression patch at Adrian Bunk's request.

 (*) Made the A.OUT support have to be explicitly requested by an arch that
     uses it.  This allows use of the {asm,linux}/a.out.h headers with or
     without the enablement of CONFIG_BINFMT_AOUT or its equivalent.

 (*) Sorted out a lot of checkpatch gripes to make Andrew happy.  checkpatch
     still gets a lot wrong, mostly due to the eighth patch adding an arch.

 (*) Removed an addition to linux/kprobes.h and fixed the arch to deal with it
     elsewhere.

David
