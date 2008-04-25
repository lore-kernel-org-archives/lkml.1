Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYDYTSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYDYTSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYDYTSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:18:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:36886 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYDYTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tL38YxSUsYNmuBbFT3E4MQvfO0KqYKMZSWGsPNX4tfyHkbRhqD0V8AZLDl/lz8fZRc89gLI3UWa2Darp5L9zvHRuOBrfw39V/MXsz9hr/Nf5TIxhk7WheKvxLLVk57r4y5BPlWX3BmsOhdrXK8yYer2dB/hmnLtgK5nTm3RKjz8=
Message-ID: <dd18b0c30804251218r3bd45591p229e8832e8b1e137@mail.gmail.com>
Date: Fri, 25 Apr 2008 19:18:31 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] idle (arch, acpi and apm) and lockdep
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>
In-Reply-To: <1209147590.1956.12.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804241724t2dcc044dvab4a5ad506255d8d@mail.gmail.com>
	 <1209125470.24931.10.camel@lappy>
	 <dd18b0c30804250747u4168bafsccc6feec0ba78c26@mail.gmail.com>
	 <1209135549.32291.5.camel@lappy> <1209137941.32291.10.camel@lappy>
	 <dd18b0c30804251108q2d55736dtd4807db2a9ffb6c5@mail.gmail.com>
	 <1209147590.1956.12.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 6:19 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2008-04-25 at 18:08 +0000, Justin Mattock wrote:
>  > O.K. I applied this patch, below are the results:
>
>
>
> > patching file arch/x86/kernel/process_32.c
>  > Hunk #1 FAILED at 111.
>  > Hunk #2 FAILED at 126.
>  > Hunk #3 FAILED at 183.
>  > Hunk #4 FAILED at 194.
>  > 4 out of 4 hunks FAILED -- saving rejects to file
>  > arch/x86/kernel/process_32.c.rej
>  > patching file arch/x86/kernel/process_64.c
>  > Hunk #1 FAILED at 106.
>  > Hunk #2 FAILED at 179.
>  > 2 out of 2 hunks FAILED -- saving rejects to file
>  > arch/x86/kernel/process_64.c.rej
>  > patching file drivers/acpi/processor_idle.c
>  > Hunk #1 FAILED at 418.
>  > Hunk #2 FAILED at 519.
>  > Hunk #3 FAILED at 535.
>  > 3 out of 3 FAILED -- saving rejects to file drivers/acpi/processor_idle.c.rej
>  > pathing file arch/x86/kernel/apm_32.c
>  > Hunk #1 FAILED at 904.
>  > Hunk #2 FAILED at 912.
>  > 2 out of 2 hunks FAILED -- saving rejects to file arch/x86/kernel/apm_32.c.rej
>  > patching file include/asm/asm-x86/processor.h
>  > Hunk #1 FAILED at 723.
>  > 1 out of 1 hunk FAILE -- saving rejects to file include/asm-x86/processor.h.rej
>  > patching file arch/x86/kernel/process.c
>  > Hunk #2 succeeded at 44 with fuzz 2.
>  >
>  > When I compile the kernel I'm receiving this.
>  >
>  > arch/x86/kernel/process.o: In function `select_idle_routine':
>  > process.c:(.cpuinit.text+0x0): multiple definition of `select_idle_routine'
>  > arch/x86/kernel/process_32.o:process_32.c(.cpuinit.text+0x0: first defined here
>  > arch/x86/kernel/process.o: In function `cpu_idle_wait':
>  > process.c:(text+0x16): multiple definition of `cpu_idle_wait'
>  > arch/x86/kernel/process_32.o:process_32.c:(.text0x432): first defined here
>  > arch/x86/kernel/process.o: In function `mwait_idle_with_hints':
>  > process.c:(.text+0x113): multiple definition of 'mwait_idle_with_hints'
>  > arch/x86/kernel/process_32.o:process_32.c:(.text+0x1db): first defined here
>  > make[1]: *** [arch/x86/kernel/built-in.o] Error 1
>  > make: *** [arch/x86/kernel] Error 2
>  >
>  >
>  > Should I just go ahead and try git-pull to see if these patches are
>  > applied over there correctly.
>  > regards;
>
>  That's no good :-/
>
>  weird, I have:
>
>  # git describe
>  v2.6.25-4569-gb69d398
>
>  # quilt push
>  Applying patch patches/idle-lockdep-1.patch
>
> patching file arch/x86/kernel/process_32.c
>
> patching file arch/x86/kernel/process_64.c
>
> patching file drivers/acpi/processor_idle.c
>  patching file arch/x86/kernel/apm_32.c
>  patching file include/asm-x86/processor.h
>
> patching file arch/x86/kernel/process.c
>
>  Now at patch patches/idle-lockdep-1.patch
>
>
>  And I did a i386 and x86_64 defconfig build before I send it out.
>
>

I did patch -p1 < xxx.patch

-- 
Justin P. Mattock
