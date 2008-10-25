Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbYJYBKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbYJYBKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 21:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYJYBKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 21:10:10 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60860 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYJYBKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 21:10:08 -0400
To: stern@rowland.harvard.edu
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27.3 usbcore] Move __module_param_call(nousb) to immediately after declaration of nousb.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200810250026.EGB05240.HJtQFOMSOVOFFL@I-love.SAKURA.ne.jp>
	<Pine.LNX.4.44L0.0810241217500.2180-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810241217500.2180-100000@iolanthe.rowland.org>
Message-Id: <200810251010.CHE87503.tSJMOOQVLFFOFH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 25 Oct 2008 10:10:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried on Fedora 9 (gcc (GCC) 4.3.0 20080428 (Red Hat 4.3.0-8)),
and I got the same result.

Just applying http://lkml.org/lkml/diff/2008/10/24/240/1 :
----------------------------------------
# cat /proc/version
Linux version 2.6.27.3 (root@tomoyo) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Sat Oct 25 09:30:00 JST 2008
# ls -ail /sys/module/paramtest/parameters/
total 0
201 drwxr-xr-x 2 root root    0 2008-10-25 09:33 .
200 drwxr-xr-x 3 root root    0 2008-10-25 09:33 ..
206 -r--r--r-- 1 root root 4096 2008-10-25 09:33 param2
205 -rw-r--r-- 1 root root 4096 2008-10-25 09:33 param3
204 -rw-r--r-- 1 root root 4096 2008-10-25 09:33 param4
202 -rw-r--r-- 1 root root 4096 2008-10-25 09:33 paramtest
203 -r--r--r-- 1 root root 4096 2008-10-25 09:33 ramtest.param4
----------------------------------------

Also applying http://lkml.org/lkml/diff/2008/10/24/240/2 :
----------------------------------------
# cat /proc/version
Linux version 2.6.27.3 (root@tomoyo) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #2 SMP Sat Oct 25 09:35:07 JST 2008
[root@tomoyo ~]# ls -ail /sys/module/paramtest/parameters/
total 0
201 drwxr-xr-x 2 root root    0 2008-10-25 09:42 .
200 drwxr-xr-x 3 root root    0 2008-10-25 09:42 ..
206 -rw-r--r-- 1 root root 4096 2008-10-25 09:42 param1
205 -r--r--r-- 1 root root 4096 2008-10-25 09:42 param2
204 -rw-r--r-- 1 root root 4096 2008-10-25 09:42 param3
203 -rw-r--r-- 1 root root 4096 2008-10-25 09:42 param4
202 -rw-r--r-- 1 root root 4096 2008-10-25 09:42 paramtest
----------------------------------------

Alan Stern wrote:
> Why don't you simply look at the output from the compiler?  Either the 
> .o file or else the intermediate .s file.

Here are output of 'objdump -x drivers/usb/paramtest.o'.
----------------------------------------
# cat diff1only

paramtest.o:     file format elf32-i386
paramtest.o
architecture: i386, flags 0x00000011:
HAS_RELOC, HAS_SYMS
start address 0x00000000

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000000  00000000  00000000  00000034  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000000  00000000  00000000  00000034  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000018  00000000  00000000  00000034  2**2
                  ALLOC
  3 .init.text    0000000c  00000000  00000000  00000034  2**0
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  4 .exit.text    0000000a  00000000  00000000  00000040  2**0
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  5 .exitcall.exit 00000004  00000000  00000000  0000004c  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
  6 .initcall4.init 00000004  00000000  00000000  00000050  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
  7 __param       00000078  00000000  00000000  00000054  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
  8 .rodata       00000069  00000000  00000000  000000cc  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  9 .comment      0000002d  00000000  00000000  00000135  2**0
                  CONTENTS, READONLY
 10 .note.GNU-stack 00000000  00000000  00000000  00000162  2**0
                  CONTENTS, READONLY
