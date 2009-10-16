Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZJPFkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZJPFkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 01:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZJPFkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 01:40:02 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:62109 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZJPFjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 01:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b94rLHcwLP3lASAvoM/tRbTdvCqNhEeSSBTVQUmIrVpHYEMQIw28towkRYUW1nksCI
         cB/emAsmfcB39lvWGy7ZUMJADdl3HCccC82lHEofeJG6oua9bu1Ja8EnKnPpcqx3XPHn
         kbzCDiXLW1+Yrp4R7H6ROe1rB4VLvqVnJems4=
MIME-Version: 1.0
In-Reply-To: <tnxfx9l9c0t.fsf@pc1117.cambridge.arm.com>
References: <804dabb00910142027r7f771ee4n2855fef7dcffbacc@mail.gmail.com>
	 <tnxfx9l9c0t.fsf@pc1117.cambridge.arm.com>
Date: Fri, 16 Oct 2009 13:39:17 +0800
Message-ID: <804dabb00910152239m735708fai520abf6a39ab77e2@mail.gmail.com>
Subject: Re: kmemleak errors
From: Peter Teoh <htmldeveloper@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 6:39 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Peter Teoh <htmldeveloper@gmail.com> wrote:
>> cat /sys/kernel/debug/kmemleak gave:
>>
>> unreferenced object 0xffff8800bd864000 (size 40):
>>   comm "swapper", pid 0, jiffies 4294937296
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 70 40 86 bd 00 88 ff ff  ........p@......
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
>>     [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
>>     [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
>>     [<ffffffff82afef26>] start_kernel+0x356/0x414
>>     [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
>>     [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
>>     [<ffffffffffffffff>] 0xffffffffffffffff
>
> If run
>
>  echo scan > /sys/kernel/debug/kmemleak
>

sorry, i have overwritten the kernel image to follow up on another
kernel bugzilla report.   but on another (32bit Fedora Core10) the
following is the kmemleak output (scan > /sys/kernel/debug/kmemleak is
done at least thrice) and the following output remained exactly not
changed - not even a single byte modified:

unreferenced object 0xf70320a0 (size 32):
  comm "swapper", pid 0, jiffies 4294667388
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff1a8>] kmemdup+0x22/0x5a
    [<c0624ad2>] selinux_cred_prepare+0x18/0x41
    [<c0613437>] security_prepare_creds+0x15/0x18
    [<c047af05>] prepare_creds+0xc4/0xeb
    [<c047b537>] copy_creds+0x8a/0x2c5
    [<c044eff6>] copy_process+0x31e/0x17bf
    [<c04506ed>] do_fork+0x256/0x556
    [<c04024d1>] kernel_thread+0x85/0x8d
    [<c08a85ea>] rest_init+0x1e/0x5a
    [<c0d34b5c>] start_kernel+0x383/0x388
    [<c0d340ae>] i386_start_kernel+0xae/0xb3
    [<ffffffff>] 0xffffffff
unreferenced object 0xf7253200 (size 32):
  comm "swapper", pid 1, jiffies 4294669642
  hex dump (first 32 bytes):
    a0 36 25 f7 00 00 00 00 00 00 00 00 00 00 00 00  .6%.............
    00 00 00 00 44 5f 25 f6 72 b7 47 c0 00 00 00 00  ....D_%.r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0d5cb39>] kmemleak_test_init+0x25/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf7253100 (size 32):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    a0 36 25 f7 01 00 00 00 00 00 00 00 00 00 00 00  .6%.............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0d5cbc8>] kmemleak_test_init+0xb4/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf705b800 (size 1024):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    00 bc 05 f7 ff ff ff ff 00 00 00 80 00 00 00 00  ................
    fd ff ff ff ff ff ff df 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0d5cc57>] kmemleak_test_init+0x143/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf705bc00 (size 1024):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    00 00 00 00 ff ff ff ff 00 20 00 08 00 00 01 00  ......... ......
    ff ff ff bf ff 7f ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0d5cce6>] kmemleak_test_init+0x1d2/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf7191000 (size 2048):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    00 18 19 f7 fb ff ff ff 00 00 00 00 21 00 00 00  ............!...
    ff ff ff ff db ff ff ff 00 04 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0d5cd75>] kmemleak_test_init+0x261/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf7191800 (size 2048):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    00 20 19 f7 fe ff ff ff 00 00 00 00 00 00 00 04  . ..............
    ff fd ff ff f5 ff ff f7 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0d5ce04>] kmemleak_test_init+0x2f0/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf801d000 (size 64):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    b7 fd ee 8e f6 fe 5f f3 b9 fb dd f7 9f eb ed cf  ......_.........
    df 91 f1 ff fb f9 5f fd ea f2 fb 9f df 3f ff de  ......_......?..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c051560c>] __vmalloc_node+0xb9/0xca
    [<c051574c>] vmalloc+0x21/0x23
    [<c0d5cfa8>] kmemleak_test_init+0x494/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf8026000 (size 64):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    fb fc fe 7f bf bf 7f 5d df fa 79 dd fd fc fd dd  .......]..y.....
    f7 ff 9f ff f7 fe df f6 9b ab 9f e5 f9 fc eb fe  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c051560c>] __vmalloc_node+0xb9/0xca
    [<c051574c>] vmalloc+0x21/0x23
    [<c0d5cfbd>] kmemleak_test_init+0x4a9/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf8029000 (size 64):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    cf ef af fd bf f4 ff 7b fd a8 37 5f ec e9 fa d7  .......{..7_....
    bb b7 fc ee fe fe d5 ff fd ff f1 fe df 9f ff fd  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c051560c>] __vmalloc_node+0xb9/0xca
    [<c051574c>] vmalloc+0x21/0x23
    [<c0d5cfd2>] kmemleak_test_init+0x4be/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf802c000 (size 64):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    ff ef fd dd fd 7d f3 cb 7b f7 f7 9f f2 af ff fb  .....}..{.......
    bf 3b af ef ff fb 5f 77 9f bf 99 be 9d f9 fd b7  .;...._w........
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c051560c>] __vmalloc_node+0xb9/0xca
    [<c051574c>] vmalloc+0x21/0x23
    [<c0d5cfea>] kmemleak_test_init+0x4d6/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf802f000 (size 64):
  comm "swapper", pid 1, jiffies 4294669643
  hex dump (first 32 bytes):
    b7 fd ee 8e fe fe 5f f3 b9 fa dd f7 bf eb ed cf  ......_.........
    df 91 f1 ff f9 f9 5f fd ea fa fa 9f df 3f ff de  ......_......?..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c051560c>] __vmalloc_node+0xb9/0xca
    [<c051574c>] vmalloc+0x21/0x23
    [<c0d5cfff>] kmemleak_test_init+0x4eb/0x6e8
    [<c040116a>] do_one_initcall+0x78/0x1fb
    [<c0d343e6>] kernel_init+0x160/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5c16270 (size 16):
  comm "swapper", pid 1, jiffies 4294673952
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c0401322>] init_post+0x35/0x18f
    [<c0d34459>] kernel_init+0x1d3/0x1dd
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339bf0 (size 16):
  comm "swapper", pid 1, jiffies 4294673953
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c0536969>] open_exec+0x23/0x152
    [<c057b384>] load_script+0x26c/0x2e4
    [<c05356ea>] search_binary_handler+0x1e1/0x48c
    [<c0537331>] do_execve+0x2f6/0x46f
    [<c04022d9>] sys_execve+0x57/0x96
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339600 (size 16):
  comm "swapper", pid 1, jiffies 4294673953
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c0536969>] open_exec+0x23/0x152
    [<c057d2e9>] load_elf_binary+0x3b3/0x1b92
    [<c05356ea>] search_binary_handler+0x1e1/0x48c
    [<c057b3e5>] load_script+0x2cd/0x2e4
    [<c05356ea>] search_binary_handler+0x1e1/0x48c
    [<c0537331>] do_execve+0x2f6/0x46f
    [<c04022d9>] sys_execve+0x57/0x96
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf63395e0 (size 16):
  comm "init", pid 1, jiffies 4294673953
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339be0 (size 16):
  comm "init", pid 1, jiffies 4294673954
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339bd0 (size 16):
  comm "init", pid 1, jiffies 4294673954
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339bc0 (size 16):
  comm "init", pid 1, jiffies 4294673954
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339bb0 (size 16):
  comm "init", pid 1, jiffies 4294673954
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339ba0 (size 16):
  comm "init", pid 1, jiffies 4294673954
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b90 (size 16):
  comm "init", pid 1, jiffies 4294673954
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b80 (size 16):
  comm "init", pid 1, jiffies 4294673954
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b70 (size 16):
  comm "init", pid 1, jiffies 4294673954
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b60 (size 16):
  comm "init", pid 1, jiffies 4294673955
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b50 (size 16):
  comm "init", pid 1, jiffies 4294673955
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b40 (size 16):
  comm "init", pid 1, jiffies 4294673955
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b30 (size 16):
  comm "init", pid 1, jiffies 4294673955
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b20 (size 16):
  comm "init", pid 1, jiffies 4294673955
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b10 (size 16):
  comm "init", pid 1, jiffies 4294673955
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339b00 (size 16):
  comm "init", pid 1, jiffies 4294673956
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339af0 (size 16):
  comm "init", pid 1, jiffies 4294673956
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339ae0 (size 16):
  comm "init", pid 1, jiffies 4294673956
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339ad0 (size 16):
  comm "init", pid 1, jiffies 4294673956
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339ac0 (size 16):
  comm "init", pid 1, jiffies 4294673956
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04042c5>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xf63395f0 (size 16):
  comm "init", pid 1, jiffies 4294673961
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5c18930 (size 48):
  comm "init", pid 1, jiffies 4294673964
  hex dump (first 32 bytes):
    28 4c c0 f6 34 89 c1 f5 34 89 c1 f5 01 00 00 00  (L..4...4.......
    01 00 00 00 37 00 01 00 01 00 00 00 00 00 00 00  ....7...........
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0625679>] selinux_inode_alloc_security+0x2e/0x89
    [<c0613269>] security_inode_alloc+0x1e/0x20
    [<c054abbc>] inode_init_always+0xbd/0x1b9
    [<c054ad1d>] alloc_inode+0x65/0xcd
    [<c054b12a>] new_inode+0x1c/0x96
    [<c07e752a>] sock_alloc+0x16/0x80
    [<c07e8353>] __sock_create+0x10c/0x472
    [<c07e8700>] sock_create+0x29/0x2e
    [<c07e8a67>] sys_socket+0x47/0x9d
    [<c07e9bdd>] sys_socketcall+0xbd/0x1d7
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6223020 (size 32):
  comm "init", pid 1, jiffies 4294673964
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 01 00 00 00 03 00 00 00  ................
    37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  7...............
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0621e70>] selinux_sk_alloc_security+0x40/0x108
    [<c0613af9>] security_sk_alloc+0x15/0x18
    [<c07ec119>] sk_prot_alloc+0x105/0x268
    [<c07ec29c>] sk_alloc+0x20/0x72
    [<c08201bf>] __netlink_create+0x2a/0xbc
    [<c08204d4>] netlink_create+0x283/0x2d9
    [<c07e8522>] __sock_create+0x2db/0x472
    [<c07e8700>] sock_create+0x29/0x2e
    [<c07e8a67>] sys_socket+0x47/0x9d
    [<c07e9bdd>] sys_socketcall+0xbd/0x1d7
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339ab0 (size 16):
  comm "init", pid 1, jiffies 4294673964
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c07e75da>] sock_alloc_fd+0x46/0x8b
    [<c07e7717>] sock_map_fd+0x1c/0xa7
    [<c07e8a92>] sys_socket+0x72/0x9d
    [<c07e9bdd>] sys_socketcall+0xbd/0x1d7
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339aa0 (size 16):
  comm "init", pid 1, jiffies 4294673979
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c0530cc1>] alloc_file+0x1a/0x56
    [<c0538515>] create_write_pipe+0x164/0x1da
    [<c05385ce>] do_pipe_flags+0x43/0x19b
    [<c0538740>] sys_pipe2+0x1a/0x7f
    [<c05387b7>] sys_pipe+0x12/0x14
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339a80 (size 16):
  comm "init", pid 1, jiffies 4294673979
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053808e>] create_read_pipe+0x14/0x94
    [<c053860d>] do_pipe_flags+0x82/0x19b
    [<c0538740>] sys_pipe2+0x1a/0x7f
    [<c05387b7>] sys_pipe+0x12/0x14
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6339a70 (size 16):
  comm "init", pid 1, jiffies 4294673979
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5c35040 (size 32):
  comm "init", pid 1, jiffies 4294673980
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff1a8>] kmemdup+0x22/0x5a
    [<c0624ad2>] selinux_cred_prepare+0x18/0x41
    [<c0613437>] security_prepare_creds+0x15/0x18
    [<c047af05>] prepare_creds+0xc4/0xeb
    [<c047b537>] copy_creds+0x8a/0x2c5
    [<c044eff6>] copy_process+0x31e/0x17bf
    [<c04506ed>] do_fork+0x256/0x556
    [<c0402444>] sys_clone+0x49/0x51
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5c126c0 (size 48):
  comm "init", pid 856, jiffies 4294673981
  hex dump (first 32 bytes):
    28 6c c2 f6 c4 26 c1 f5 c4 26 c1 f5 01 00 00 00  (l...&...&......
    01 00 00 00 37 00 01 00 01 00 00 00 00 00 00 00  ....7...........
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0625679>] selinux_inode_alloc_security+0x2e/0x89
    [<c0613269>] security_inode_alloc+0x1e/0x20
    [<c054abbc>] inode_init_always+0xbd/0x1b9
    [<c054ad1d>] alloc_inode+0x65/0xcd
    [<c054b12a>] new_inode+0x1c/0x96
    [<c07e752a>] sock_alloc+0x16/0x80
    [<c07e8353>] __sock_create+0x10c/0x472
    [<c07e8700>] sock_create+0x29/0x2e
    [<c07e8a67>] sys_socket+0x47/0x9d
    [<c07e9bdd>] sys_socketcall+0xbd/0x1d7
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6290c40 (size 32):
  comm "init", pid 856, jiffies 4294673981
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 01 00 00 00 03 00 00 00  ................
    37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  7...............
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0621e70>] selinux_sk_alloc_security+0x40/0x108
    [<c0613af9>] security_sk_alloc+0x15/0x18
    [<c07ec119>] sk_prot_alloc+0x105/0x268
    [<c07ec29c>] sk_alloc+0x20/0x72
    [<c08201bf>] __netlink_create+0x2a/0xbc
    [<c08204d4>] netlink_create+0x283/0x2d9
    [<c07e8522>] __sock_create+0x2db/0x472
    [<c07e8700>] sock_create+0x29/0x2e
    [<c07e8a67>] sys_socket+0x47/0x9d
    [<c07e9bdd>] sys_socketcall+0xbd/0x1d7
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5c16260 (size 16):
  comm "init", pid 856, jiffies 4294673981
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c07e75da>] sock_alloc_fd+0x46/0x8b
    [<c07e7717>] sock_map_fd+0x1c/0xa7
    [<c07e8a92>] sys_socket+0x72/0x9d
    [<c07e9bdd>] sys_socketcall+0xbd/0x1d7
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5c16210 (size 16):
  comm "nash-hotplug", pid 856, jiffies 4294673982
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5c12720 (size 48):
  comm "nash-hotplug", pid 856, jiffies 4294673983
  hex dump (first 32 bytes):
    98 61 cb f6 24 27 c1 f5 24 27 c1 f5 01 00 00 00  .a..$'..$'......
    01 00 00 00 07 00 01 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0625679>] selinux_inode_alloc_security+0x2e/0x89
    [<c0613269>] security_inode_alloc+0x1e/0x20
    [<c054abbc>] inode_init_always+0xbd/0x1b9
    [<c054ad1d>] alloc_inode+0x65/0xcd
    [<c054b12a>] new_inode+0x1c/0x96
    [<c058b31d>] proc_pid_make_inode+0x11/0xc7
    [<c058e376>] proc_pid_instantiate+0x1a/0xe0
    [<c058ecf0>] proc_pid_lookup+0x1c5/0x1fd
    [<c058a183>] proc_root_lookup+0x3d/0x42
    [<c053a0ce>] do_lookup+0x12f/0x338
    [<c053ddac>] __link_path_walk+0xf4b/0x164f
    [<c053e592>] vfs_follow_link+0xe2/0x1bf
    [<c058a5e3>] proc_self_follow_link+0x69/0x74
    [<c053d66f>] __link_path_walk+0x80e/0x164f
