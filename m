Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZABCyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZABCyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 21:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZABCyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 21:54:05 -0500
Received: from smtp.tal.de ([81.92.1.5]:34387 "EHLO smtp.tal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZABCyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 21:54:04 -0500
From: ib@wupperonline.de (Ingo Brueckl)
Date: Fri, 02 Jan 2009 03:48:00 +0100
Subject: Re: compile time warnings
X-Mailer: blueMail 1.4 (SlipDoor 2.2)
Message-ID: <495d7b8d@wupperonline.de>
In-Reply-To: <495d3100@wupperonline.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What we have so far:

  arch/x86/kernel/setup.c:742: warning: 'dmi_low_memory_corruption'

is already fixed in the git tree.

  arch/x86/mm/init_32.c:515: warning: unused variable 'pgd_base'

could be fixed with Jespers patch (which I like best).

  WARNING: modpost: Found 1 section mismatch(es).

which is (with CONFIG_DEBUG_SECTION_MISMATCH=y):

  WARNING: vmlinux.o(.cpuinit.data+0x0): Section mismatch in reference from
  the variable initial_code to the function .init.text:i386_start_kernel()
  The variable __cpuinitdata initial_code references a function __init
  i386_start_kernel(). If i386_start_kernel is only used by initial_code then
  annotate i386_start_kernel with a matching annotation.

was already noticed some time ago by linuxtwid...@gmail.com, but is still
unfixed.

Here is what linuxtwid...@gmail.com suggested:

--- linux-2.6.27.1/arch/x86/kernel/head_32.S	2008-10-16 00:49:00.000000000 -0500
+++ linux-2.6.27.1-test/arch/x86/kernel/head_32.S	2008-10-16 01:45:10.000000000 -0500
@@ -600,6 +600,7 @@ ignore_int:

 .section .cpuinit.data,"wa"
 .align 4
+__REFDATA
 ENTRY(initial_code)
 	.long i386_start_kernel

The remaining

  /usr/src/linux/arch/x86/include/asm/string_32.h:75: warning: array subscript is above array bounds

is very strange and a mystery to me. (There were already reports on that
issue which seem to point to a gcc bug.)
