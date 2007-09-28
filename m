Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbXI1Krf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbXI1Krf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbXI1Kr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:47:26 -0400
Received: from www.osadl.org ([213.239.205.134]:56040 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751910AbXI1KrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:47:25 -0400
Subject: Re: 2.6.23-rc6-mm1 powerpc - kgdb is broken
From: Thomas Gleixner <tglx@linutronix.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       amitkale@linsyssoft.com, trini@kernel.crashing.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <46FCD968.8090304@linux.vnet.ibm.com>
References: <46F114D2.40809@linux.vnet.ibm.com>
	 <46F1700D.2020205@windriver.com>
	 <20070919123629.05e3a06c.akpm@linux-foundation.org>
	 <18162.967.558342.829193@cargo.ozlabs.ibm.com>
	 <20070920073817.GA28202@infradead.org>
	 <46FCD968.8090304@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 12:47:21 +0200
Message-Id: <1190976441.18681.34.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 16:07 +0530, Kamalesh Babulal wrote:
> The kgdb is also broken with 2.6.23-rc8-mm2 on the powerpc .
> The below patch disables the kgdb from getting compiled over
> powerpc platform.
> 
> Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
> 
> --- linux-2.6.23-rc8/lib/Kconfig.kgdb   2007-09-28 06:33:37.000000000 +0530
> +++ linux-2.6.23-rc8/lib/~Kconfig.kgdb  2007-09-28 23:48:33.000000000 +0530
> @@ -14,7 +14,7 @@ config KGDB
>         bool "KGDB: kernel debugging with remote gdb"
>         select WANT_EXTRA_DEBUG_INFORMATION
>         select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
> -       depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || PPC)
> +       depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || !PPC)

This enables the KGDB config for _ALL_ platforms except powerpc. 

Just remove PPC completely.

	tglx


