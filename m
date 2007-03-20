Return-Path: <linux-kernel-owner+w=401wt.eu-S1030790AbXCTA2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030790AbXCTA2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030794AbXCTA2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:28:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55941 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030790AbXCTA2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:28:10 -0400
Date: Mon, 19 Mar 2007 17:27:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2
Message-Id: <20070319172711.1176b3d4.randy.dunlap@oracle.com>
In-Reply-To: <20070307201915.4d579113.akpm@linux-foundation.org>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 20:19:15 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/
> 
> - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
>   were dropped.
> 
>   This is for A/B comparison purposes, and because those changes crashed on
>   one test setup.

I don't quite see why this error is happening.  Looks like all
the nested #includes should handle it...

CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_UTRACE=y
# PTRACE=n
# PROC_FS=n

In file included from arch/x86_64/kernel/crash.c:19:
include/linux/elfcore.h: In function 'elf_core_copy_regs':
include/linux/elfcore.h:103: error: dereferencing pointer to incomplete type
include/linux/elfcore.h:103: error: dereferencing pointer to incomplete type
make[1]: *** [arch/x86_64/kernel/crash.o] Error 1
make: *** [arch/x86_64/kernel] Error 2

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
