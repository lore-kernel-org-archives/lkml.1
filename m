Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZAUARB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZAUARB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZAUAQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:16:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:37211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181AbZAUAQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:16:48 -0500
Subject: Doubts in usr/include/linux/elf.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 05:46:26 +0530
Message-Id: <1232496986.3123.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usr/include/linux/elf.h is giving 4 'make headers_check' warnings:
 usr/include/linux/elf.h:379: extern's make no sense in userspace
 usr/include/linux/elf.h:387: extern's make no sense in userspace
 usr/include/linux/elf.h:401: extern's make no sense in userspace
 usr/include/linux/elf.h:402: extern's make no sense in userspace


usr/include/linux/elf.h:
--
#if ELF_CLASS == ELFCLASS32

extern Elf32_Dyn _DYNAMIC [];
#define elfhdr          elf32_hdr
#define elf_phdr        elf32_phdr
#define elf_note        elf32_note
#define elf_addr_t      Elf32_Off

#else

extern Elf64_Dyn _DYNAMIC [];
#define elfhdr          elf64_hdr
#define elf_phdr        elf64_phdr
#define elf_note        elf64_note
#define elf_addr_t      Elf64_Off

#endif

/* Optional callbacks to write extra ELF notes. */
#ifndef ARCH_HAVE_EXTRA_ELF_NOTES
static __inline__ int elf_coredump_extra_notes_size(void) { return 0; }
static __inline__ int elf_coredump_extra_notes_write(struct file *file,
                        loff_t *foffset) { return 0; }
#else
extern int elf_coredump_extra_notes_size(void);
extern int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset);
#endif
--

Which things we can drop from this portion to get rid of above warnings.

Thanks

--
JSR

