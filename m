Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029Ab0ANHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab0ANHAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827Ab0ANHAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:00:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:51461 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab0ANHAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:00:14 -0500
Subject: Re: sys_recvmmsg: wire up or not?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: arnd@arndb.de, geert@linux-m68k.org, acme@redhat.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
In-Reply-To: <20100113.202807.233259060.davem@davemloft.net>
References: <10f740e80912260239n17bbbd08w6c3065c12bde9c95@mail.gmail.com>
	 <200912261212.14264.arnd@arndb.de> <1263442833.724.325.camel@pasglop>
	 <20100113.202807.233259060.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 17:59:39 +1100
Message-ID: <1263452379.724.348.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 20:28 -0800, David Miller wrote:
> > Anything happening here ? We're getting that warning on ppc too
> despite
> > the fact that we use socketcall like x86... Should checksyscall be
> made
> > smarter or the syscall just removed from x86 ? :-)
> 
> I think it's better to trap directly to the system call rather
> than going through yet another demultiplexer.
> 
> I severely regretted using sys_socketcall initially on sparc32
> because it added a few microseconds to socket syscall latency
> (cpus back then were slow :-) 

Oh I definitely agree that a direct syscall is better, and I wonder in
fact if I should add new syscalls in addition to socketcall for powerpc,
for glibc to do a slow migration :-) I was just wondering about the
inconsistency for archs like us who have socketcall today, to also have
to define the syscall ...

IE. I'd rather have them all duplicated into real syscalls than some of
them only in socketcall and some on both since that will make any kind
of userspace transition even more hellish.

Cheers,
Ben.

