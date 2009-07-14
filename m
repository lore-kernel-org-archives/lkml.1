Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZGNMeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZGNMeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZGNMea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:34:30 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50705 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbZGNMea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:34:30 -0400
Date: Tue, 14 Jul 2009 14:34:29 +0200
From: Andreas Mohr <andi@lisas.de>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc3: include/trace/events/kmem.h:47: undefined reference to
	`.L1600' (was: Kernel build failure.)
Message-ID: <20090714123429.GA15346@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10907010615m25664ebao223ef1f770ebbeeb@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm facing the same issue on RHEL3, gcc 3.4.0:

  CC [M]  lib/ts_fsm.o
  CC      arch/x86/lib/msr.o
  CC      arch/x86/lib/atomic64_32.o
arch/x86/lib/atomic64_32.c: In function `cmpxchg8b':
arch/x86/lib/atomic64_32.c:14: warning: read-write constraint does not allow a register
arch/x86/lib/atomic64_32.c:14: warning: read-write constraint does not allow a register
  LD      arch/x86/lib/built-in.o
  AS      arch/x86/lib/checksum_32.o
  CC      arch/x86/lib/delay.o
  AS      arch/x86/lib/getuser.o
  CC      arch/x86/lib/memcpy_32.o
  AS      arch/x86/lib/putuser.o
  AS      arch/x86/lib/semaphore_32.o
  CC      arch/x86/lib/string_32.o
  CC      arch/x86/lib/strstr_32.o
  AS      arch/x86/lib/thunk_32.o
  CC      arch/x86/lib/usercopy_32.o
  AR      arch/x86/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o(.init.text+0x4938): In function `con_init':
include/trace/events/kmem.h:47: undefined reference to `.L1600'
make: *** [.tmp_vmlinux1] Error 1


OK, it might be tool failure (especially given the asm warnings above),
but all older kernels did build fine (last was 2.6.29-rc7).

Will now disable tracer and retry, should ""fix"" that problem I think.

Andreas Mohr
