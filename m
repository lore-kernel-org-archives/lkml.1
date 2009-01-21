Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbZAUDzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbZAUDzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 22:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZAUDzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 22:55:11 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:55015 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbZAUDzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 22:55:10 -0500
Date: Wed, 21 Jan 2009 04:56:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Doubts in usr/include/linux/elf.h
Message-ID: <20090121035653.GB25366@uranus.ravnborg.org>
References: <1232496986.3123.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232496986.3123.28.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 05:46:26AM +0530, Jaswinder Singh Rajput wrote:
> usr/include/linux/elf.h is giving 4 'make headers_check' warnings:
>  usr/include/linux/elf.h:379: extern's make no sense in userspace
>  usr/include/linux/elf.h:387: extern's make no sense in userspace
>  usr/include/linux/elf.h:401: extern's make no sense in userspace
>  usr/include/linux/elf.h:402: extern's make no sense in userspace
> 
> 
> usr/include/linux/elf.h:
> --
> #if ELF_CLASS == ELFCLASS32
> 
> extern Elf32_Dyn _DYNAMIC [];
> #define elfhdr          elf32_hdr
> #define elf_phdr        elf32_phdr
> #define elf_note        elf32_note
> #define elf_addr_t      Elf32_Off
> 
> #else
> 
> extern Elf64_Dyn _DYNAMIC [];
> #define elfhdr          elf64_hdr
> #define elf_phdr        elf64_phdr
> #define elf_note        elf64_note
> #define elf_addr_t      Elf64_Off
> 
> #endif

If my quick grep is correct we fo not define any variable named _DYNAMIC.
So you can just drop these two lines.

> 
> /* Optional callbacks to write extra ELF notes. */
> #ifndef ARCH_HAVE_EXTRA_ELF_NOTES
> static __inline__ int elf_coredump_extra_notes_size(void) { return 0; }
> static __inline__ int elf_coredump_extra_notes_write(struct file *file,
>                         loff_t *foffset) { return 0; }
> #else
> extern int elf_coredump_extra_notes_size(void);
> extern int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset);
> #endif

And the above can all be wrapped in __KERNEL__.
They got renamed in 2007:
http://ozlabs.org/pipermail/cbe-oss-dev/2007-September/003276.html

So they are hardly used by userspace anyway.

	Sam
