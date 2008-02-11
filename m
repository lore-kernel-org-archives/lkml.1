Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbYBKWa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbYBKWa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYBKWas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:30:48 -0500
Received: from ns.store20.com ([212.7.7.16]:44501 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbYBKWar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:30:47 -0500
Subject: REGRESSION: x86 vDSO: remove vdso-syms.o
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Feb 2008 00:30:45 +0200
Message-Id: <1202769045.10829.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started getting following linking error on amd64 after the 2.6.25
patch floodgates were opened:
﻿[snip]
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/x86/vdso/built-in.o: In function `init_vdso_vars':
vma.c:(.init.text+0x170): undefined reference to `VDSO64_vgetcpu_mode'
vma.c:(.init.text+0x1a3): undefined reference to `VDSO64_vsyscall_gtod_data'
vma.c:(.init.text+0x1aa): undefined reference to `VDSO64_vgetcpu_mode'
vma.c:(.init.text+0x1d8): undefined reference to `VDSO64_vsyscall_gtod_data'
make: *** [.tmp_vmlinux1] Error 1

Bisecting turned up following commit:
2b9c97e16101e8dc2b0810d6f932d475a051d785 is first bad commit
commit 2b9c97e16101e8dc2b0810d6f932d475a051d785
Author: Roland McGrath <roland@redhat.com>
Date:   Wed Jan 30 13:30:41 2008 +0100

    x86 vDSO: remove vdso-syms.o
    
    Get rid of vdso-syms.o from the kernel link.  We don't need it any more.
    
    Signed-off-by: Roland McGrath <roland@redhat.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


To test get the error, just disable 32 bit emulation (IA32_EMULATION)

Cheers,
Priit ;)
