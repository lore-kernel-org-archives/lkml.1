Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYFIUmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYFIUmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYFIUmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:42:32 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37654 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506AbYFIUmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:42:31 -0400
To: akpm@linuxfoundation.org, peter.oberparleiter@de.ibm.com
CC: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: 2.6.26-rc5-mm1: uml link error
Message-Id: <E1K5oBn-0006v4-KJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 09 Jun 2008 22:42:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this error on linking uml:

/usr/lib64/gcc/x86_64-suse-linux/4.2.1/../../../../x86_64-suse-linux/bin/ld:arch/um/kernel/vmlinux.lds:267: syntax error

Reverting 'kernel-call-constructors.patch' fixes it.

> diff -u arch/um/kernel/vmlinux.lds.bad arch/um/kernel/vmlinux.lds
--- arch/um/kernel/vmlinux.lds.bad      2008-06-09 22:35:57.000000000 +0200
+++ arch/um/kernel/vmlinux.lds  2008-06-09 22:36:07.000000000 +0200
@@ -264,7 +264,7 @@
     *(.data.init_irqstack)
     *(.data) *(.data.init.refok) *(.ref.data) *(.devinit.data) *(.devexit.data) . = ALIGN(8); __start___markers = .; *(__markers) __stop___markers = .;
     *(.data.* .gnu.linkonce.d.*)
-    SORT(__ctor_start = .; *(.ctors) __ctor_end = .;)
+    SORT(CONSTRUCTORS)
   }
   .data1 : { *(.data1) }
   .tdata : { *(.tdata .tdata.* .gnu.linkonce.td.*) }

Unintended macro substitution?

Thanks,
Miklos
