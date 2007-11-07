Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbXKGRnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbXKGRnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbXKGRna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:43:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbXKGRn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:43:29 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel
	[try #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Wed, 07 Nov 2007 17:43:23 +0000
Message-ID: <20071107174323.31820.65054.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add the MEI/Panasonic MN10300/AM33 architecture to the Linux
kernel.

The first patch suppresses AOUT support in the kernel if CONFIG_BINFMT_AOUT=n
and CONFIG_IA32_AOUT=n.  MN10300 does not support the AOUT binfmt, so the ELF
binfmt should not be permitted to go looking for AOUT libraries to load, nor
should random bits of the kernel depend on asm/a.out.h.

The second patch adds the architecture itself, to be selected by ARCH=mn10300
on the make command line.

The patches can also be downloaded from:

	http://people.redhat.com/~dhowells/mn10300/mn10300-arch.tar.bz2


A suitable toolchain can be downloaded from:

	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/

The latest is currently:

	am33-04r2-5/tools/i686-pc-linux-gnulibc2.3-x-am33_2.0-linux-gnu.tar.bz2

Changes:

 (*) After discussing it with MEI, I've flattened the asm/cpu/ include dir into
     asm/ and also renamed mn103e010-{watchdog,serial} to
     mn10300-{watchdog,serial}.

     The asm/proc/ dir still exists, but what it contains is in the nature of
     configuration.

 (*) CONFIG_FPU now depends on CONFIG_PROC_MN103E010 rather than being
     automatically selected if the AM33V2 CPU core is enabled as some AM33V2
     cores aren't packaged with an FPU.

 (*) A bit of cleaning up.

 (*) Made sure it compiles with allnoconfig, allyesconfig and allmodconfig.

David
