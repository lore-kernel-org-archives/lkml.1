Return-Path: <linux-kernel-owner+w=401wt.eu-S1762335AbXKOGQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbXKOGQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXKOGQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50958 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXKOGQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:01 -0500
Date: Wed, 14 Nov 2007 22:14:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/19] 2.6.23-stable review, arch specific stuff
Message-ID: <20071115061415.GA7980@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.23.X release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday 00:00:00 UTC.  Anything received
after that time might be too late.

This set of patches focuses on arch specific changes.

The diffstat of this review series is included below.

thanks,

greg k-h

-----

 arch/i386/boot/boot.h                  |    8 ++--
 arch/i386/boot/header.S                |   62 +++++++++++++++++++++++----------
 arch/i386/boot/video-bios.c            |    2 -
 arch/i386/boot/video-vesa.c            |    2 -
 arch/i386/boot/video.c                 |    2 -
 arch/i386/kernel/tsc.c                 |    5 +-
 arch/i386/xen/enlighten.c              |   57 ++++++++++++++++++++----------
 arch/i386/xen/mmu.c                    |   29 +++++++++++++--
 arch/i386/xen/multicalls.c             |   29 +++++++++++++--
 arch/i386/xen/multicalls.h             |    3 +
 arch/i386/xen/xen-ops.h                |    1 
 arch/mips/mm/c-r4k.c                   |   21 +++++++++--
 arch/powerpc/math-emu/math.c           |   13 ++++--
 arch/powerpc/platforms/cell/axon_msi.c |    4 +-
 arch/sparc64/kernel/sys_sparc.c        |    2 -
 arch/sparc64/lib/xor.S                 |   12 +++---
 arch/um/Makefile                       |    3 +
 arch/um/include/common-offsets.h       |    1 
 arch/um/include/sysdep-i386/stub.h     |    3 -
 arch/um/kernel/skas/clone.c            |    1 
 arch/um/os-Linux/main.c                |    1 
 arch/um/os-Linux/skas/mem.c            |    1 
 arch/um/os-Linux/skas/process.c        |    2 -
 arch/um/os-Linux/start_up.c            |    1 
 arch/um/os-Linux/tt.c                  |    1 
 arch/um/os-Linux/util.c                |   38 ++++++++++++++++++++
 arch/um/sys-i386/user-offsets.c        |    6 +--
 arch/um/sys-x86_64/user-offsets.c      |    9 ----
 arch/x86_64/mm/init.c                  |    6 ---
 arch/x86_64/mm/pageattr.c              |    9 +++-
 fs/xfs/linux-2.6/xfs_buf.c             |   13 ++++++
 include/asm-mips/hazards.h             |   54 ++++++++++++++++++++++++++++
 include/linux/bootmem.h                |    1 
 include/xen/interface/vcpu.h           |    5 +-
 mm/sparse.c                            |   11 -----
 35 files changed, 307 insertions(+), 111 deletions(-)
