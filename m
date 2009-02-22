Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbZBVWHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbZBVWHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZBVWHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:07:40 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:36122 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZBVWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Xt+m9E2Z7jz3Rpyd8KHJGdyRqLKWLS7+adJrlF4IMZtnO+KRtVwbvm/mm2Klxuxoa2
         s8x1j8Di42OtWro0094TVHzp8AHpVFFoyzWxn/Ctn+7iBa8C6qGegww0DYmqREYHvVSV
         uTeEP0s/xZkTJeCqtjBoUWUlyNVQCz47rTjrw=
Date: Mon, 23 Feb 2009 01:07:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: kernel building procedure changed?
Message-ID: <20090222220747.GB7279@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I found a bit strange thing happens now --
plain

	make arch/x86/kernel/head64.o

doesn't work anymore. Instead of compiling
_just_ this file I've got the following:

---
cyrill@lenovo linux-2.6.git $ make arch/x86/kernel/head64.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  AS      arch/x86/kernel/head_64.o
  VDSOSYM arch/x86/vdso/vdso-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  CC      fs/hpfs/dnode.o
make[2]: *** [fs/hpfs/dnode.o] Interrupt
make[1]: *** [fs/hpfs] Interrupt
make: *** [fs] Interrupt
---

I've done make allyesconfig previously.
I don't understand what I'm doing wrong... :(
Really need help. The commit is:

---
commit c8f0da62a813f3ea8ceab574438afb90d428de36
Merge: b95dcd2... 8f5bd50...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun Feb 22 20:08:44 2009 +0100

    manual merge of kmemcheck
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

As I understand hpfs completely unrelated to
head64.o, right?

Sam, Ingo, what I'm doing wrong? Please help :)

	- Cyrill -
