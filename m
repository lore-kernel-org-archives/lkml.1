Return-Path: <linux-kernel-owner+w=401wt.eu-S1762744AbXJYUex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762744AbXJYUex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbXJYUem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:34:42 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46281 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbXJYUel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:34:41 -0400
Date: Thu, 25 Oct 2007 22:36:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] kill i386 and x86_64 directories
Message-ID: <20071025203615.GA14819@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org> <20071025201437.GA14671@uranus.ravnborg.org> <3ae72650710251319y6bc4ad10u1b7ab271ba333072@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650710251319y6bc4ad10u1b7ab271ba333072@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 10:19:40PM +0200, Kay Sievers wrote:
> > Because:
> > 1) It sort of finishes the initial merge
> > 2) Any breakage should be easy to trigger (build breakage) and easy to fix.
> >
> > It is 1) that make me say this is -rc1 materail,
> >  and 2) that say that this is an acceptable 'breaking the rules' patch serie.
> 
> Hey Sam,
> I get this after a simple pull from your tree and a: make clean; make:
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/x86/kernel/head_64.o: In function `early_idt_handler':
> (.text.head+0x1e5): undefined reference to `early_printk'
> arch/x86/kernel/head64.o: In function `x86_64_start_kernel':
> head64.c:(.init.text+0xa8): undefined reference to `early_printk'
> arch/x86/kernel/built-in.o: In function `early_panic':
> (.text+0x9c07): undefined reference to `early_printk'
> arch/x86/mm/built-in.o: In function `init_memory_mapping':
> (.init.text+0xc0a): undefined reference to `early_printk'
> make: *** [.tmp_vmlinux1] Error 1

I think this is my changes to the Kconfig.debug path
I received from Randy.

Checking....
Yup - reverting my change bring back EARLY_PRINTK wich is
always required on x86_64.

I will redo the series - and build test a bit more.
Thanks.

	Sam