unreferenced object 0xf5c12780 (size 48):
  comm "nash-hotplug", pid 856, jiffies 4294673983
  hex dump (first 32 bytes):
    18 63 cb f6 84 27 c1 f5 84 27 c1 f5 01 00 00 00  .c...'...'......
    01 00 00 00 06 00 01 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0625679>] selinux_inode_alloc_security+0x2e/0x89
    [<c0613269>] security_inode_alloc+0x1e/0x20
    [<c054abbc>] inode_init_always+0xbd/0x1b9
    [<c054ad1d>] alloc_inode+0x65/0xcd
    [<c054b12a>] new_inode+0x1c/0x96
    [<c058b31d>] proc_pid_make_inode+0x11/0xc7
    [<c058e459>] proc_pident_instantiate+0x1d/0xff
    [<c058e6e6>] proc_pident_lookup+0xcb/0x103
    [<c058e75e>] proc_tgid_base_lookup+0x14/0x16
    [<c053a0ce>] do_lookup+0x12f/0x338
    [<c053ddac>] __link_path_walk+0xf4b/0x164f
    [<c053e6ad>] path_walk+0x3e/0x8d
    [<c053e73d>] do_path_lookup+0x41/0x11c
    [<c053f9b1>] do_filp_open+0x1aa/0xebc
