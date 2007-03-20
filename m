Return-Path: <linux-kernel-owner+w=401wt.eu-S1030812AbXCTAjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030812AbXCTAjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030814AbXCTAjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:39:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36902 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030812AbXCTAjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:39:44 -0400
Date: Mon, 19 Mar 2007 17:39:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.21-rc3-mm2
Message-Id: <20070319173915.d3f99dee.akpm@linux-foundation.org>
In-Reply-To: <20070319172711.1176b3d4.randy.dunlap@oracle.com>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
	<20070319172711.1176b3d4.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 17:27:11 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 7 Mar 2007 20:19:15 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/
> > 
> > - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
> >   were dropped.
> > 
> >   This is for A/B comparison purposes, and because those changes crashed on
> >   one test setup.
> 
> I don't quite see why this error is happening.  Looks like all
> the nested #includes should handle it...
> 
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_UTRACE=y
> # PTRACE=n
> # PROC_FS=n
> 
> In file included from arch/x86_64/kernel/crash.c:19:
> include/linux/elfcore.h: In function 'elf_core_copy_regs':
> include/linux/elfcore.h:103: error: dereferencing pointer to incomplete type
> include/linux/elfcore.h:103: error: dereferencing pointer to incomplete type
> make[1]: *** [arch/x86_64/kernel/crash.o] Error 1
> make: *** [arch/x86_64/kernel] Error 2

Perhaps it's complaining about undefined pt_regs.  But it's there in asm/ptrace.h
which is included by linux/ptrace.h.  Perhaps there's an include snafu which is
causing that inclusion to not work.

Dunno.  Please send full .config to Roland ;)
