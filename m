Return-Path: <linux-kernel-owner+w=401wt.eu-S1763790AbXHWP5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763790AbXHWP5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763242AbXHWP5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:57:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48066 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763167AbXHWP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:57:14 -0400
Date: Thu, 23 Aug 2007 08:51:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Announce] Unified x86 architecture, arch/x86 - V2
Message-ID: <20070823085117.368c8bdb@laptopd505.fenrus.org>
In-Reply-To: <1187819782.3316.8.camel@chaos>
References: <1187819782.3316.8.camel@chaos>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 23:56:22 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> We are pleased to announce v2 of the unified arch/x86 project we are 
> working on.
> 
> To recap: the core idea behind our project is simple to describe: we 
> introduce a new arch/x86/ and include/asm-x86/ file hierarchy that 
> includes all the existing 32-bit and 64-bit x86 code and allows the 
> building of either a 32-bit (i386) kernel or a 64-bit (x86_64)
> kernel. No code is lost and almost no code is modified. We want the
> window for regressions and tree incompatibilities to be zero. (The
> full initial announcement can be found at
> http://lkml.org/lkml/2007/7/20/447)
> 

as said before I like this a lot ;)

there's still some low hanging fruit left:

[arjan@laptopd505 x86]$ for i in */*_32.c */*/*_32.c ; do perl same_function.pl $i ; done 
Identical function: crypto/aes_32.c - aes_fini 
Identical function: crypto/aes_32.c - aes_encrypt
Identical function: crypto/aes_32.c - aes_init    
Identical function: crypto/aes_32.c - aes_decrypt
Identical function: kernel/apic_32.c - init_lapic_sysfs
Identical function: kernel/hpet_32.c - read_hpet 
Identical function: kernel/io_apic_32.c - io_apic_base
Identical function: kernel/io_apic_32.c - irq_polarity 
Identical function: kernel/io_apic_32.c - ioapic_read_entry
Identical function: kernel/io_apic_32.c - ioapic_init_sysfs
Identical function: kernel/io_apic_32.c - irq_trigger 
Identical function: kernel/io_apic_32.c - ioapic_mask_entry
Identical function: kernel/io_apic_32.c - find_irq_entry    
Identical function: kernel/io_apic_32.c - io_apic_write  
Identical function: kernel/io_apic_32.c - io_apic_read  
Identical function: kernel/io_apic_32.c - startup_ioapic_irq
Identical function: kernel/io_apic_32.c - ioapic_write_entry 
Identical function: kernel/kprobes_32.c - arch_disarm_kprobe 
Identical function: kernel/kprobes_32.c - arch_arm_kprobe   
Identical function: kernel/ldt_32.c - read_ldt 
Identical function: kernel/ldt_32.c - copy_ldt 
Identical function: kernel/ldt_32.c - flush_ldt
Identical function: kernel/mpparse_32.c - mpf_checksum
Identical function: kernel/nmi_32.c - lapic_nmi_resume 
Identical function: kernel/nmi_32.c - lapic_nmi_suspend 
Identical function: kernel/nmi_32.c - __acpi_nmi_disable
Identical function: kernel/pci-dma_32.c - via_no_dac    
Identical function: kernel/process_32.c - play_dead  
Identical function: kernel/setup_32.c - copy_edd      
Identical function: mm/fault_32.c - notify_page_fault
Identical function: mm/pageattr_32.c - flush_map 
Identical function: boot/compressed/misc_32.c - putstr
Identical function: boot/compressed/misc_32.c - scroll
Identical function: boot/compressed/misc_32.c - memcpy 
Identical function: boot/compressed/misc_32.c - free   
Identical function: boot/compressed/misc_32.c - memset 
Identical function: boot/compressed/misc_32.c - error  
Identical function: boot/compressed/misc_32.c - flush_window
Identical function: boot/compressed/misc_32.c - fill_inbuf  
Identical function: boot/compressed/misc_32.c - gzip_mark    
Identical function: kernel/acpi/sleep_32.c - acpi_sleep_setup


I'll get someone in my team to investigate merging these in the next few days and send patches to you for them.
