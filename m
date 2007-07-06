Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbXGFQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbXGFQqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbXGFQqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:46:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55716 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbXGFQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:46:06 -0400
Date: Fri, 6 Jul 2007 09:45:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: kgdb Bad IO access (was: 2.6.22-rc6-mm1)
Message-Id: <20070706094519.dd156ffd.akpm@linux-foundation.org>
In-Reply-To: <468E4BA5.8010601@imap.cc>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<468E4BA5.8010601@imap.cc>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jul 2007 16:03:17 +0200 Tilman Schmidt <tilman@imap.cc> wrote:

> Andrew Morton schrieb:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
> > 
> > - Added the kgdb tree, as git-kgdb.patch (Jason Wessel
> >   <jason.wessel@windriver.com>)
> > 
> >   This is a large patch which unifies all the various kgdb stubs lying
> >   around various architectures and extends kgdb support to other
> >   architectures.  Supported architectures are at present arm, i386, ia64,
> >   mips, ppc32, ppc64, sh, and x86_64.
> > 
> >   Subject to review, we're aiming this at 2.6.24.
> 
> Built a kernel with this just for fun on a Pentium D 940 system running
> a 32 bit install of SuSE 10.2. It complained thusly relatively early
> during startup:
> 
> --------8<--------8<--------8<--------8<--------8<--------8<--------8<
> Bad IO access at port 10000 (outb(val,port))
> WARNING: at lib/iomap.c:44 bad_io_access()
>  [dump_trace+99/475] dump_trace+0x63/0x1db
>  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
>  [show_trace+18/20] show_trace+0x12/0x14
>  [dump_stack+22/24] dump_stack+0x16/0x18
>  [bad_io_access+84/86] bad_io_access+0x54/0x56
>  [iowrite8+52/54] iowrite8+0x34/0x36
>  [kgdb8250_uart_init+164/609] kgdb8250_uart_init+0xa4/0x261
>  [kgdb_init_io+172/200] kgdb_init_io+0xac/0xc8
>  [kgdb_late_entry+54/164] kgdb_late_entry+0x36/0xa4
>  [kernel_init+346/732] kernel_init+0x15a/0x2dc
>  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
>  =======================
> Bad IO access at port 10000 (return inb(port))
> WARNING: at lib/iomap.c:44 bad_io_access()
>  [dump_trace+99/475] dump_trace+0x63/0x1db
>  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
>  [show_trace+18/20] show_trace+0x12/0x14
>  [dump_stack+22/24] dump_stack+0x16/0x18
>  [bad_io_access+84/86] bad_io_access+0x54/0x56
>  [ioread8+40/47] ioread8+0x28/0x2f
>  [kgdb8250_uart_init+334/609] kgdb8250_uart_init+0x14e/0x261
>  [kgdb_init_io+172/200] kgdb_init_io+0xac/0xc8
> input: AT Translated Set 2 keyboard as /class/input/input1
>  [kgdb_late_entry+54/164] kgdb_late_entry+0x36/0xa4
>  [kernel_init+346/732] kernel_init+0x15a/0x2dc
>  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
>  =======================
> Bad IO access at port 10000 (outb(val,port))
> WARNING: at lib/iomap.c:44 bad_io_access()
>  [dump_trace+99/475] dump_trace+0x63/0x1db
>  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
>  [show_trace+18/20] show_trace+0x12/0x14
>  [dump_stack+22/24] dump_stack+0x16/0x18
>  [bad_io_access+84/86] bad_io_access+0x54/0x56
>  [iowrite8+52/54] iowrite8+0x34/0x36
>  [kgdb8250_uart_init+164/609] kgdb8250_uart_init+0xa4/0x261
>  [kgdb8250_late_init+32/153] kgdb8250_late_init+0x20/0x99
>  [kgdb_late_entry+136/164] kgdb_late_entry+0x88/0xa4
>  [kernel_init+346/732] kernel_init+0x15a/0x2dc
>  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
>  =======================
> Bad IO access at port 10000 (return inb(port))
> WARNING: at lib/iomap.c:44 bad_io_access()
>  [dump_trace+99/475] dump_trace+0x63/0x1db
>  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
>  [show_trace+18/20] show_trace+0x12/0x14
>  [dump_stack+22/24] dump_stack+0x16/0x18
>  [bad_io_access+84/86] bad_io_access+0x54/0x56
>  [ioread8+40/47] ioread8+0x28/0x2f
>  [kgdb8250_uart_init+334/609] kgdb8250_uart_init+0x14e/0x261
>  [kgdb8250_late_init+32/153] kgdb8250_late_init+0x20/0x99
>  [kgdb_late_entry+136/164] kgdb_late_entry+0x88/0xa4
>  [kernel_init+346/732] kernel_init+0x15a/0x2dc
>  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
>  =======================
> KGDB failed to request the serial IRQ (0)
> registered taskstats version 1
> Freeing unused kernel memory: 236k freed
> --------8<--------8<--------8<--------8<--------8<--------8<--------8<
> 
> Apart from that, the kernel runs fine, though its subjectively a bit
> sluggish compared to 2.6.22-rc6-mm1 without kgdb. Its uname -a is:
> Linux xenon 2.6.22-rc6-mm1-test4 #10 SMP PREEMPT Thu Jul 5 23:41:32 CEST 2007 i686 i686 i386 GNU/Linux
> I didn't even try to actually do anything with kgdb, though.
> 
> The .config delta is:
> 
> --- good.config-3       2007-07-05 22:35:30.000000000 +0200
> +++ .config     2007-07-05 23:23:09.000000000 +0200
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
>  # Linux kernel version: 2.6.22-rc6-mm1
> -# Thu Jul  5 22:05:32 2007
> +# Thu Jul  5 23:23:09 2007
>  #
>  CONFIG_X86_32=y
>  CONFIG_GENERIC_TIME=y
> @@ -35,7 +35,7 @@
>  #
>  # General setup
>  #
> -CONFIG_LOCALVERSION="-test3"
> +CONFIG_LOCALVERSION="-test4"
>  CONFIG_LOCALVERSION_AUTO=y
>  CONFIG_SWAP=y
>  CONFIG_SWAP_PREFETCH=y
> @@ -2529,8 +2529,24 @@
>  CONFIG_FAIL_MAKE_REQUEST=y
>  CONFIG_FAULT_INJECTION_DEBUG_FS=y
>  CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
> -# CONFIG_WANT_EXTRA_DEBUG_INFORMATION is not set
> -# CONFIG_KGDB is not set
> +CONFIG_WANT_EXTRA_DEBUG_INFORMATION=y
> +CONFIG_KGDB=y
> +# CONFIG_KGDB_CONSOLE is not set
> +# CONFIG_KGDB_ONLY_MODULES is not set
> +CONFIG_KGDB_8250_NOMODULE=y
> +# CONFIG_KGDBOE_NOMODULE is not set
> +# CONFIG_KGDB_MPSC is not set
> +# CONFIG_KGDB_CPM_UART is not set
> +# CONFIG_KGDB_SIBYTE is not set
> +# CONFIG_KGDB_TXX9 is not set
> +# CONFIG_KGDB_SH_SCI is not set
> +# CONFIG_KGDB_AMBA_PL011 is not set
> +# CONFIG_KGDB_PXA_SERIAL is not set
> +# CONFIG_KGDBOE is not set
> +CONFIG_KGDB_8250=y
> +CONFIG_KGDB_SIMPLE_SERIAL=y
> +CONFIG_KGDB_BAUDRATE=115200
> +CONFIG_KGDB_PORT_NUM=1
>  CONFIG_EARLY_PRINTK=y
>  CONFIG_DEBUG_STACKOVERFLOW=y
>  CONFIG_DEBUG_STACK_USAGE=y

hm.  It _looks_ like kgdb hasn't been told the uart address and it's
defaulting to something silly.  But a) it should guess better than that and
b) the addresses should differ at least a little bit.

Maybe Jason can tell us what went wrong?
