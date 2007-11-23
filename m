Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXKWIwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXKWIwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 03:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXKWIwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 03:52:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:20190 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbXKWIwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 03:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=bYcJSYeAF2lrlkduPSiZU7KUEykYwGhj6j2RDwtJtWcd7xL4gGPcwcy+LiO526VGN5/GBSiQZiF+/D6Lr4j0PQIMgg5LpFLI70yuzWDkgoSK7tDp8gfnrPdssEuXVGEEmc8DaSRr4BHxbdLH5/aXd2KaQv3PoDDcbeTMiRS8Xj4=
Message-ID: <84144f020711230052h2d0b8af8radbdf1d7b08a57e3@mail.gmail.com>
Date: Fri, 23 Nov 2007 10:52:06 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jeff Dike" <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PROBLEM] uml doesn't compile on i386
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: ab5ffb95c4c12f69
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Current git head doesn't compile. Looks like fall-out from the x86 merge?

penberg@haji:~/src/linux/uml-2.6$ make ARCH=um
  SYMLINK arch/um/include/kern_constants.h
  SYMLINK arch/um/include/sysdep
make[1]: `arch/um/sys-i386/user-offsets.s' is up to date.
  CHK     arch/um/include/user_constants.h
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      arch/um/kernel/asm-offsets.s
In file included from include/asm/arch/atomic.h:2,
                 from include/asm/atomic.h:9,
                 from include/linux/spinlock.h:333,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:57,
                 from include/linux/sched.h:53,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/asm/arch/atomic_32.h: In function 'atomic_add_unless':
include/asm/arch/atomic_32.h:237: error: 'struct cpuinfo_um' has no
member named 'x86'
In file included from include/asm/rwsem.h:4,
                 from include/linux/rwsem.h:24,
                 from include/linux/mm_types.h:11,
                 from include/linux/sched.h:60,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/asm/arch/rwsem.h: In function '__down_write_trylock':
include/asm/arch/rwsem.h:165: error: 'struct cpuinfo_um' has no member
named 'x86'
make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

                                      Pekka
