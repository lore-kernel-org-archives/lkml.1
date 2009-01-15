Return-Path: <linux-kernel-owner+w=401wt.eu-S1763645AbZAOLlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763645AbZAOLlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZAOLle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:41:34 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:1494 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbZAOLld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:41:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HElPYg0TcskAz/IKAldKaAFC9sriV+F+W9QHoodOzDZUJ5l2eKaJAYCQF+LhEzR1TY
         J/qIRCkPC67sRk5kOiXxn6e39GNxi5W7YMwS4bXuqZvtaVS996UuyqM7Kp00gFkyhgXK
         6+0K3MJRFr01lTyLHY849SsIRQ7Vlb+EOqMK0=
Date: Thu, 15 Jan 2009 19:40:33 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@osdl.org>
Subject: [Patch] uml: fix a link error
Message-ID: <20090115194033.GA10926@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the following link error:

  LD      .tmp_vmlinux1                                             
  arch/um/sys-i386/built-in.o: In function sys_call_table':          
  (.rodata+0x308): undefined reference to sys_sigprocmask'           
  collect2: ld returned 1 exit status                                 
   KSYM    .tmp_kallsyms1.S                                          
   nm: '.tmp_vmlinux1': No such file                                   
   AS      .tmp_kallsyms1.o                                          
   LD      .tmp_vmlinux2 
   arch/um/sys-i386/built-in.o: In function sys_call_table':  
  (.rodata+0x308): undefined reference to sys_sigprocmask'  
  collect2: ld returned 1 exit status   
  make[1]: *** [.tmp_vmlinux2] Error 1   
  make: *** [sub-make] Error 2                               


Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>

---
diff --git a/arch/um/sys-i386/sys_call_table.S b/arch/um/sys-i386/sys_call_table.S
index 00e5f52..04147dc 100644
--- a/arch/um/sys-i386/sys_call_table.S
+++ b/arch/um/sys-i386/sys_call_table.S
@@ -6,6 +6,7 @@
 
 #define sys_vm86old sys_ni_syscall
 #define sys_vm86 sys_ni_syscall
+#define sys_sigprocmask sigprocmask
 
 #define old_mmap old_mmap_i386
 






