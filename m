Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765Ab0ANEVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0ANEVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 23:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642Ab0ANEVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 23:21:10 -0500
Received: from gate.crashing.org ([63.228.1.57]:35698 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab0ANEVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 23:21:09 -0500
Subject: Re: sys_recvmmsg: wire up or not?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <200912261212.14264.arnd@arndb.de>
References: <10f740e80912260239n17bbbd08w6c3065c12bde9c95@mail.gmail.com>
	 <200912261212.14264.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 15:20:33 +1100
Message-ID: <1263442833.724.325.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It's also rather inconsistent with the last socket call that was added, sys_accept4.
> Some architectures that normally define socket calls (parisc, sh) are missing both
> accept4 and recvmmsg, while others that don't have recvmsg now get recvmmsg.
> 
> In particular, i386 has recvmmsg now, which caused the warning that you saw.
> I guess that one should be removed, and maybe we need a better logic for
> determining which syscalls you actually want. Deriving it from asm-generic/unistd.h
> instead of arch/x86/include/asm/unistd_32.h is probably better, but would still
> give the wrong answer for multiplexed system calls like socketcall or ipc on 
> existing architectures.

Anything happening here ? We're getting that warning on ppc too despite
the fact that we use socketcall like x86... Should checksyscall be made
smarter or the syscall just removed from x86 ? :-)

Cheers,
Ben.


