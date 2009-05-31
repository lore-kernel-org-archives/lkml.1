Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbZEaEsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbZEaEsD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 00:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZEaEry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 00:47:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZEaErx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 00:47:53 -0400
Date: Sun, 31 May 2009 00:46:50 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jaswinder@kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       rdunlap@xenotime.net, Amerigo Wang <amwang@redhat.com>
Message-Id: <20090531044902.2824.27307.sendpatchset@localhost.localdomain>
Subject: [Patch 1/2] Doc: update Documentation/exception.txt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update Documentation/exception.txt.
Remove trailing whitespaces in it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>

---
Index: linux-2.6/Documentation/exception.txt
===================================================================
--- linux-2.6.orig/Documentation/exception.txt
+++ linux-2.6/Documentation/exception.txt
@@ -1,123 +1,123 @@
-     Kernel level exception handling in Linux 2.1.8
+     Kernel level exception handling in Linux
   Commentary by Joerg Pommnitz <joerg@raleigh.ibm.com>
 
-When a process runs in kernel mode, it often has to access user 
-mode memory whose address has been passed by an untrusted program. 
+When a process runs in kernel mode, it often has to access user
+mode memory whose address has been passed by an untrusted program.
 To protect itself the kernel has to verify this address.
 
-In older versions of Linux this was done with the 
-int verify_area(int type, const void * addr, unsigned long size) 
+In older versions of Linux this was done with the
+int verify_area(int type, const void * addr, unsigned long size)
 function (which has since been replaced by access_ok()).
 
-This function verified that the memory area starting at address 
+This function verified that the memory area starting at address
 'addr' and of size 'size' was accessible for the operation specified
-in type (read or write). To do this, verify_read had to look up the 
-virtual memory area (vma) that contained the address addr. In the 
-normal case (correctly working program), this test was successful. 
+in type (read or write). To do this, verify_read had to look up the
+virtual memory area (vma) that contained the address addr. In the
+normal case (correctly working program), this test was successful.
 It only failed for a few buggy programs. In some kernel profiling
 tests, this normally unneeded verification used up a considerable
 amount of time.
 
-To overcome this situation, Linus decided to let the virtual memory 
+To overcome this situation, Linus decided to let the virtual memory
 hardware present in every Linux-capable CPU handle this test.
 
 How does this work?
 
-Whenever the kernel tries to access an address that is currently not 
-accessible, the CPU generates a page fault exception and calls the 
-page fault handler 
+Whenever the kernel tries to access an address that is currently not
+accessible, the CPU generates a page fault exception and calls the
+page fault handler
 
 void do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
-in arch/i386/mm/fault.c. The parameters on the stack are set up by 
-the low level assembly glue in arch/i386/kernel/entry.S. The parameter
-regs is a pointer to the saved registers on the stack, error_code 
+in arch/x86/mm/fault.c. The parameters on the stack are set up by
+the low level assembly glue in arch/x86/kernel/entry_32.S. The parameter
+regs is a pointer to the saved registers on the stack, error_code
 contains a reason code for the exception.
 
-do_page_fault first obtains the unaccessible address from the CPU 
-control register CR2. If the address is within the virtual address 
-space of the process, the fault probably occurred, because the page 
-was not swapped in, write protected or something similar. However, 
-we are interested in the other case: the address is not valid, there 
-is no vma that contains this address. In this case, the kernel jumps 
-to the bad_area label. 
-
-There it uses the address of the instruction that caused the exception 
-(i.e. regs->eip) to find an address where the execution can continue 
-(fixup). If this search is successful, the fault handler modifies the 
-return address (again regs->eip) and returns. The execution will 
+do_page_fault first obtains the unaccessible address from the CPU
+control register CR2. If the address is within the virtual address
+space of the process, the fault probably occurred, because the page
+was not swapped in, write protected or something similar. However,
+we are interested in the other case: the address is not valid, there
+is no vma that contains this address. In this case, the kernel jumps
+to the bad_area label.
+
+There it uses the address of the instruction that caused the exception
+(i.e. regs->eip) to find an address where the execution can continue
+(fixup). If this search is successful, the fault handler modifies the
+return address (again regs->eip) and returns. The execution will
 continue at the address in fixup.
 
 Where does fixup point to?
 
-Since we jump to the contents of fixup, fixup obviously points 
-to executable code. This code is hidden inside the user access macros. 
-I have picked the get_user macro defined in include/asm/uaccess.h as an
-example. The definition is somewhat hard to follow, so let's peek at 
+Since we jump to the contents of fixup, fixup obviously points
+to executable code. This code is hidden inside the user access macros.
+I have picked the get_user macro defined in arch/x86/include/asm/uaccess.h
+as an example. The definition is somewhat hard to follow, so let's peek at
 the code generated by the preprocessor and the compiler. I selected
