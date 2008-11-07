Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYKGSLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYKGSLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYKGSLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:11:23 -0500
Received: from smtp-out-45.synserver.de ([217.119.50.45]:1075 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751364AbYKGSLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:11:22 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 31728
Date: Fri, 7 Nov 2008 19:11:17 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Subject: [arch/x86/vdso/vdso32-syms.lds] Error 1
Message-ID: <20081107181117.GA29006@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of a sudden I get the following error when I build the kernel:

  CC      arch/x86/vdso/vma.o
  LDS     arch/x86/vdso/vdso.lds
  AS      arch/x86/vdso/vdso-note.o
  CC      arch/x86/vdso/vclock_gettime.o
  CC      arch/x86/vdso/vgetcpu.o
  CC      arch/x86/vdso/vvar.o
  VDSO    arch/x86/vdso/vdso.so.dbg
  OBJCOPY arch/x86/vdso/vdso.so
  AS      arch/x86/vdso/vdso.o
  LDS     arch/x86/vdso/vdso32/vdso32.lds
  AS      arch/x86/vdso/vdso32/note.o
  AS      arch/x86/vdso/vdso32/int80.o
  VDSO    arch/x86/vdso/vdso32-int80.so.dbg
  OBJCOPY arch/x86/vdso/vdso32-int80.so
  AS      arch/x86/vdso/vdso32/syscall.o
  VDSO    arch/x86/vdso/vdso32-syscall.so.dbg
  OBJCOPY arch/x86/vdso/vdso32-syscall.so
  AS      arch/x86/vdso/vdso32/sysenter.o
  VDSO    arch/x86/vdso/vdso32-sysenter.so.dbg
  OBJCOPY arch/x86/vdso/vdso32-sysenter.so
  AS      arch/x86/vdso/vdso32.o
  CC      arch/x86/vdso/vdso32-setup.o
  VDSOSYM arch/x86/vdso/vdso-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
--- -   2008-11-07 18:51:36.392997346 +0100
+++ arch/x86/vdso/vdso32-int80-syms.lds 2008-11-07 18:51:36.283820343 +0100
@@ -3,5 +3,3 @@
 VDSO32_sigreturn = 0x0400;
 VDSO32_vsyscall = 0x0420;
 VDSO32_vsyscall_eh_frame_size = 0x040;
-VDSO32_vsyscall = 0x0420;
-VDSO32_vsyscall_eh_frame_size = 0x040;
make[1]: *** [arch/x86/vdso/vdso32-syms.lds] Error 1
make: *** [arch/x86/vdso] Error 2

When I edit arch/x86/vdso/Makefile as follows,

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 4d6ef0a..8d93123 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -107,7 +107,7 @@ define cmd_vdso32sym
 		     else sed /VDSO32_SYSENTER_RETURN/d $(@D)/.tmp_$(@F) | \
 			  diff -u - $H; fi &&) : ;\
 	then mv -f $(@D)/.tmp_$(@F) $@; \
-	else rm -f $(@D)/.tmp_$(@F); exit 1; \
+	else mv -f $(@D)/.tmp_$(@F) $@; \
 	fi
 endef
 
the kernel builds and runs just fine.

A least one other person has hit the same problem already:
http://bugzilla.kernel.org/show_bug.cgi?id=11739

Any hints?

-- 
Markus
