Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbXJVCh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbXJVCh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXJVChV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:37:21 -0400
Received: from ozlabs.org ([203.10.76.45]:39259 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbXJVChU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:37:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] lguest: paravirt boot code
Date: Mon, 22 Oct 2007 12:37:13 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221237.14542.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

	First attempt at git, so please pull carefully.  I've just put the
three i386 boot changes in the repo for the moment.  If this works I'll pile 
on the 44 lguest patches.

	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest.git

 Documentation/i386/boot.txt        |   34 +++++++++++++++++++++++++++-
 arch/x86/boot/compressed/head_32.S |   15 ++++++++++-
 arch/x86/boot/compressed/misc_32.c |    3 ++
 arch/x86/boot/header.S             |    7 +++++-
 arch/x86/kernel/asm-offsets_32.c   |    7 +++++
 arch/x86/kernel/head_32.S          |   44 +++++++++++++++++++++++++++++++++--
 include/asm-x86/bootparam.h        |    9 +++++-
 include/linux/linkage.h            |    6 +++++
 8 files changed, 116 insertions(+), 9 deletions(-)

commit f160a3a39ba7a5ac03a0eb64c25d3751c342e0e7
Author: Jeremy Fitzhardinge <jeremy@xensource.com>
Date:   Mon Oct 22 10:56:19 2007 +1000

    i386: paravirt boot sequence
    
    This patch uses the updated boot protocol to do paravirtualized boot.
    If the boot version is >= 2.07, then it will do two things:
    
     1. Check the bootparams loadflags to see if we should reload the
        segment registers and clear interrupts.  This is appropriate
        for normal native boot and some paravirtualized environments, but
        inapproprate for others.
    
     2. Check the hardware architecture, and dispatch to the appropriate
        kernel entrypoint.  If the bootloader doesn't set this, then we
        simply do the normal boot sequence.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: H. Peter Anvin <hpa@zytor.com>
    Cc: "Eric W. Biederman" <ebiederm@xmission.com>
    Cc: Vivek Goyal <vgoyal@in.ibm.com>
    Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

commit a706681568ed19f147ab78674388c5a0e6ab8c44
Author: Jeremy Fitzhardinge <jeremy@xensource.com>
Date:   Mon Oct 22 10:56:18 2007 +1000

    add WEAK() for creating weak asm labels
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: H. Peter Anvin <hpa@zytor.com>

commit 262ac2158778ac5937ae943d1d43f0adcff1a1d1
Author: Jeremy Fitzhardinge <jeremy@xensource.com>
Date:   Mon Oct 22 10:56:17 2007 +1000

    update boot spec to 2.07
    
    Proposed updates for version 2.07 of the boot protocol.  This includes:
    
    load_flags.KEEP_SEGMENTS- flag to request/inhibit segment reloads
    hardware_subarch	- what subarchitecture we're booting under
    hardware_subarch_data	- per-architecture data
    
    The intention of these changes is to make booting a paravirtualized
    kernel work via the normal Linux boot protocol.  The intention is that
    the bzImage payload can be a properly formed ELF file, so that the
    bootloader can use its ELF notes and Phdrs to get more metadata about
    the kernel and its requirements.
    
    The ELF file could be the uncompressed kernel vmlinux itself; it would
    only take small buildsystem changes to implement this.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: H. Peter Anvin <hpa@zytor.com>
    Cc: "Eric W. Biederman" <ebiederm@xmission.com>
    Cc: Vivek Goyal <vgoyal@in.ibm.com>