-the get_user call in drivers/char/console.c for a detailed examination.
+the get_user call in drivers/char/sysrq.c for a detailed examination.
 
-The original code in console.c line 1405:
+The original code in sysrq.c line 587:
         get_user(c, buf);
 
 The preprocessor output (edited to become somewhat readable):
 
 (
-  {        
-    long __gu_err = - 14 , __gu_val = 0;        
-    const __typeof__(*( (  buf ) )) *__gu_addr = ((buf));        
-    if (((((0 + current_set[0])->tss.segment) == 0x18 )  || 
-       (((sizeof(*(buf))) <= 0xC0000000UL) && 
-       ((unsigned long)(__gu_addr ) <= 0xC0000000UL - (sizeof(*(buf)))))))        
+  {
+    long __gu_err = - 14 , __gu_val = 0;
+    const __typeof__(*( (  buf ) )) *__gu_addr = ((buf));
+    if (((((0 + current_set[0])->tss.segment) == 0x18 )  ||
+       (((sizeof(*(buf))) <= 0xC0000000UL) &&
+       ((unsigned long)(__gu_addr ) <= 0xC0000000UL - (sizeof(*(buf)))))))
       do {
-        __gu_err  = 0;        
-        switch ((sizeof(*(buf)))) {        
-          case 1: 
-            __asm__ __volatile__(        
-              "1:      mov" "b" " %2,%" "b" "1\n"        
-              "2:\n"        
-              ".section .fixup,\"ax\"\n"        
-              "3:      movl %3,%0\n"        
-              "        xor" "b" " %" "b" "1,%" "b" "1\n"        
-              "        jmp 2b\n"        
-              ".section __ex_table,\"a\"\n"        
-              "        .align 4\n"        
-              "        .long 1b,3b\n"        
+        __gu_err  = 0;
+        switch ((sizeof(*(buf)))) {
+          case 1:
+            __asm__ __volatile__(
+              "1:      mov" "b" " %2,%" "b" "1\n"
+              "2:\n"
+              ".section .fixup,\"ax\"\n"
+              "3:      movl %3,%0\n"
+              "        xor" "b" " %" "b" "1,%" "b" "1\n"
+              "        jmp 2b\n"
+              ".section __ex_table,\"a\"\n"
+              "        .align 4\n"
+              "        .long 1b,3b\n"
               ".text"        : "=r"(__gu_err), "=q" (__gu_val): "m"((*(struct __large_struct *)
-                            (   __gu_addr   )) ), "i"(- 14 ), "0"(  __gu_err  )) ; 
-              break;        
-          case 2: 
+                            (   __gu_addr   )) ), "i"(- 14 ), "0"(  __gu_err  )) ;
+              break;
+          case 2:
             __asm__ __volatile__(
-              "1:      mov" "w" " %2,%" "w" "1\n"        
-              "2:\n"        
-              ".section .fixup,\"ax\"\n"        
-              "3:      movl %3,%0\n"        
-              "        xor" "w" " %" "w" "1,%" "w" "1\n"        
-              "        jmp 2b\n"        
-              ".section __ex_table,\"a\"\n"        
-              "        .align 4\n"        
-              "        .long 1b,3b\n"        
+              "1:      mov" "w" " %2,%" "w" "1\n"
+              "2:\n"
+              ".section .fixup,\"ax\"\n"
+              "3:      movl %3,%0\n"
+              "        xor" "w" " %" "w" "1,%" "w" "1\n"
+              "        jmp 2b\n"
+              ".section __ex_table,\"a\"\n"
+              "        .align 4\n"
+              "        .long 1b,3b\n"
               ".text"        : "=r"(__gu_err), "=r" (__gu_val) : "m"((*(struct __large_struct *)
-                            (   __gu_addr   )) ), "i"(- 14 ), "0"(  __gu_err  )); 
-              break;        
-          case 4: 
-            __asm__ __volatile__(        
-              "1:      mov" "l" " %2,%" "" "1\n"        
-              "2:\n"        
-              ".section .fixup,\"ax\"\n"        
-              "3:      movl %3,%0\n"        
-              "        xor" "l" " %" "" "1,%" "" "1\n"        
-              "        jmp 2b\n"        
-              ".section __ex_table,\"a\"\n"        
-              "        .align 4\n"        "        .long 1b,3b\n"        
+                            (   __gu_addr   )) ), "i"(- 14 ), "0"(  __gu_err  ));
+              break;
+          case 4:
+            __asm__ __volatile__(
+              "1:      mov" "l" " %2,%" "" "1\n"
+              "2:\n"
+              ".section .fixup,\"ax\"\n"
+              "3:      movl %3,%0\n"
+              "        xor" "l" " %" "" "1,%" "" "1\n"
+              "        jmp 2b\n"
+              ".section __ex_table,\"a\"\n"
+              "        .align 4\n"        "        .long 1b,3b\n"
               ".text"        : "=r"(__gu_err), "=r" (__gu_val) : "m"((*(struct __large_struct *)
-                            (   __gu_addr   )) ), "i"(- 14 ), "0"(__gu_err)); 
-              break;        
-          default: 
-            (__gu_val) = __get_user_bad();        
-        }        
-      } while (0) ;        
-    ((c)) = (__typeof__(*((buf))))__gu_val;        
+                            (   __gu_addr   )) ), "i"(- 14 ), "0"(__gu_err));
+              break;
+          default:
+            (__gu_val) = __get_user_bad();
+        }
+      } while (0) ;
+    ((c)) = (__typeof__(*((buf))))__gu_val;
     __gu_err;
   }
 );
