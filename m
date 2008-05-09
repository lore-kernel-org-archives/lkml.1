Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbYEIRbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbYEIRbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbYEIRbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:31:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45288 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbYEIRbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:31:05 -0400
Date: Fri, 9 May 2008 10:28:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>, samr <sam@ravnborg.org>
Subject: next-20080509 build fails with CONFIG_SYSFS=n
Message-Id: <20080509102817.3a885147.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't get 20080509 to build with SYSFS=n.
(on x86_64 or i386)

Problem is building asm-offsets.c.


  GEN     /local/linsrc/next-20080509/X64/Makefile
scripts/kconfig/conf -s arch/x86/Kconfig
  Using /local/linsrc/next-20080509 as source for kernel
  GEN     /local/linsrc/next-20080509/X64/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/linux/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from /local/linsrc/next-20080509/include/linux/kobject.h:21,
                 from /local/linsrc/next-20080509/include/linux/module.h:16,
                 from /local/linsrc/next-20080509/include/linux/crypto.h:21,
                 from /local/linsrc/next-20080509/arch/x86/kernel/asm-offsets_64.c:7,
                 from /local/linsrc/next-20080509/arch/x86/kernel/asm-offsets.c:4:
/local/linsrc/next-20080509/include/linux/sysfs.h: In function 'sysfs_rename_dir':
/local/linsrc/next-20080509/include/linux/sysfs.h:142: error: implicit declaration of function 'kobject_set_name'
In file included from /local/linsrc/next-20080509/include/linux/module.h:16,
                 from /local/linsrc/next-20080509/include/linux/crypto.h:21,
                 from /local/linsrc/next-20080509/arch/x86/kernel/asm-offsets_64.c:7,
                 from /local/linsrc/next-20080509/arch/x86/kernel/asm-offsets.c:4:
/local/linsrc/next-20080509/include/linux/kobject.h: At top level:
/local/linsrc/next-20080509/include/linux/kobject.h:74: error: conflicting types for 'kobject_set_name'
/local/linsrc/next-20080509/include/linux/kobject.h:74: note: a parameter list with an ellipsis can't match an empty parameter name list declaration
/local/linsrc/next-20080509/include/linux/sysfs.h:142: error: previous implicit declaration of 'kobject_set_name' was here
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [sub-make] Error 2

---
~Randy
