Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbYB0VCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbYB0VCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbYB0VAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:00:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:11691 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191AbYB0VAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:00:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=H4LogMCyiM8/ZtS9bMRE/Hh5S2Q5sZeut+13VaWKnS/76yjnJaJF9VhLZNh91Yg9LNytQ9vToKToBwatKWfL1MUbPVxDvT0xfGftP63qmb0PyQ/Mf4GLJux9lsa5mGq0WuEGmcaBDZ6JrgSaceSLI7Eo+MbGXWMZLXEgNugeEc8=
Message-Id: <20080227210003.957010343@gmail.com>
References: <20080227205831.150784453@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 Feb 2008 23:58:38 +0300
From: gorcunov@gmail.com
To: rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dhowells@redhat.com,
       zippel@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org
Subject: [RFC 07/10] ppc: vmlinux.lds.S cleanup - use PAGE_SIZE macro
Content-Disposition: inline; filename=ppc-vmlinux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes page.h header into liker script that
allow us to use PAGE_SIZE macro instead of numeric constant

Also a few tabs deleted to align braces

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

WARNING: COMPLETELY UNTESTED !!!

 vmlinux.lds.S |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

Index: linux-2.6.git/arch/ppc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/ppc/kernel/vmlinux.lds.S	2008-02-07 17:22:25.000000000 +0300
+++ linux-2.6.git/arch/ppc/kernel/vmlinux.lds.S	2008-02-27 21:36:35.000000000 +0300
@@ -1,4 +1,5 @@
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_ARCH(powerpc:common)
 jiffies = jiffies_64 + 4;
@@ -11,22 +12,22 @@ SECTIONS
   .gnu.hash      : { *(.gnu.hash)	}
   .dynsym        : { *(.dynsym)		}
   .dynstr        : { *(.dynstr)		}
-  .rel.text      : { *(.rel.text)		}
+  .rel.text      : { *(.rel.text)	}
   .rela.text     : { *(.rela.text) 	}
-  .rel.data      : { *(.rel.data)		}
+  .rel.data      : { *(.rel.data)	}
   .rela.data     : { *(.rela.data) 	}
   .rel.rodata    : { *(.rel.rodata) 	}
   .rela.rodata   : { *(.rela.rodata) 	}
-  .rel.got       : { *(.rel.got)		}
-  .rela.got      : { *(.rela.got)		}
+  .rel.got       : { *(.rel.got)	}
+  .rela.got      : { *(.rela.got)	}
   .rel.ctors     : { *(.rel.ctors)	}
   .rela.ctors    : { *(.rela.ctors)	}
   .rel.dtors     : { *(.rel.dtors)	}
   .rela.dtors    : { *(.rela.dtors)	}
-  .rel.bss       : { *(.rel.bss)		}
-  .rela.bss      : { *(.rela.bss)		}
-  .rel.plt       : { *(.rel.plt)		}
-  .rela.plt      : { *(.rela.plt)		}
+  .rel.bss       : { *(.rel.bss)	}
+  .rela.bss      : { *(.rela.bss)	}
+  .rel.plt       : { *(.rel.plt)	}
+  .rela.plt      : { *(.rela.plt)	}
 /*  .init          : { *(.init)	} =0*/
   .plt : { *(.plt) }
   .text      :
@@ -64,7 +65,7 @@ SECTIONS
 	}
 
   /* Read-write section, merged into data segment: */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data    :
   {
     DATA_DATA
@@ -76,10 +77,10 @@ SECTIONS
     CONSTRUCTORS
   }
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __nosave_begin = .;
   .data_nosave : { *(.data.nosave) }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
   . = ALIGN(32);
@@ -88,12 +89,12 @@ SECTIONS
   _edata  =  .;
   PROVIDE (edata = .);
 
-  . = ALIGN(8192);
+  . = ALIGN(2 * PAGE_SIZE);
   .data.init_task : { *(.data.init_task) }
 
   NOTES
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __init_begin = .;
   .init.text : {
 	_sinittext = .;
@@ -132,16 +133,16 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  PERCPU(4096)
+  PERCPU(PAGE_SIZE)
 
 #ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __init_end = .;
   __bss_start = .;
   .bss       :

-- 
