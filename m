Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbXIJUow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbXIJUow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbXIJUop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:44:45 -0400
Received: from www.osadl.org ([213.239.205.134]:46474 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753334AbXIJUoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:44:44 -0400
Subject: Re: [RFC] kbuild - introduce vdir to make life easier for x86_64
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
In-Reply-To: <20070910203445.GA32047@uranus.ravnborg.org>
References: <20070910191138.GA31541@uranus.ravnborg.org>
	 <1189452121.25767.42.camel@chaos> <20070910192920.GA2080@elte.hu>
	 <20070910203445.GA32047@uranus.ravnborg.org>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 22:44:42 +0200
Message-Id: <1189457082.25767.58.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

On Mon, 2007-09-10 at 22:34 +0200, Sam Ravnborg wrote:
> Partly so. Took a look at the x86 tree.
> The main Makefile are at least not merged. Neither are pci/Makefile not
> boot/compressed/Makefile.

Yeah I know. Those are the non trivial ones and the boot/compressed one
might be split forever. The pci Makefile has link order problems
(initcall order wreckage) and the main Makefile as well. Needs more
thought.

> And some of the rest of the Makefiles are not pretty with the huge arch 
> specific sections ifdeffed out.

I completely agree.

> -ifneq ($(CONFIG_ACPI_PROCESSOR),)
> -obj-y				+= cstate.o processor.o
> -endif
> +obj-$(CONFIG_X86_32)-if-$(CONFIG_ACPI_SLEEP) += sleep_32.o wakeup_32.o
> +obj-$(CONFIG_X86_64)-if-$(CONFIG_ACPI_SLEEP) += sleep_64.o wakeup_64.o
> +
> +obj-y-if-$(CONFIG_ACPI_PROCESSOR) += cstate.o processor.o
> 
> 
> My biggest worry is that we end up with a more compact format
> but only me (and a very few others) can read it.
> But I think the above could make the x86 Makefiles more readable
> as a whole.

It's way better than the ifneq(...) stuff and completely understandable
at least for me. I'd like to see that change, it is helpful on a bunch
of other places in the kernel as well.

Thanks,

	tglx