unreferenced object 0xf5ddd780 (size 16):
  comm "init", pid 1, jiffies 4294681956
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6223ba0 (size 32):
  comm "kthreadd", pid 2, jiffies 4294682545
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 b4 3b 22 f6 63 00 00 00  .........;".c...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff1a8>] kmemdup+0x22/0x5a
    [<c0624ad2>] selinux_cred_prepare+0x18/0x41
    [<c0613437>] security_prepare_creds+0x15/0x18
    [<c047af05>] prepare_creds+0xc4/0xeb
    [<c047b537>] copy_creds+0x8a/0x2c5
    [<c044eff6>] copy_process+0x31e/0x17bf
    [<c04506ed>] do_fork+0x256/0x556
    [<c04024d1>] kernel_thread+0x85/0x8d
    [<c047348d>] kthreadd+0xa4/0xec
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6223f00 (size 32):
  comm "kthreadd", pid 2, jiffies 4294682545
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 70 6c 75 67 5f 69 6f 00  ........plug_io.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff1a8>] kmemdup+0x22/0x5a
    [<c0624ad2>] selinux_cred_prepare+0x18/0x41
    [<c0613437>] security_prepare_creds+0x15/0x18
    [<c047af05>] prepare_creds+0xc4/0xeb
    [<c047b537>] copy_creds+0x8a/0x2c5
    [<c044eff6>] copy_process+0x31e/0x17bf
    [<c04506ed>] do_fork+0x256/0x556
    [<c04024d1>] kernel_thread+0x85/0x8d
    [<c047348d>] kthreadd+0xa4/0xec
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6223e00 (size 32):
  comm "kthreadd", pid 2, jiffies 4294682545
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 63 6b 70 6f 69 6e 74 00  ........ckpoint.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff1a8>] kmemdup+0x22/0x5a
    [<c0624ad2>] selinux_cred_prepare+0x18/0x41
    [<c0613437>] security_prepare_creds+0x15/0x18
    [<c047af05>] prepare_creds+0xc4/0xeb
    [<c047b537>] copy_creds+0x8a/0x2c5
    [<c044eff6>] copy_process+0x31e/0x17bf
    [<c04506ed>] do_fork+0x256/0x556
    [<c04024d1>] kernel_thread+0x85/0x8d
    [<c047348d>] kthreadd+0xa4/0xec
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6223b80 (size 32):
  comm "kthreadd", pid 2, jiffies 4294682545
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 5f 73 74 61 74 73 00 00  ........_stats..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff1a8>] kmemdup+0x22/0x5a
    [<c0624ad2>] selinux_cred_prepare+0x18/0x41
    [<c0613437>] security_prepare_creds+0x15/0x18
    [<c047af05>] prepare_creds+0xc4/0xeb
    [<c047b537>] copy_creds+0x8a/0x2c5
    [<c044eff6>] copy_process+0x31e/0x17bf
    [<c04506ed>] do_fork+0x256/0x556
    [<c04024d1>] kernel_thread+0x85/0x8d
    [<c047348d>] kthreadd+0xa4/0xec
    [<c0404e33>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5ddd940 (size 16):
  comm "init", pid 1, jiffies 4294683351
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5ddd820 (size 16):
  comm "init", pid 1, jiffies 4294683377
  hex dump (first 16 bytes):
    01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
    [<c06132ed>] security_file_alloc+0x14/0x16
    [<c0530b97>] get_empty_filp+0x10d/0x21d
    [<c053f964>] do_filp_open+0x15d/0xebc
    [<c052c10e>] do_sys_open+0x93/0x16a
    [<c052c231>] sys_open+0x23/0x2b
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58067c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698474
  hex dump (first 32 bytes):
    34 7e 60 f8 c0 6f 80 f5 50 d5 da f5 60 d5 da f5  4~`..o..P...`...
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad550 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698474
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad560 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5806fc0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    c0 67 80 f5 80 6a 80 f5 70 d5 da f5 80 d5 da f5  .g...j..p.......
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad570 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad580 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5806a80 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    c0 6f 80 f5 e0 6e 80 f5 a0 66 80 f5 90 d5 da f5  .o...n...f......
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58066a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 bb 89 f5 72 b7 47 c0 e8 f6 c8 f6  ount....r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad590 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5806ee0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    80 6a 80 f5 c0 6a 80 f5 a0 d5 da f5 f0 80 bd f5  .j...j..........
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad5a0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd80f0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    69 6e 74 00 75 a3 8a c0                          int.u...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5806ac0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    e0 6e 80 f5 e0 6a 80 f5 40 66 80 f5 f8 80 bd f5  .n...j..@f......
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5806640 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 db f5 e8 f6 c8 f6 80 57 db f5 e8 f6 c8 f6  h........W......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd80f8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    69 6e 74 00 dd d7 59 c0                          int...Y.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5806ae0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    c0 6a 80 f5 34 7e 60 f8 00 81 bd f5 08 81 bd f5  .j..4~`.........
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3cb3>] ftrace_define_fields_i915_ring_wait_end+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8100 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    64 65 76 00 e6 c7 52 c0                          dev...R.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3cb3>] ftrace_define_fields_i915_ring_wait_end+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8108 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    75 33 32 00 0e c1 52 c0                          u32...R.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3cb3>] ftrace_define_fields_i915_ring_wait_end+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fa80 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    e4 7e 60 f8 40 fb d5 f5 10 d6 da f5 20 d6 da f5  .~`.@....... ...
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad610 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad620 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fb40 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    80 fa d5 f5 40 fa d5 f5 30 d6 da f5 40 d6 da f5  ....@...0...@...
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad630 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad640 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fa40 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    40 fb d5 f5 40 fc d5 f5 40 fe d5 f5 50 d6 da f5  @...@...@...P...
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fe40 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 f3 3e f6 72 b7 47 c0 e8 f6 c8 f6  ount..>.r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad650 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fc40 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    40 fa d5 f5 20 fd d5 f5 60 d6 da f5 30 81 bd f5  @... ...`...0...
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad660 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8130 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    69 6e 74 00 0a 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fd20 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    40 fc d5 f5 c0 fd d5 f5 80 fd d5 f5 38 81 bd f5  @...........8...
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fd80 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 00 00 ac fa 91 f5 72 b7 47 c0 e8 f6 c8 f6  h.......r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8138 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    69 6e 74 00 25 08 00 00                          int.%...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3b78>] ftrace_define_fields_i915_gem_request_wait_end+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fdc0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    20 fd d5 f5 c0 fe d5 f5 40 81 bd f5 48 81 bd f5   .......@...H...
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3bad>] ftrace_define_fields_i915_gem_request_wait_end+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8140 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    64 65 76 00 00 00 00 00                          dev.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3bad>] ftrace_define_fields_i915_gem_request_wait_end+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8148 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    75 33 32 00 00 00 00 00                          u32.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3bad>] ftrace_define_fields_i915_gem_request_wait_end+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fec0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 32 bytes):
    c0 fd d5 f5 e4 7e 60 f8 50 81 bd f5 58 81 bd f5  .....~`.P...X...
    00 00 00 00 10 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3be5>] ftrace_define_fields_i915_gem_request_wait_end+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8150 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    73 65 71 6e 6f 00 00 00                          seqno...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3be5>] ftrace_define_fields_i915_gem_request_wait_end+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8158 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698475
  hex dump (first 8 bytes):
    75 33 32 00 00 02 20 00                          u32... .
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3be5>] ftrace_define_fields_i915_gem_request_wait_end+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fc20 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    3c 7f 60 f8 c0 fb d5 f5 70 d6 da f5 80 d6 da f5  <.`.....p.......
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad670 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad680 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fbc0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    20 fc d5 f5 80 fb d5 f5 90 d6 da f5 a0 d6 da f5   ...............
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad690 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad6a0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fb80 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    c0 fb d5 f5 c0 f8 d5 f5 40 ff d5 f5 b0 d6 da f5  ........@.......
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5ff40 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 a9 fe f5 72 b7 47 c0 e8 f6 c8 f6  ount....r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad6b0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5f8c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    80 fb d5 f5 a0 fd d5 f5 c0 d6 da f5 60 81 bd f5  ............`...
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad6c0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8160 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    69 6e 74 00 60 81 bd f5                          int.`...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fda0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    c0 f8 d5 f5 e0 fb d5 f5 60 fd d5 f5 68 81 bd f5  ........`...h...
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fd60 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 00 00 0c b8 89 f5 72 b7 47 c0 e8 f6 c8 f6  h.......r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8168 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    69 6e 74 00 c0 10 b9 f5                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3ad9>]
ftrace_define_fields_i915_gem_request_wait_begin+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fbe0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    a0 fd d5 f5 60 fe d5 f5 70 81 bd f5 78 81 bd f5  ....`...p...x...
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3b0e>]
ftrace_define_fields_i915_gem_request_wait_begin+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8170 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    64 65 76 00 38 cf 8b f5                          dev.8...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3b0e>]
ftrace_define_fields_i915_gem_request_wait_begin+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8178 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    75 33 32 00 24 82 bd f5                          u32.$...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3b0e>]
ftrace_define_fields_i915_gem_request_wait_begin+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fe60 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    e0 fb d5 f5 3c 7f 60 f8 80 81 bd f5 88 81 bd f5  ....<.`.........
    00 00 00 00 10 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3b46>]
