Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbYLCVXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbYLCVXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYLCVX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:23:28 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60544 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYLCVX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:23:27 -0500
Date: Wed, 03 Dec 2008 16:23:45 -0500
From: Jody McIntyre <scjody@sun.com>
Subject: Re: [PATCH] Fix compile error in arch/x86/kernel/syscall_64.c
In-reply-to: <4936E96B.6090706@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Message-id: <20081203212345.GD7080@clouds>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
References: <20081202215154.GL29919@clouds> <4936C927.3030504@zytor.com>
 <20081203195022.GA7080@clouds> <4936E96B.6090706@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 12:17:47PM -0800, H. Peter Anvin wrote:

> I was particularly suspicious because you said "one of my systems",
> which implies other systems don't behave that way...

I have one other system that can build this kernel, and one that gets
further.  The differences are gcc version (all distro-supplied),
.config, and in one case X86_32 vs. X86_64.

> Now, the syscall_64.i you sent me is the working version, right?  Could
> you send me the non-working version, too?

That's the non-working version.  I just verified:

root@vm1:~/linux-2.6# make clean && make arch/x86/kernel/syscall_64.o
[...]
  CC      arch/x86/kernel/syscall_64.o
arch/x86/kernel/syscall_64.c:27: error: array index in initializer exceeds array bounds
arch/x86/kernel/syscall_64.c:27: error: (near initialization for ‘sys_call_table’)
arch/x86/kernel/syscall_64.c:27: warning: excess elements in array initializer
arch/x86/kernel/syscall_64.c:27: warning: (near initialization for ‘sys_call_table’)
make[1]: *** [arch/x86/kernel/syscall_64.o] Error 1
make: *** [arch/x86/kernel/syscall_64.o] Error 2
root@vm1:~/linux-2.6# make arch/x86/kernel/syscall_64.i
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CPP     arch/x86/kernel/syscall_64.i

The resulting .i file is identical (checked md5sum) to the one on the
http site: http://downloads.lustre.org/people/scjody/lkml/syscall_64.i

Cheers,
Jody