SYMBOL TABLE:
00000000 l    df *ABS*  00000000 paramtest.c
00000000 l    d  .text  00000000 .text
00000000 l    d  .data  00000000 .data
00000000 l    d  .bss   00000000 .bss
00000000 l    d  .init.text     00000000 .init.text
00000000 l     F .init.text     0000000c paramtest_init
00000000 l    d  .exit.text     00000000 .exit.text
00000000 l     F .exit.text     0000000a paramtest_exit
00000000 l    d  .exitcall.exit 00000000 .exitcall.exit
00000000 l     O .exitcall.exit 00000004 __exitcall_paramtest_exit
00000000 l    d  .initcall4.init        00000000 .initcall4.init
00000000 l     O .initcall4.init        00000004 __initcall_paramtest_init4
00000000 l    d  __param        00000000 __param
00000000 l     O __param        00000014 __param_paramtest
00000000 l     O .rodata        00000014 __param_str_paramtest
00000000 l     O .bss   00000004 param6
00000014 l     O __param        00000014 __param_param5
00000014 l     O .rodata        00000007 __param_str_param5
00000004 l     O .bss   00000004 param5
00000028 l     O __param        00000014 __param_param4
0000001c l     O .rodata        00000011 __param_str_param4
00000008 l     O .bss   00000004 param4
0000003c l     O __param        00000014 __param_param3
00000030 l     O .rodata        00000011 __param_str_param3
0000000c l     O .bss   00000004 param3
00000050 l     O __param        00000014 __param_param2
00000044 l     O .rodata        00000011 __param_str_param2
00000010 l     O .bss   00000004 param2
00000064 l     O __param        00000014 __param_param1
00000058 l     O .rodata        00000011 __param_str_param1
00000014 l     O .bss   00000004 param1
00000000 l    d  .rodata        00000000 .rodata
00000000 l    d  .note.GNU-stack        00000000 .note.GNU-stack
00000000 l    d  .comment       00000000 .comment
00000000         *UND*  00000000 mcount
00000000         *UND*  00000000 param_set_int
00000000         *UND*  00000000 param_get_int
00000000         *UND*  00000000 param_set_bool
00000000         *UND*  00000000 param_get_bool


RELOCATION RECORDS FOR [.init.text]:
OFFSET   TYPE              VALUE
00000004 R_386_PC32        mcount


RELOCATION RECORDS FOR [.exit.text]:
OFFSET   TYPE              VALUE
00000004 R_386_PC32        mcount


RELOCATION RECORDS FOR [.exitcall.exit]:
OFFSET   TYPE              VALUE
00000000 R_386_32          .exit.text


RELOCATION RECORDS FOR [.initcall4.init]:
OFFSET   TYPE              VALUE
00000000 R_386_32          .init.text


RELOCATION RECORDS FOR [__param]:
OFFSET   TYPE              VALUE
00000000 R_386_32          .rodata
00000008 R_386_32          param_set_int
0000000c R_386_32          param_get_int
00000010 R_386_32          .bss
00000014 R_386_32          .rodata
0000001c R_386_32          param_set_bool
00000020 R_386_32          param_get_bool
00000024 R_386_32          .bss
00000028 R_386_32          .rodata
00000030 R_386_32          param_set_bool
00000034 R_386_32          param_get_bool
00000038 R_386_32          .bss
0000003c R_386_32          .rodata
00000044 R_386_32          param_set_bool
00000048 R_386_32          param_get_bool
0000004c R_386_32          .bss
00000050 R_386_32          .rodata
00000058 R_386_32          param_set_bool
0000005c R_386_32          param_get_bool
00000060 R_386_32          .bss
00000064 R_386_32          .rodata
0000006c R_386_32          param_set_bool
00000070 R_386_32          param_get_bool
00000074 R_386_32          .bss
----------------------------------------
# cat diff1and2

paramtest.o:     file format elf32-i386
paramtest.o
architecture: i386, flags 0x00000011:
HAS_RELOC, HAS_SYMS
start address 0x00000000

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000000  00000000  00000000  00000034  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000000  00000000  00000000  00000034  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000018  00000000  00000000  00000034  2**2
                  ALLOC
  3 .init.text    0000000c  00000000  00000000  00000034  2**0
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  4 .exit.text    0000000a  00000000  00000000  00000040  2**0
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  5 .exitcall.exit 00000004  00000000  00000000  0000004c  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
  6 .initcall4.init 00000004  00000000  00000000  00000050  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
  7 __param       00000078  00000000  00000000  00000054  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
  8 .rodata       00000069  00000000  00000000  000000cc  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  9 .comment      0000002d  00000000  00000000  00000135  2**0
                  CONTENTS, READONLY
 10 .note.GNU-stack 00000000  00000000  00000000  00000162  2**0
                  CONTENTS, READONLY