ftrace_define_fields_i915_gem_request_wait_begin+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8180 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    73 65 71 6e 6f 00 00 00                          seqno...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3b46>]
ftrace_define_fields_i915_gem_request_wait_begin+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8188 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    75 33 32 00 08 00 00 00                          u32.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3b46>]
ftrace_define_fields_i915_gem_request_wait_begin+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fe00 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    94 7f 60 f8 a0 f7 d5 f5 d0 d6 da f5 e0 d6 da f5  ..`.............
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad6d0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad6e0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5f7a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    00 fe d5 f5 60 fb d5 f5 f0 d6 da f5 00 d7 da f5  ....`...........
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad6f0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad700 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5fb60 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    a0 f7 d5 f5 00 ff d5 f5 60 ff d5 f5 10 d7 da f5  ........`.......
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5ff60 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 f6 c8 f6 80 57 db f5 e8 f6 c8 f6  ount.....W......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad710 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5d5ff00 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    60 fb d5 f5 20 07 29 f6 20 d7 da f5 90 81 bd f5  `... .). .......
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad720 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8190 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    69 6e 74 00 ff ff ff ff                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6290720 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    00 ff d5 f5 60 03 29 f6 c0 01 29 f6 98 81 bd f5  ....`.)...).....
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf62901c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 00 00 14 16 3a f6 72 b7 47 c0 e8 f6 c8 f6  h.....:.r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8198 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    69 6e 74 00 75 a3 8a c0                          int.u...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3a3a>] ftrace_define_fields_i915_gem_request_retire+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6290360 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    20 07 29 f6 20 0e 29 f6 a0 81 bd f5 a8 81 bd f5   .). .).........
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3a6f>] ftrace_define_fields_i915_gem_request_retire+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd81a0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    64 65 76 00 2b dc 59 c0                          dev.+.Y.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3a6f>] ftrace_define_fields_i915_gem_request_retire+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd81a8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    75 33 32 00 71 fd 52 c0                          u32.q.R.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3a6f>] ftrace_define_fields_i915_gem_request_retire+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6290e20 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 32 bytes):
    60 03 29 f6 94 7f 60 f8 b0 81 bd f5 b8 81 bd f5  `.)...`.........
    00 00 00 00 10 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3aa7>] ftrace_define_fields_i915_gem_request_retire+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd81b0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    73 65 71 6e 6f 00 ff ff                          seqno...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3aa7>] ftrace_define_fields_i915_gem_request_retire+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd81b8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698476
  hex dump (first 8 bytes):
    75 33 32 00 00 00 00 00                          u32.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3aa7>] ftrace_define_fields_i915_gem_request_retire+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863aa0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    44 80 60 f8 00 3d 86 f5 90 d7 da f5 a0 d7 da f5  D.`..=..........
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad790 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad7a0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863d00 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    a0 3a 86 f5 40 38 86 f5 b0 d7 da f5 c0 d7 da f5  .:..@8..........
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad7b0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad7c0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863840 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    00 3d 86 f5 a0 34 86 f5 60 32 86 f5 d0 d7 da f5  .=...4..`2......
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863260 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 f6 c8 f6 80 57 db f5 e8 f6 c8 f6  ount.....W......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad7d0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58634a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    40 38 86 f5 c0 33 86 f5 e0 d7 da f5 f0 81 bd f5  @8...3..........
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad7e0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd81f0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    69 6e 74 00 00 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58633c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    a0 34 86 f5 e0 3e 86 f5 00 3a 86 f5 f8 81 bd f5  .4...>...:......
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863a00 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 00 00 64 27 9e f5 72 b7 47 c0 e8 f6 c8 f6  h...d'..r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd81f8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    69 6e 74 00 08 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3884>] ftrace_define_fields_i915_gem_request_flush+0x10/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863ee0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    c0 33 86 f5 40 34 86 f5 00 82 bd f5 08 82 bd f5  .3..@4..........
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d38bd>] ftrace_define_fields_i915_gem_request_flush+0x49/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8200 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    64 65 76 00 00 02 20 00                          dev... .
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d38bd>] ftrace_define_fields_i915_gem_request_flush+0x49/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8208 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    75 33 32 00 08 82 bd f5                          u32.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d38bd>] ftrace_define_fields_i915_gem_request_flush+0x49/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863440 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    e0 3e 86 f5 60 3f 86 f5 10 82 bd f5 18 82 bd f5  .>..`?..........
    00 00 00 00 10 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d38f9>] ftrace_define_fields_i915_gem_request_flush+0x85/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8210 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    73 65 71 6e 6f 00 b9 f5                          seqno...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d38f9>] ftrace_define_fields_i915_gem_request_flush+0x85/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8218 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    75 33 32 00 38 cf 8b f5                          u32.8...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d38f9>] ftrace_define_fields_i915_gem_request_flush+0x85/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863f60 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    40 34 86 f5 60 3c 86 f5 f0 d7 da f5 20 82 bd f5  @4..`<...... ...
    00 00 00 00 14 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3931>] ftrace_define_fields_i915_gem_request_flush+0xbd/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad7f0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    66 6c 75 73 68 5f 64 6f 6d 61 69 6e 73 00 00 00  flush_domains...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3931>] ftrace_define_fields_i915_gem_request_flush+0xbd/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8220 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    75 33 32 00 cc 82 bd f5                          u32.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3931>] ftrace_define_fields_i915_gem_request_flush+0xbd/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863c60 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    60 3f 86 f5 44 80 60 f8 a0 38 86 f5 28 82 bd f5  `?..D.`..8..(...
    00 00 00 00 18 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3969>] ftrace_define_fields_i915_gem_request_flush+0xf5/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58638a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    69 6e 76 61 6c 69 64 61 74 65 5f 64 6f 6d 61 69  invalidate_domai
    6e 73 00 00 ac aa f4 f5 72 b7 47 c0 e8 f6 c8 f6  ns......r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3969>] ftrace_define_fields_i915_gem_request_flush+0xf5/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8228 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    75 33 32 00 00 00 00 00                          u32.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3969>] ftrace_define_fields_i915_gem_request_flush+0xf5/0x117 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863860 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    9c 80 60 f8 c0 3e 86 f5 00 d8 da f5 10 d8 da f5  ..`..>..........
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad800 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad810 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863ec0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    60 38 86 f5 c0 3f 86 f5 20 d8 da f5 30 d8 da f5  `8...?.. ...0...
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad820 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad830 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863fc0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    c0 3e 86 f5 c0 38 86 f5 20 30 86 f5 40 d8 da f5  .>...8.. 0..@...
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863020 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 07 f9 f5 72 b7 47 c0 e8 f6 c8 f6  ount....r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad840 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58638c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    c0 3f 86 f5 00 3b 86 f5 50 d8 da f5 30 82 bd f5  .?...;..P...0...
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad850 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8230 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    69 6e 74 00 08 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863b00 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    c0 38 86 f5 a0 3b 86 f5 e0 3f 86 f5 38 82 bd f5  .8...;...?..8...
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863fe0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 00 00 a4 dc 83 f5 72 b7 47 c0 e8 f6 c8 f6  h.......r.G.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8238 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    69 6e 74 00 ff ff ff ff                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d37e5>] ftrace_define_fields_i915_gem_request_submit+0x10/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863ba0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    00 3b 86 f5 a0 3e 86 f5 40 82 bd f5 48 82 bd f5  .;...>..@...H...
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d381a>] ftrace_define_fields_i915_gem_request_submit+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8240 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    64 65 76 00 75 a3 8a c0                          dev.u...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d381a>] ftrace_define_fields_i915_gem_request_submit+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8248 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    75 33 32 00 2b dc 59 c0                          u32.+.Y.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d381a>] ftrace_define_fields_i915_gem_request_submit+0x45/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863ea0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    a0 3b 86 f5 9c 80 60 f8 50 82 bd f5 58 82 bd f5  .;....`.P...X...
    00 00 00 00 10 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3852>] ftrace_define_fields_i915_gem_request_submit+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8250 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    73 65 71 6e 6f 00 52 c0                          seqno.R.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3852>] ftrace_define_fields_i915_gem_request_submit+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8258 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 8 bytes):
    75 33 32 00 ff ff ff ff                          u32.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3852>] ftrace_define_fields_i915_gem_request_submit+0x7d/0x9f [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863380 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    f4 80 60 f8 00 32 86 f5 60 d8 da f5 70 d8 da f5  ..`..2..`...p...
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad860 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad870 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5863200 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    80 33 86 f5 c0 30 86 f5 80 d8 da f5 90 d8 da f5  .3...0..........
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad880 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad890 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58630c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698477
  hex dump (first 32 bytes):
    00 32 86 f5 a0 62 3f f6 a0 32 86 f5 a0 d8 da f5  .2...b?..2......
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58632a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 f6 c8 f6 80 57 db f5 e8 f6 c8 f6  ount.....W......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad8a0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf63f62a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    c0 30 86 f5 60 64 3f f6 b0 d8 da f5 60 82 bd f5  .0..`d?.....`...
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad8b0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8260 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    69 6e 74 00 00 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf63f6460 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    a0 62 3f f6 00 80 8e f5 c0 64 3f f6 68 82 bd f5  .b?......d?.h...
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf63f64c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 8b f5 02 00 00 00 00 00 00 00 40 0f 49 c0  h...........@.I.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8268 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    69 6e 74 00 00 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d377e>] ftrace_define_fields_i915_gem_object_destroy+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8000 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    60 64 3f f6 f4 80 60 f8 70 82 bd f5 20 80 8e f5  `d?...`.p... ...
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d37b3>] ftrace_define_fields_i915_gem_object_destroy+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8270 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    6f 62 6a 00 00 00 00 00                          obj.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d37b3>] ftrace_define_fields_i915_gem_object_destroy+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8020 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    73 74 72 75 63 74 20 64 72 6d 5f 67 65 6d 5f 6f  struct drm_gem_o
    62 6a 65 63 74 20 2a 00 38 cf 8b f5 08 00 00 00  bject *.8.......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d37b3>] ftrace_define_fields_i915_gem_object_destroy+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8040 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    4c 81 60 f8 60 80 8e f5 c0 d8 da f5 d0 d8 da f5  L.`.`...........
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad8c0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad8d0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8060 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    40 80 8e f5 80 80 8e f5 e0 d8 da f5 f0 d8 da f5  @...............
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad8e0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad8f0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8080 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    60 80 8e f5 c0 80 8e f5 a0 80 8e f5 00 d9 da f5  `...............
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e80a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 02 20 00 b8 80 8e f5 b8 80 8e f5  ount.. .........
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad900 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e80c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    80 80 8e f5 e0 80 8e f5 10 d9 da f5 78 82 bd f5  ............x...
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad910 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8278 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    69 6e 74 00 00 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e80e0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    c0 80 8e f5 20 81 8e f5 00 81 8e f5 80 82 bd f5  .... ...........
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8100 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  h...............
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8280 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    69 6e 74 00 07 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3717>] ftrace_define_fields_i915_gem_object_unbind+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8120 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    e0 80 8e f5 4c 81 60 f8 88 82 bd f5 40 81 8e f5  ....L.`.....@...
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d374c>] ftrace_define_fields_i915_gem_object_unbind+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8288 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    6f 62 6a 00 25 08 00 00                          obj.%...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d374c>] ftrace_define_fields_i915_gem_object_unbind+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8140 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    73 74 72 75 63 74 20 64 72 6d 5f 67 65 6d 5f 6f  struct drm_gem_o
    62 6a 65 63 74 20 2a 00 00 13 b9 c0 00 02 20 00  bject *....... .
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d374c>] ftrace_define_fields_i915_gem_object_unbind+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8160 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    a4 81 60 f8 80 81 8e f5 20 d9 da f5 30 d9 da f5  ..`..... ...0...
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad920 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad930 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8180 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    60 81 8e f5 a0 81 8e f5 40 d9 da f5 50 d9 da f5  `.......@...P...
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad940 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad950 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e81a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    80 81 8e f5 e0 81 8e f5 c0 81 8e f5 60 d9 da f5  ............`...
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e81c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 00 00 00 00 00 00 00 07 00 00 00  ount............
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad960 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e81e0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    a0 81 8e f5 00 82 8e f5 70 d9 da f5 90 82 bd f5  ........p.......
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad970 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8290 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    69 6e 74 00 00 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8200 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    e0 81 8e f5 40 82 8e f5 20 82 8e f5 98 82 bd f5  ....@... .......
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8220 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 8b f5 08 00 00 00 01 00 00 00 ff ff ff ff  h...............
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd8298 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    69 6e 74 00 00 00 00 00                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d363c>] ftrace_define_fields_i915_gem_object_get_fence+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8240 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    00 82 8e f5 80 82 8e f5 a0 82 bd f5 60 82 8e f5  ............`...
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d3675>] ftrace_define_fields_i915_gem_object_get_fence+0x49/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82a0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    6f 62 6a 00 08 00 00 00                          obj.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d3675>] ftrace_define_fields_i915_gem_object_get_fence+0x49/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8260 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    73 74 72 75 63 74 20 64 72 6d 5f 67 65 6d 5f 6f  struct drm_gem_o
    62 6a 65 63 74 20 2a 00 00 00 00 00 00 00 00 00  bject *.........
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d3675>] ftrace_define_fields_i915_gem_object_get_fence+0x49/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8280 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    40 82 8e f5 a0 82 8e f5 a8 82 bd f5 b0 82 bd f5  @...............
    00 00 00 00 10 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d36ad>] ftrace_define_fields_i915_gem_object_get_fence+0x81/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82a8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    66 65 6e 63 65 00 20 00                          fence. .
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d36ad>] ftrace_define_fields_i915_gem_object_get_fence+0x81/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82b0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    69 6e 74 00 b0 82 bd f5                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d36ad>] ftrace_define_fields_i915_gem_object_get_fence+0x81/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e82a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    80 82 8e f5 a4 81 60 f8 80 d9 da f5 b8 82 bd f5  ......`.........
    00 00 00 00 14 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d36e5>] ftrace_define_fields_i915_gem_object_get_fence+0xb9/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad980 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    74 69 6c 69 6e 67 5f 6d 6f 64 65 00 00 00 00 00  tiling_mode.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d36e5>] ftrace_define_fields_i915_gem_object_get_fence+0xb9/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82b8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 8 bytes):
    69 6e 74 00 c0 10 b9 f5                          int.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d36e5>] ftrace_define_fields_i915_gem_object_get_fence+0xb9/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e82c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    fc 81 60 f8 e0 82 8e f5 90 d9 da f5 a0 d9 da f5  ..`.............
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad990 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad9a0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e82e0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    c0 82 8e f5 00 83 8e f5 b0 d9 da f5 c0 d9 da f5  ................
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad9b0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad9c0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8300 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698478
  hex dump (first 32 bytes):
    e0 82 8e f5 40 83 8e f5 20 83 8e f5 d0 d9 da f5  ....@... .......
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8320 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 08 00 00 58 6f 72 67 00 00 00 00  ount....Xorg....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad9d0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8340 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    00 83 8e f5 60 83 8e f5 e0 d9 da f5 c0 82 bd f5  ....`...........
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad9e0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82c0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 8 bytes):
    69 6e 74 00 38 cf 8b f5                          int.8...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8360 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    40 83 8e f5 a0 83 8e f5 80 83 8e f5 c8 82 bd f5  @...............
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8380 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 00 00 75 a3 8a c0 bc 61 52 c0 2b dc 59 c0  h...u....aR.+.Y.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82c8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 8 bytes):
    69 6e 74 00 74 83 bd f5                          int.t...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d3561>]
ftrace_define_fields_i915_gem_object_change_domain+0x10/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e83a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    60 83 8e f5 e0 83 8e f5 d0 82 bd f5 c0 83 8e f5  `...............
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d359a>]
ftrace_define_fields_i915_gem_object_change_domain+0x49/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82d0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 8 bytes):
    6f 62 6a 00 00 00 00 00                          obj.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d359a>]
