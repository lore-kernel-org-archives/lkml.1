Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbYGOTrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbYGOTrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759075AbYGOTrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:47:45 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52893 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759049AbYGOTro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:47:44 -0400
Subject: vread_tsc() compile error (post 2.6.26)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: mingo <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alok N Kataria <akataria@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Dan Hecht <dhecht@vmware.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 15 Jul 2008 12:47:41 -0700
Message-Id: <1216151261.25942.24.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ git describe
v2.6.26-2465-g1c0fea9

This looks like it was caused by:
﻿
	8fbbc4b45ce3e4c0eeb15004c79c72b6896a79c2

Did this get any testing on x86-32?  It looks like this symbol has no
32-bit equivalent.

...
  MODPOST vmlinux.o
WARNING: modpost: Found 11 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/x86/kernel/built-in.o: In function `vread_tsc':
/home/dave/kernels/linux-2.6.git/arch/x86/kernel/tsc.c:365: undefined reference to `__vsyscall_gtod_data'
/home/dave/kernels/linux-2.6.git/arch/x86/kernel/tsc.c:365: undefined reference to `__vsyscall_gtod_data'
make: *** [.tmp_vmlinux1] Error 1
﻿
My config:

http://sr71.net/~dave/linux/config-2.6.26-rc8-00089-ge1441b9


-- Dave