SYMBOL TABLE:
00000000 l    df *ABS*  00000000 paramtest.c
00000000 l    d  .text  00000000 .text
00000000 l    d  .data  00000000 .data
00000000 l    d  .bss   00000000 .bss
00000000 l    d  .init.text     00000000 .init.text
00000000 l     F .init.text     0000000c paramtest_init
00000000 l    d  .exit.text     00000000 .exit.text
00000000 l     F .exit.text     0000000a paramtest_exit
00000000 l    d  .exitcall.exit 00000000 .exitcall.exit
00000000 l     O .exitcall.exit 00000004 __exitcall_paramtest_exit
00000000 l    d  .initcall4.init        00000000 .initcall4.init
00000000 l     O .initcall4.init        00000004 __initcall_paramtest_init4
00000000 l    d  __param        00000000 __param
00000000 l     O __param        00000014 __param_param5
00000000 l     O .rodata        00000007 __param_str_param5
00000000 l     O .bss   00000004 param5
00000014 l     O __param        00000014 __param_paramtest
00000008 l     O .rodata        00000014 __param_str_paramtest
00000004 l     O .bss   00000004 param6
00000028 l     O __param        00000014 __param_param4
0000001c l     O .rodata        00000011 __param_str_param4
00000008 l     O .bss   00000004 param4
0000003c l     O __param        00000014 __param_param3
00000030 l     O .rodata        00000011 __param_str_param3
0000000c l     O .bss   00000004 param3
00000050 l     O __param        00000014 __param_param2
00000044 l     O .rodata        00000011 __param_str_param2
00000010 l     O .bss   00000004 param2
00000064 l     O __param        00000014 __param_param1
00000058 l     O .rodata        00000011 __param_str_param1
00000014 l     O .bss   00000004 param1
00000000 l    d  .rodata        00000000 .rodata
00000000 l    d  .note.GNU-stack        00000000 .note.GNU-stack
00000000 l    d  .comment       00000000 .comment
00000000         *UND*  00000000 mcount
00000000         *UND*  00000000 param_set_bool
00000000         *UND*  00000000 param_get_bool
00000000         *UND*  00000000 param_set_int
00000000         *UND*  00000000 param_get_int


RELOCATION RECORDS FOR [.init.text]:
OFFSET   TYPE              VALUE
00000004 R_386_PC32        mcount


RELOCATION RECORDS FOR [.exit.text]:
OFFSET   TYPE              VALUE
00000004 R_386_PC32        mcount


RELOCATION RECORDS FOR [.exitcall.exit]:
OFFSET   TYPE              VALUE
00000000 R_386_32          .exit.text


RELOCATION RECORDS FOR [.initcall4.init]:
OFFSET   TYPE              VALUE
00000000 R_386_32          .init.text


RELOCATION RECORDS FOR [__param]:
OFFSET   TYPE              VALUE
00000000 R_386_32          .rodata
00000008 R_386_32          param_set_bool
0000000c R_386_32          param_get_bool
00000010 R_386_32          .bss
00000014 R_386_32          .rodata
0000001c R_386_32          param_set_int
00000020 R_386_32          param_get_int
00000024 R_386_32          .bss
00000028 R_386_32          .rodata
00000030 R_386_32          param_set_bool
00000034 R_386_32          param_get_bool
00000038 R_386_32          .bss
0000003c R_386_32          .rodata
00000044 R_386_32          param_set_bool
00000048 R_386_32          param_get_bool
0000004c R_386_32          .bss
00000050 R_386_32          .rodata
00000058 R_386_32          param_set_bool
0000005c R_386_32          param_get_bool
00000060 R_386_32          .bss
00000064 R_386_32          .rodata
0000006c R_386_32          param_set_bool
00000070 R_386_32          param_get_bool
00000074 R_386_32          .bss
----------------------------------------
# diff diff1only diff1and2
46,51c46,51
< 00000000 l     O __param      00000014 __param_paramtest
< 00000000 l     O .rodata      00000014 __param_str_paramtest
< 00000000 l     O .bss 00000004 param6
< 00000014 l     O __param      00000014 __param_param5
< 00000014 l     O .rodata      00000007 __param_str_param5
< 00000004 l     O .bss 00000004 param5
---
> 00000000 l     O __param      00000014 __param_param5
> 00000000 l     O .rodata      00000007 __param_str_param5
> 00000000 l     O .bss 00000004 param5
> 00000014 l     O __param      00000014 __param_paramtest
> 00000008 l     O .rodata      00000014 __param_str_paramtest
> 00000004 l     O .bss 00000004 param6
68,69d67
< 00000000         *UND*        00000000 param_set_int
< 00000000         *UND*        00000000 param_get_int
71a70,71
> 00000000         *UND*        00000000 param_set_int
> 00000000         *UND*        00000000 param_get_int
97,98c97,98
< 00000008 R_386_32          param_set_int
< 0000000c R_386_32          param_get_int
---
> 00000008 R_386_32          param_set_bool
> 0000000c R_386_32          param_get_bool
101,102c101,102
< 0000001c R_386_32          param_set_bool
< 00000020 R_386_32          param_get_bool
---
> 0000001c R_386_32          param_set_int
> 00000020 R_386_32          param_get_int
----------------------------------------

I think the possible causes are either

 (a) my patch is incorrect.
 (b) symbol table handling is incorrect.

So, please check http://lkml.org/lkml/diff/2008/10/24/240/1 .

Regards.