ftrace_define_fields_i915_gem_object_change_domain+0x49/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e83c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    73 74 72 75 63 74 20 64 72 6d 5f 67 65 6d 5f 6f  struct drm_gem_o
    62 6a 65 63 74 20 2a 00 c5 e2 fb ff 25 08 00 00  bject *.....%...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d359a>]
ftrace_define_fields_i915_gem_object_change_domain+0x49/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e83e0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    a0 83 8e f5 00 84 8e f5 f0 d9 da f5 d8 82 bd f5  ................
    00 00 00 00 10 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d35d2>]
ftrace_define_fields_i915_gem_object_change_domain+0x81/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dad9f0 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    72 65 61 64 5f 64 6f 6d 61 69 6e 73 00 00 00 00  read_domains....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d35d2>]
ftrace_define_fields_i915_gem_object_change_domain+0x81/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82d8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 8 bytes):
    75 33 32 00 08 00 00 00                          u32.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d35d2>]
ftrace_define_fields_i915_gem_object_change_domain+0x81/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8400 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    e0 83 8e f5 fc 81 60 f8 00 da da f5 e0 82 bd f5  ......`.........
    00 00 00 00 14 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d360a>]
ftrace_define_fields_i915_gem_object_change_domain+0xb9/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dada00 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    77 72 69 74 65 5f 64 6f 6d 61 69 6e 00 00 00 00  write_domain....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d360a>]
ftrace_define_fields_i915_gem_object_change_domain+0xb9/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82e0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 8 bytes):
    75 33 32 00 ff ff ff ff                          u32.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d360a>]
ftrace_define_fields_i915_gem_object_change_domain+0xb9/0xdb [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8420 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    54 82 60 f8 40 84 8e f5 10 da da f5 20 da da f5  T.`.@....... ...
    00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dada10 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 74 79 70 65 00 00 00 00 00  common_type.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dada20 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 73 68 6f 72 74 00 00  unsigned short..
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8440 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    20 84 8e f5 60 84 8e f5 30 da da f5 40 da da f5   ...`...0...@...
    00 00 00 00 02 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dada30 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 66 6c 61 67 73 00 00 00 00  common_flags....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dada40 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b3b>] trace_define_common_fields+0x59/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8460 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    40 84 8e f5 a0 84 8e f5 80 84 8e f5 50 da da f5  @...........P...
    00 00 00 00 03 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8480 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 70 72 65 65 6d 70 74 5f 63  common_preempt_c
    6f 75 6e 74 00 00 00 00 f0 83 8e f5 08 00 00 00  ount............
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dada50 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    75 6e 73 69 67 6e 65 64 20 63 68 61 72 00 00 00  unsigned char...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3b77>] trace_define_common_fields+0x95/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e84a0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    60 84 8e f5 c0 84 8e f5 60 da da f5 e8 82 bd f5  `.......`.......
    00 00 00 00 04 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5dada60 (size 16):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 16 bytes):
    63 6f 6d 6d 6f 6e 5f 70 69 64 00 00 00 00 00 00  common_pid......
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82e8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 8 bytes):
    69 6e 74 00 75 a3 8a c0                          int.u...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3baf>] trace_define_common_fields+0xcd/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e84c0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    a0 84 8e f5 00 85 8e f5 e0 84 8e f5 f0 82 bd f5  ................
    00 00 00 00 08 00 00 00 04 00 00 00 01 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e84e0 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    63 6f 6d 6d 6f 6e 5f 6c 6f 63 6b 5f 64 65 70 74  common_lock_dept
    68 00 52 c0 31 c2 52 c0 d8 41 40 c0 ff ff ff ff  h.R.1.R..A@.....
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82f0 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 8 bytes):
    69 6e 74 00 2b dc 59 c0                          int.+.Y.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<c04d3be7>] trace_define_common_fields+0x105/0x12a
    [<f85d34fa>] ftrace_define_fields_i915_gem_object_clflush+0x10/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8500 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    c0 84 8e f5 54 82 60 f8 f8 82 bd f5 20 85 8e f5  ....T.`..... ...
    00 00 00 00 0c 00 00 00 04 00 00 00 00 00 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c04d3973>] trace_define_field+0x23/0x192
    [<f85d352f>] ftrace_define_fields_i915_gem_object_clflush+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf5bd82f8 (size 8):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 8 bytes):
    6f 62 6a 00 71 fd 52 c0                          obj.q.R.
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a0c>] trace_define_field+0xbc/0x192
    [<f85d352f>] ftrace_define_fields_i915_gem_object_clflush+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8520 (size 32):
  comm "modprobe", pid 2123, jiffies 4294698479
  hex dump (first 32 bytes):
    73 74 72 75 63 74 20 64 72 6d 5f 67 65 6d 5f 6f  struct drm_gem_o
    62 6a 65 63 74 20 2a 00 00 00 00 00 00 00 00 00  bject *.........
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
    [<c04ff2ac>] kstrdup+0x43/0x7b
    [<c04d3a33>] trace_define_field+0xe3/0x192
    [<f85d352f>] ftrace_define_fields_i915_gem_object_clflush+0x45/0x67 [i915]
    [<c04d3069>] event_create_dir+0x3d7/0x45a
    [<c04d33f3>] trace_module_notify+0x307/0x568
    [<c08c89d8>] notifier_call_chain+0x30/0x7f
    [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
    [<c047997e>] blocking_notifier_call_chain+0x11/0x13
    [<c0493009>] sys_init_module+0xd9/0x273
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8c80 (size 32):
  comm "Xorg", pid 2085, jiffies 4294698492
  hex dump (first 32 bytes):
    69 39 31 35 40 70 63 69 3a 30 30 30 30 3a 30 30  i915@pci:0000:00
    3a 30 32 2e 30 00 00 00 00 00 00 00 00 00 00 00  :02.0...........
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c05261bc>] __kmalloc+0x29d/0x31a
    [<f82a4fd5>] drm_setversion+0x20f/0x331 [drm]
    [<f82a2b99>] drm_ioctl+0x328/0x3f9 [drm]
    [<c0542019>] vfs_ioctl+0xb7/0xd0
    [<c0542935>] do_vfs_ioctl+0x81b/0x837
    [<c05429c4>] sys_ioctl+0x73/0xb1
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xed8fd2c0 (size 64):
  comm "gdm-simple-slav", pid 3178, jiffies 4294726331
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 f4 ad b9 f5 a6 09 47 c0 6b 0c 00 00  ..........G.k...
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c0525147>] kmem_cache_alloc+0x184/0x20a
    [<c0470278>] alloc_pid+0x1e/0x495
    [<c044fd34>] copy_process+0x105c/0x17bf
    [<c04506ed>] do_fork+0x256/0x556
    [<c0402444>] sys_clone+0x49/0x51
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf58e8e60 (size 32):
  comm "Xorg", pid 3179, jiffies 4294727166
  hex dump (first 32 bytes):
    69 39 31 35 40 70 63 69 3a 30 30 30 30 3a 30 30  i915@pci:0000:00
    3a 30 32 2e 30 00 e8 f5 72 b7 47 c0 00 02 20 00  :02.0...r.G... .
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c05261bc>] __kmalloc+0x29d/0x31a
    [<f82a4fd5>] drm_setversion+0x20f/0x331 [drm]
    [<f82a2b99>] drm_ioctl+0x328/0x3f9 [drm]
    [<c0542019>] vfs_ioctl+0xb7/0xd0
    [<c0542935>] do_vfs_ioctl+0x81b/0x837
    [<c05429c4>] sys_ioctl+0x73/0xb1
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf4ad8000 (size 2048):
  comm "Xorg", pid 3277, jiffies 4294796035
  hex dump (first 32 bytes):
    60 ce 8d c1 00 00 00 00 00 10 00 00 00 30 ff 34  `............0.4
    00 10 00 00 80 ce 8d c1 00 00 00 00 00 10 00 00  ................
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c05261bc>] __kmalloc+0x29d/0x31a
    [<c067c9ff>] sg_kmalloc+0x40/0x45
    [<c067c2c0>] __sg_alloc_table+0x6a/0x143
    [<c067c469>] sg_alloc_table+0x1a/0x5f
    [<c0734f8f>] intel_agp_map_memory+0x21/0x1ad
    [<c072fdbc>] agp_bind_memory+0xa0/0x124
    [<c072e401>] agp_ioctl+0x58d/0x624
    [<c0541fbe>] vfs_ioctl+0x5c/0xd0
    [<c0542935>] do_vfs_ioctl+0x81b/0x837
    [<c05429c4>] sys_ioctl+0x73/0xb1
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xf06e0400 (size 1024):
  comm "Xorg", pid 3277, jiffies 4294796147
  hex dump (first 32 bytes):
    40 d1 85 c1 00 00 00 00 00 10 00 00 00 a0 00 31  @..............1
    00 10 00 00 60 d1 85 c1 00 00 00 00 00 10 00 00  ....`...........
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c05261bc>] __kmalloc+0x29d/0x31a
    [<c067c9ff>] sg_kmalloc+0x40/0x45
    [<c067c2c0>] __sg_alloc_table+0x6a/0x143
    [<c067c469>] sg_alloc_table+0x1a/0x5f
    [<c0734f8f>] intel_agp_map_memory+0x21/0x1ad
    [<c072fdbc>] agp_bind_memory+0xa0/0x124
    [<c072e401>] agp_ioctl+0x58d/0x624
    [<c0541fbe>] vfs_ioctl+0x5c/0xd0
    [<c0542935>] do_vfs_ioctl+0x81b/0x837
    [<c05429c4>] sys_ioctl+0x73/0xb1
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff
unreferenced object 0xee100000 (size 2048):
  comm "Xorg", pid 3277, jiffies 4294796253
  hex dump (first 32 bytes):
    c0 cc 7e c1 00 00 00 00 00 10 00 00 00 60 7e 2d  ..~..........`~-
    00 10 00 00 e0 cc 7e c1 00 00 00 00 00 10 00 00  ......~.........
  backtrace:
    [<c08aa375>] kmemleak_alloc+0x100/0x13e
    [<c05261bc>] __kmalloc+0x29d/0x31a
    [<c067c9ff>] sg_kmalloc+0x40/0x45
    [<c067c2c0>] __sg_alloc_table+0x6a/0x143
    [<c067c469>] sg_alloc_table+0x1a/0x5f
    [<c0734f8f>] intel_agp_map_memory+0x21/0x1ad
    [<c072fdbc>] agp_bind_memory+0xa0/0x124
    [<c072e401>] agp_ioctl+0x58d/0x624
    [<c0541fbe>] vfs_ioctl+0x5c/0xd0
    [<c0542935>] do_vfs_ioctl+0x81b/0x837
    [<c05429c4>] sys_ioctl+0x73/0xb1
    [<c04041d8>] sysenter_do_call+0x12/0x2d
    [<ffffffff>] 0xffffffff

and the .config is here (only those "debug" and "kmemleak" extracted):

CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_SLUB_DEBUG=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PM_DEBUG=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_DEBUG_DEVRES=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_DEBUG=m
CONFIG_DM_DEBUG=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_MLX4_DEBUG=y
CONFIG_LIBERTAS_DEBUG=y
CONFIG_ATH5K_DEBUG=y
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_SND_DEBUG=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_USB_SERIAL_DEBUG=m
CONFIG_MEMSTICK_DEBUG=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2_DEBUG=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_UFS_DEBUG=y
CONFIG_DLM_DEBUG=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_SCHED_DEBUG=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
CONFIG_DEBUG_KMEMLEAK_TEST=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
CONFIG_DEBUG_KMEMLEAK_TEST=y
CONFIG_HAVE_ARCH_KMEMCHECK=y

> a few times, do they disappear? I think the debug_objects reports are
> false positives but couldn't figure why kmemleak cannot track
> them. I'll look again at them and maybe add an annotation
> (kmemleak_not_leak).

yes, i just read the above in Documentation/kmemleak.txt - which is a
form of whitelisting all the API known not to be leaking.   perhaps
the above errors can be used as the starting point ?? :-).

>
> --
> Catalin
>



-- 
Regards,
Peter Teoh
