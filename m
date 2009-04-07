Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZDGC6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZDGC6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZDGC6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:58:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZDGC6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:58:32 -0400
Subject: Re: intel-iommu: Add for_each_iommu() and for_each_active_iommu()
 macros
From: David Woodhouse <dwmw2@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.2.00.0904062127420.24008@gandalf.stny.rr.com>
References: <200904062159.n36Lx1OJ001967@hera.kernel.org>
	 <20090406175918.c38654b2.akpm@linux-foundation.org>
	 <1239066583.22733.258.camel@macbook.infradead.org>
	 <1239067146.22733.260.camel@macbook.infradead.org>
	 <alpine.DEB.2.00.0904062127420.24008@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Apr 2009 19:58:14 -0700
Message-Id: <1239073094.22733.267.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 21:29 -0400, Steven Rostedt wrote:
> If this works then (after reformating)
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Yeah, it seems to work. This worried me briefly for a while but then I
realised it was already there before my changes...

[dwmw2@macbook linux-2.6]$ grep CONFIG_PROFILE_ALL_BRANCHES .config
# CONFIG_PROFILE_ALL_BRANCHES is not set
[dwmw2@macbook linux-2.6]$ make drivers/net/e100.o
scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CC      kernel/bounds.s
  GEN     include/linux/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/net/e100.o
[dwmw2@macbook linux-2.6]$ sed -i 's/.*\(CONFIG_PROFILE_ALL_BRANCHES\).*/\1=y/' .config
[dwmw2@macbook linux-2.6]$ make drivers/net/e100.oscripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CC      kernel/bounds.s
  GEN     include/linux/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/net/e100.o
drivers/net/e100.c: In function ‘e100_hw_init’:
drivers/net/e100.c:1344: warning: ‘err’ may be used uninitialized in this function


This happens in a lot of places, not just e100.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

