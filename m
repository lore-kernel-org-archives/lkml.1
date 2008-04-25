Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbYDYSVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbYDYSVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759838AbYDYSU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:20:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbYDYSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:20:24 -0400
Subject: Re: [PATCH] idle (arch, acpi and apm) and lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>
In-Reply-To: <dd18b0c30804251108q2d55736dtd4807db2a9ffb6c5@mail.gmail.com>
References: <dd18b0c30804241724t2dcc044dvab4a5ad506255d8d@mail.gmail.com>
	 <1209125470.24931.10.camel@lappy>
	 <dd18b0c30804250747u4168bafsccc6feec0ba78c26@mail.gmail.com>
	 <1209135549.32291.5.camel@lappy> <1209137941.32291.10.camel@lappy>
	 <dd18b0c30804251108q2d55736dtd4807db2a9ffb6c5@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 20:19:50 +0200
Message-Id: <1209147590.1956.12.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 18:08 +0000, Justin Mattock wrote:
> O.K. I applied this patch, below are the results:

> patching file arch/x86/kernel/process_32.c
> Hunk #1 FAILED at 111.
> Hunk #2 FAILED at 126.
> Hunk #3 FAILED at 183.
> Hunk #4 FAILED at 194.
> 4 out of 4 hunks FAILED -- saving rejects to file
> arch/x86/kernel/process_32.c.rej
> patching file arch/x86/kernel/process_64.c
> Hunk #1 FAILED at 106.
> Hunk #2 FAILED at 179.
> 2 out of 2 hunks FAILED -- saving rejects to file
> arch/x86/kernel/process_64.c.rej
> patching file drivers/acpi/processor_idle.c
> Hunk #1 FAILED at 418.
> Hunk #2 FAILED at 519.
> Hunk #3 FAILED at 535.
> 3 out of 3 FAILED -- saving rejects to file drivers/acpi/processor_idle.c.rej
> pathing file arch/x86/kernel/apm_32.c
> Hunk #1 FAILED at 904.
> Hunk #2 FAILED at 912.
> 2 out of 2 hunks FAILED -- saving rejects to file arch/x86/kernel/apm_32.c.rej
> patching file include/asm/asm-x86/processor.h
> Hunk #1 FAILED at 723.
> 1 out of 1 hunk FAILE -- saving rejects to file include/asm-x86/processor.h.rej
> patching file arch/x86/kernel/process.c
> Hunk #2 succeeded at 44 with fuzz 2.
> 
> When I compile the kernel I'm receiving this.
> 
> arch/x86/kernel/process.o: In function `select_idle_routine':
> process.c:(.cpuinit.text+0x0): multiple definition of `select_idle_routine'
> arch/x86/kernel/process_32.o:process_32.c(.cpuinit.text+0x0: first defined here
> arch/x86/kernel/process.o: In function `cpu_idle_wait':
> process.c:(text+0x16): multiple definition of `cpu_idle_wait'
> arch/x86/kernel/process_32.o:process_32.c:(.text0x432): first defined here
> arch/x86/kernel/process.o: In function `mwait_idle_with_hints':
> process.c:(.text+0x113): multiple definition of 'mwait_idle_with_hints'
> arch/x86/kernel/process_32.o:process_32.c:(.text+0x1db): first defined here
> make[1]: *** [arch/x86/kernel/built-in.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> 
> 
> Should I just go ahead and try git-pull to see if these patches are
> applied over there correctly.
> regards;

That's no good :-/

weird, I have:

# git describe
v2.6.25-4569-gb69d398

# quilt push
Applying patch patches/idle-lockdep-1.patch
patching file arch/x86/kernel/process_32.c
patching file arch/x86/kernel/process_64.c
patching file drivers/acpi/processor_idle.c
patching file arch/x86/kernel/apm_32.c
patching file include/asm-x86/processor.h
patching file arch/x86/kernel/process.c

Now at patch patches/idle-lockdep-1.patch


And I did a i386 and x86_64 defconfig build before I send it out.

