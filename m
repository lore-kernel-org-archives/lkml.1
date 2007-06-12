Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbXFLMTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbXFLMTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbXFLMTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:19:39 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21436 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbXFLMTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:19:38 -0400
Message-ID: <466E8F58.9010502@msgid.tls.msk.ru>
Date: Tue, 12 Jun 2007 16:19:36 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
References: <466E65A7.3000206@msgid.tls.msk.ru> <466E69BE.405@vger.kernel.org>
In-Reply-To: <466E69BE.405@vger.kernel.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux-kernel wrote:
[]
> To me it looks like a wrong choice of gcc switches to user-mode programs. What
> distribution are you using? try compiling failing programs from source with
> conservative command line switches to gcc. See if things change.

Wrong choice of gcc switches tends to produce binaries wich are either works
or does not.  Here, it sometimes works and sometimes does not.  Also, if
it was wrong options, programs usually tends to fail with something like
SIGILL (Illegal Instruction), not SIGSEGV.

The system is running Debian Etch (4.0), with everything compiled for plain
i386 (default gcc -O2 without any fancy optimizations).

I tried installing libc6-i686 package (cmov-enabled glibc) - unlike with
VIA C3 (which indeed does not have this instruction), it worked on C7, but
installing libc6-i686 didn't change SIGSEGVs at all.

I just tried to recompile man(1) command (the one that gave SIGSEGVs most
often).  The resulting binary fails MUCH less often, but still sometimes
fails.

Note that this is real i686 CPU.  At least according to kernel - when one
chooses C7 CPU in kernel config, kernel uses -march=i686 switch - the only
CPU-specific switch it is.  The difference between i686 and C7 in kernel
config is cache shift value.

Thanks.

/mjt