@@ -127,12 +127,12 @@ see what code gcc generates:
 
  >         xorl %edx,%edx
  >         movl current_set,%eax
- >         cmpl $24,788(%eax)        
- >         je .L1424        
+ >         cmpl $24,788(%eax)
+ >         je .L1424
  >         cmpl $-1073741825,64(%esp)
- >         ja .L1423                
+ >         ja .L1423
  > .L1424:
- >         movl %edx,%eax                        
+ >         movl %edx,%eax
  >         movl 64(%esp),%ebx
  > #APP
  > 1:      movb (%ebx),%dl                /* this is the actual user access */
@@ -149,17 +149,17 @@ see what code gcc generates:
  > .L1423:
  >         movzbl %dl,%esi
 
-The optimizer does a good job and gives us something we can actually 
-understand. Can we? The actual user access is quite obvious. Thanks 
-to the unified address space we can just access the address in user 
+The optimizer does a good job and gives us something we can actually
+understand. Can we? The actual user access is quite obvious. Thanks
+to the unified address space we can just access the address in user
 memory. But what does the .section stuff do?????
 
 To understand this we have to look at the final kernel:
 
  > objdump --section-headers vmlinux
- > 
+ >
  > vmlinux:     file format elf32-i386
- > 
+ >
  > Sections:
  > Idx Name          Size      VMA       LMA       File off  Algn
  >   0 .text         00098f40  c0100000  c0100000  00001000  2**4
@@ -198,18 +198,18 @@ final kernel executable:
 
 The whole user memory access is reduced to 10 x86 machine instructions.
 The instructions bracketed in the .section directives are no longer
-in the normal execution path. They are located in a different section 
+in the normal execution path. They are located in a different section
 of the executable file:
 
  > objdump --disassemble --section=.fixup vmlinux
- > 
+ >
  > c0199ff5 <.fixup+10b5> movl   $0xfffffff2,%eax
  > c0199ffa <.fixup+10ba> xorb   %dl,%dl
  > c0199ffc <.fixup+10bc> jmp    c017e7a7 <do_con_write+e3>
 
 And finally:
  > objdump --full-contents --section=__ex_table vmlinux
- > 
+ >
  >  c01aa7c4 93c017c0 e09f19c0 97c017c0 99c017c0  ................
  >  c01aa7d4 f6c217c0 e99f19c0 a5e717c0 f59f19c0  ................
  >  c01aa7e4 080a18c0 01a019c0 0a0a18c0 04a019c0  ................
@@ -235,8 +235,8 @@ sections in the ELF object file. So the 
 ended up in the .fixup section of the object file and the addresses
         .long 1b,3b
 ended up in the __ex_table section of the object file. 1b and 3b
-are local labels. The local label 1b (1b stands for next label 1 
-backward) is the address of the instruction that might fault, i.e. 
+are local labels. The local label 1b (1b stands for next label 1
+backward) is the address of the instruction that might fault, i.e.
 in our case the address of the label 1 is c017e7a5:
 the original assembly code: > 1:      movb (%ebx),%dl
 and linked in vmlinux     : > c017e7a5 <do_con_write+e1> movb   (%ebx),%dl
@@ -254,7 +254,7 @@ The assembly code
 becomes the value pair
  >  c01aa7d4 c017c2f6 c0199fe9 c017e7a5 c0199ff5  ................
                                ^this is ^this is
-                               1b       3b 
+                               1b       3b
 c017e7a5,c0199ff5 in the exception table of the kernel.
 
 So, what actually happens if a fault from kernel mode with no suitable
@@ -266,9 +266,9 @@ vma occurs?
 3.) CPU calls do_page_fault
 4.) do page fault calls search_exception_table (regs->eip == c017e7a5);
 5.) search_exception_table looks up the address c017e7a5 in the
-    exception table (i.e. the contents of the ELF section __ex_table) 
+    exception table (i.e. the contents of the ELF section __ex_table)
     and returns the address of the associated fault handle code c0199ff5.
-6.) do_page_fault modifies its own return address to point to the fault 
+6.) do_page_fault modifies its own return address to point to the fault
     handle code and returns.
 7.) execution continues in the fault handling code.
 8.) 8a) EAX becomes -EFAULT (== -14)
