Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZDXBqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZDXBqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 21:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZDXBqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 21:46:32 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:42013 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbZDXBq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 21:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YCQ1sYl0xYW8lA/sb+cFPHlxvjSvUQgwol/KozwQTaX5Jna1Z1t6gxI9UFRktqBFfc
         IxrdX3m8/6/Na6k/Uxi89u8rN3DIM+BfU9RWlsfSxymCv/20wzqnQKkDZeEz27pieqZf
         B1OyOCbG0R/u3GONWwo7iJzOe5404Dn7zPnEk=
MIME-Version: 1.0
In-Reply-To: <0483452db22e72f57289e63fcf097120d94c2a37.1240533480.git@localhost>
References: <0483452db22e72f57289e63fcf097120d94c2a37.1240533480.git@localhost>
Date: Fri, 24 Apr 2009 09:46:27 +0800
Message-ID: <777f39b10904231846v1d5419bby3deaebd826848e1a@mail.gmail.com>
Subject: Re: [PATCH 0/3] MIPS: Extend plat_* abstractions, cache support
From: Bob Zhang <2004.zhang@gmail.com>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now , I have ported suspend2 code (based on 2.4.21 patch) into mips
architecture, my kernel version is 2.4.21.

My Environment:
kernel:2.4.21
Architecture:mips 32: 4KEc
tty device : only has a serial port.



Now, we have finish 99% work-load, but at last ,we found a problem,
kernel panic after resume code has been executed completely , kernel
code has return the code after hibernate. but system have not return
console, it happened kernel panic.

in resume code, I added debugging code, I am sure, resume code has
been executed completely.
including ,reading pageset1 and pageset2,and copy kernel to original
location, restore cpu context and unfroze processes.

Could you please give me some ideas and suggestions ? thanks very much!


----------
Error output is like this;

Waking     5: bdflush.
Waking     6: kupdated.
Waking     7: mtdblockd.
Waking     8: khubd.
Waking    65: lircd.
Waking    67: inetd.
Waking    80: pure-ftpd.
Waking    81: sh.
Waking    86: hibernate.
Waking   163: hibernate.
Waking   164: tee.
About to restore original console.
swsusp_default_console_level = 1
console_loglevel=7
default_message_loglevel = 4
orig_default_message_loglevel=0
at end of do_software_suspend
Kernel unaligned instruction access in unaligned.c::do_ade, line 446:

CPU Regs : ===========================================================
$0 : 00000000 80290000 00000100 fffdffff 00000007 00000006 802342cc 820e83d4
$8 : 00000000 00000000 00000000 820e83dc 820e83f4 820e8000 80278010 00000000
$16: 8028f7b8 0000debe 00001ebe 802a53a0 0000dee0 7fff7d48 00000004 00000014
$24: 8200000c 2abe4090                   820e8000 820e9e70 00000000 0000000a
Hi : 0000007a
Lo : 000000b7
epc   : 0000000a    Tainted: G Z
Status: 10008403
Cause : 10800010
PrId  : 0001906c
Process init (pid: 1, stackpage=820e8000)
show_stack ============================================================
Stack:    80287ce0 0000003e 0000003c 800b93cc 00000000 00000400 80111bb0
 00000000 00001ee0 ffffffff 0000dee0 10008400 00000001 800b9460 0000000b
 00000189 00000004 00000001 10008400 802a4fc4 80287cf0 10008400 00000001
 0000000a 80287ce0 0000003c 800b9ac0 800b99bc 80239200 10008400 802391bc
 80239200 802a4fc2 802a4fc4 800b9868 820b6d94 00000189 820b72e0 80238b12
 7fff7ba8 00000022 00000000 8028a23c 80287cdc 80239200 802391bc 802391bc
 80239200 80287cdc 00000014 00000005 800da9e4 80238af0 19669944 83feb000
 8028a9d4 00000202 00000000 0000000b 7fff7ba8 00000000 00000001 00008400
 820b1ea0 00000000 00000002 8028a9d4 00000003 820e9ef8 00000002 00000000
 7fff7ba8 0000000b 00000000 7fff7a28 7fff7d48 00000004 00000014 00000000
 2ab61a30 00000000 00000000 2abe7bf0 7fff79b8 00000005 0040709c 00000000
 00000000 2ab61a94 00000008 00008413 10800020 fbbffffe fb7fefff ffffdffb
 bbefefef fdf67ffe b6e5efbd f7f7fff6 efedffff
show_trace =============================================================


Call Trace:
[<800b93cc>__call_console_drivers ]
[<80111bb0>do_select]
[<800b9460> _call_console_drivers ]
[<800b9ac0>release_console_sem]
[<800b99bc>release_console_sem]

[<80239200>] [<802391bc>] [<80239200>] [<800b9868>] [<80238b12>] [<80239200>]
 [<802391bc>] [<802391bc>] [<80239200>] [<800da9e4>] [<80238af0>]
show_code ==============================================================

Code:<7>init: Forwarding exception at [<800acfe0>] (80256a18)
 (Bad address in epc)

Kernel panic: Attempted to kill init!
 UART_MSR_ANY_DELTA




===================================Error Output End ======================


>From the error messages, it seems that the function named
"__call_console_drivers() has problem.
I know, printk() will call release_console_sem to call
__call_console_drivers() to call specify serial driver to output
kernel output.

I found when resume,  __call_console_drivers didn't call specified
serial driver successfully.
When suspend:
first, it can call serial driver(I added debugging info in serial driver).
but after processes frozen, serial driver messages can't be printed
out, but printk work well.
for example , printk("my name is bob \n"); can output to console
successfully, but serial driver messages can't be printed out.


what I tried:

1, because i only have serial console. so I feel that , I don't need
"CONFIG_VT" AND CONFIG_VT_CONSOLE.
I have selected CONFIG_SERIAL AND CONFIG_SERIAL_CONSOLE.

The problem still exist.


2, I have implemented save cpu context and restore cpu context.
//char __nosavedata swsusp_pg_dir[PAGE_SIZE] __attribute__ ((aligned
(PAGE_SIZE)));

/* image of the saved processor states
 * Based on MIPS registers ,refine it , bob
 */
struct saved_context {
       u32     zero;      /* wired zero */
       u32     AT;      /* assembler temp  - uppercase because of ".set at" */
       u32 v0  ;         /* return value */
       u32  v1  ;
       u32  a0  ;         /* argument registers */
       u32  a1  ;
       u32  a2 ;
       u32  a3   ;
       u32  t0    ;        /* caller saved */
       u32  t1   ;
       u32  t2   ;
       u32  t3   ;
       u32  t4   ;
       u32  t5  ;
       u32  t6   ;
       u32  t7    ;
       u32  s0   ;       /* callee saved */
       u32  s1   ;
       u32  s2   ;
       u32  s3   ;
       u32  s4  ;
       u32  s5    ;
       u32  s6   ;
       u32  s7   ;
       u32  t8   ;       /* caller saved */
       u32  t9   ;
       u32  jp   ;        /* PIC jump register */
       u32  k0  ;        /* kernel scratch */
       u32  k1  ;
       u32  gp  ;         /* global pointer */
       u32  sp  ;        /* stack pointer */
       u32  fp  ;         /* frame pointer */
       u32  s8 ;       /* same like fp! */
       u32  ra  ;         /* return address */

       /* special registers */
       u32 hi;
       u32 lo;

       /* cp0 */
       u32 cp0[32];

};

struct saved_context saved_contexts[NR_CPUS];
struct saved_context saved_context;     /* temporary storage */


static inline void save_processor_context(void)
{
       //bob
       //kernel_fpu_begin();

//      asm volatile (".set     noreorder");
       /* save all 32 registers of MIPS */

       //only debug,  I am not sure ,bob
       //I didn't save $0 , it is useless for us,because it is always 0 ,
like /dev/null
       asm volatile ("sw $1,   (%0)"  : "=m" (saved_context.AT));
       asm volatile ("sw $2,   (%0)"  : "=m" (saved_context.v0));
       asm volatile ("sw $3,   (%0)"  : "=m" (saved_context.v1));
       asm volatile ("sw $4,   (%0)"  : "=m" (saved_context.a0));
       asm volatile ("sw $5,   (%0)"  : "=m" (saved_context.a1));
       asm volatile ("sw $6,   (%0)"  : "=m" (saved_context.a2));
       asm volatile ("sw $7,   (%0)"  : "=m" (saved_context.a3));
       asm volatile ("sw $8,   (%0)"  : "=m" (saved_context.t0));
       asm volatile ("sw $9,   (%0)"  : "=m" (saved_context.t1));
       asm volatile ("sw $10,  (%0)"  : "=m" (saved_context.t2));
       asm volatile ("sw $11,  (%0)"  : "=m" (saved_context.t3));
       asm volatile ("sw $12,  (%0)"  : "=m" (saved_context.t4));
       asm volatile ("sw $13,  (%0)"  : "=m" (saved_context.t5));
       asm volatile ("sw $14,  (%0)"  : "=m" (saved_context.t6));
       asm volatile ("sw $15,  (%0)"  : "=m" (saved_context.t7));
       asm volatile ("sw $16,  (%0)"  : "=m" (saved_context.s0));
       asm volatile ("sw $17,  (%0)"  : "=m" (saved_context.s1));
       asm volatile ("sw $18,  (%0)"  : "=m" (saved_context.s2));
       asm volatile ("sw $19,  (%0)"  : "=m" (saved_context.s3));
       asm volatile ("sw $20,  (%0)"  : "=m" (saved_context.s4));
       asm volatile ("sw $21,  (%0)"  : "=m" (saved_context.s5));
       asm volatile ("sw $22,  (%0)"  : "=m" (saved_context.s6));
       asm volatile ("sw $23,  (%0)"  : "=m" (saved_context.s7));
       asm volatile ("sw $24,  (%0)"  : "=m" (saved_context.t8));

       asm volatile ("sw $25,  (%0)"  : "=m" (saved_context.t9));  //jp and t9
       asm volatile ("sw $25,  (%0)"  : "=m" (saved_context.jp));  //jp and t9

       asm volatile ("sw $26,  (%0)"  : "=m" (saved_context.k0));
       asm volatile ("sw $27,  (%0)"  : "=m" (saved_context.k1));
       asm volatile ("sw $28,  (%0)"  : "=m" (saved_context.gp));
       asm volatile ("sw $29,  (%0)"  : "=m" (saved_context.sp));

       asm volatile ("sw $30,  (%0)"  : "=m" (saved_context.fp));// fp and s8
       asm volatile ("sw $30,  (%0)"  : "=m" (saved_context.s8));  //jp and t9
       asm volatile ("sw $31,  (%0)"  : "=m" (saved_context.ra));




       /*
        * special registers
        */
       asm volatile ("mfhi %0" : "=r" (saved_context.hi));
       asm volatile ("mflo %0" : "=r" (saved_context.lo));
       // load/link register??

       /*
        * coprocessor 0 registers (inclde/asm-mips/mipsregs.h)
        */
       asm volatile ("mfc0 %0, $0" : "=r" (saved_context.cp0[0]));
       asm volatile ("mfc0 %0, $1" : "=r" (saved_context.cp0[1]));
       asm volatile ("mfc0 %0, $2" : "=r" (saved_context.cp0[2]));
       asm volatile ("mfc0 %0, $3" : "=r" (saved_context.cp0[3]));
       asm volatile ("mfc0 %0, $4" : "=r" (saved_context.cp0[4]));
       asm volatile ("mfc0 %0, $5" : "=r" (saved_context.cp0[5]));
       asm volatile ("mfc0 %0, $6" : "=r" (saved_context.cp0[6]));
       asm volatile ("mfc0 %0, $7" : "=r" (saved_context.cp0[7]));
       asm volatile ("mfc0 %0, $8" : "=r" (saved_context.cp0[8]));
       asm volatile ("mfc0 %0, $9" : "=r" (saved_context.cp0[9]));
       asm volatile ("mfc0 %0, $10" : "=r" (saved_context.cp0[10]));
       asm volatile ("mfc0 %0, $11" : "=r" (saved_context.cp0[11]));
       asm volatile ("mfc0 %0, $12" : "=r" (saved_context.cp0[12]));
       asm volatile ("mfc0 %0, $13" : "=r" (saved_context.cp0[13]));
       asm volatile ("mfc0 %0, $14" : "=r" (saved_context.cp0[14]));  //EPC
       asm volatile ("mfc0 %0, $15" : "=r" (saved_context.cp0[15]));
       asm volatile ("mfc0 %0, $16" : "=r" (saved_context.cp0[16]));
       asm volatile ("mfc0 %0, $17" : "=r" (saved_context.cp0[17]));
       asm volatile ("mfc0 %0, $18" : "=r" (saved_context.cp0[18]));
       asm volatile ("mfc0 %0, $19" : "=r" (saved_context.cp0[19]));
       asm volatile ("mfc0 %0, $20" : "=r" (saved_context.cp0[20]));
       asm volatile ("mfc0 %0, $21" : "=r" (saved_context.cp0[21]));
       asm volatile ("mfc0 %0, $22" : "=r" (saved_context.cp0[22]));
       asm volatile ("mfc0 %0, $23" : "=r" (saved_context.cp0[23]));
       asm volatile ("mfc0 %0, $24" : "=r" (saved_context.cp0[24]));
       asm volatile ("mfc0 %0, $25" : "=r" (saved_context.cp0[25]));
       asm volatile ("mfc0 %0, $26" : "=r" (saved_context.cp0[26]));
       asm volatile ("mfc0 %0, $27" : "=r" (saved_context.cp0[27]));
       asm volatile ("mfc0 %0, $28" : "=r" (saved_context.cp0[28]));
       asm volatile ("mfc0 %0, $29" : "=r" (saved_context.cp0[29]));
       asm volatile ("mfc0 %0, $30" : "=r" (saved_context.cp0[30]));
       asm volatile ("mfc0 %0, $31" : "=r" (saved_context.cp0[31]));


}


static inline void restore_processor_context(void)
{
//      asm volatile (".set     noreorder");
       asm volatile (".align 4");

       /*
        * coprocessor 0 registers
        */
       asm volatile ("mtc0 %0, $0" : : "r" (saved_context.cp0[0]));
       asm volatile ("mtc0 %0, $1" : : "r" (saved_context.cp0[1]));
       asm volatile ("mtc0 %0, $2" : : "r" (saved_context.cp0[2]));
       asm volatile ("mtc0 %0, $3" : : "r" (saved_context.cp0[3]));
       asm volatile ("mtc0 %0, $4" : : "r" (saved_context.cp0[4]));
       asm volatile ("mtc0 %0, $5" : : "r" (saved_context.cp0[5]));
       asm volatile ("mtc0 %0, $6" : : "r" (saved_context.cp0[6]));
       asm volatile ("mtc0 %0, $7" : : "r" (saved_context.cp0[7]));
       asm volatile ("mtc0 %0, $8" : : "r" (saved_context.cp0[8]));
       asm volatile ("mtc0 %0, $9" : : "r" (saved_context.cp0[9]));
       asm volatile ("mtc0 %0, $10" : : "r" (saved_context.cp0[10]));
       asm volatile ("mtc0 %0, $11" : : "r" (saved_context.cp0[11]));
       asm volatile ("mtc0 %0, $12" : : "r" (saved_context.cp0[12]));
       asm volatile ("mtc0 %0, $13" : : "r" (saved_context.cp0[13]));
       asm volatile ("mtc0 %0, $14" : : "r" (saved_context.cp0[14]));  //epc
       asm volatile ("mtc0 %0, $15" : : "r" (saved_context.cp0[15]));
       asm volatile ("mtc0 %0, $16" : : "r" (saved_context.cp0[16]));
       asm volatile ("mtc0 %0, $17" : : "r" (saved_context.cp0[17]));
       asm volatile ("mtc0 %0, $18" : : "r" (saved_context.cp0[18]));
       asm volatile ("mtc0 %0, $19" : : "r" (saved_context.cp0[19]));
       asm volatile ("mtc0 %0, $20" : : "r" (saved_context.cp0[20]));
       asm volatile ("mtc0 %0, $21" : : "r" (saved_context.cp0[21]));
       asm volatile ("mtc0 %0, $22" : : "r" (saved_context.cp0[22]));
       asm volatile ("mtc0 %0, $23" : : "r" (saved_context.cp0[23]));
       asm volatile ("mtc0 %0, $24" : : "r" (saved_context.cp0[24]));
       asm volatile ("mtc0 %0, $25" : : "r" (saved_context.cp0[25]));
       asm volatile ("mtc0 %0, $26" : : "r" (saved_context.cp0[26]));
       asm volatile ("mtc0 %0, $27" : : "r" (saved_context.cp0[27]));
       asm volatile ("mtc0 %0, $28" : : "r" (saved_context.cp0[28]));
       asm volatile ("mtc0 %0, $29" : : "r" (saved_context.cp0[29]));
       asm volatile ("mtc0 %0, $30" : : "r" (saved_context.cp0[30]));
       asm volatile ("mtc0 %0, $31" : : "r" (saved_context.cp0[31]));

       /*
        * special registers
        */
       asm volatile ("mthi %0" : : "r" (saved_context.hi));
       asm volatile ("mtlo %0" : : "r" (saved_context.lo));



       asm volatile ("lw $1,(%0)"   :: "r" (&saved_context.AT));
       asm volatile ("lw $2,(%0)"   :: "r" (&saved_context.v0));
       asm volatile ("lw $3,(%0)"   :: "r" (&saved_context.v1));
       asm volatile ("lw $4,(%0)"   :: "r" (&saved_context.a0));
       asm volatile ("lw $5,(%0)"   :: "r" (&saved_context.a1));
       asm volatile ("lw $6,(%0)"   :: "r" (&saved_context.a2));
       asm volatile ("lw $7,(%0)"   :: "r" (&saved_context.a3));
       asm volatile ("lw $8,(%0)"   :: "r" (&saved_context.t0));
       asm volatile ("lw $9,(%0)"   :: "r" (&saved_context.t1));
       asm volatile ("lw $10,(%0)"  :: "r" (&saved_context.t2));
       asm volatile ("lw $11,(%0)"  :: "r" (&saved_context.t3));
       asm volatile ("lw $12,(%0)"  :: "r" (&saved_context.t4));
       asm volatile ("lw $13,(%0)"  :: "r" (&saved_context.t5));
       asm volatile ("lw $14,(%0)"  :: "r" (&saved_context.t6));
       asm volatile ("lw $15,(%0)"  :: "r" (&saved_context.t7));
       asm volatile ("lw $16,(%0)"  :: "r" (&saved_context.s0));
       asm volatile ("lw $17,(%0)"  :: "r" (&saved_context.s1));
       asm volatile ("lw $18,(%0)"  :: "r" (&saved_context.s2));
       asm volatile ("lw $19,(%0)"  :: "r" (&saved_context.s3));
       asm volatile ("lw $20,(%0)"  :: "r" (&saved_context.s4));
       asm volatile ("lw $21,(%0)"  :: "r" (&saved_context.s5));
       asm volatile ("lw $22,(%0)"  :: "r" (&saved_context.s6));
       asm volatile ("lw $23,(%0)"  :: "r" (&saved_context.s7));
       asm volatile ("lw $24,(%0)"  :: "r" (&saved_context.t8));

       asm volatile ("lw $25,(%0)"  :: "r" (&saved_context.t9));  //jp and t9
//      asm volatile ("lw $25,(%0)"  :: "r" (&saved_context.jp));  //jp and t9

       asm volatile ("lw $26,(%0)"  :: "r" (&saved_context.k0));
       asm volatile ("lw $27,(%0)"  :: "r" (&saved_context.k1));
       asm volatile ("lw $28,(%0)"  :: "r" (&saved_context.gp));
       asm volatile ("lw $29,(%0)"  :: "r" (&saved_context.sp));

       asm volatile ("lw $30,(%0)"  :: "r" (&saved_context.fp));// fp and s8
//      asm volatile ("lw $30,(%0)"  :: "r" (&saved_context.s8));  //jp and t9
       asm volatile ("lw $31,(%0)"  :: "r" (&saved_context.ra));

       //do_fpu_end();
}



3,  complete resume booting info and error messages:

*call = 80274ef8
Linux video capture interface: v1.00
*call = 80275708
*call = 80276430
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 512 buckets, 4Kbytes
TCP: Hash tables configured (established 4096 bind 4096)
*call = 802767f0
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
initcalls done
initcalls done2
basic setup 4
at start of software_resume2Calling dump_stack() ,
file(swsusp2.c),function(software_resume2),line(1245)
This architecture does not implement dump_stack()
Looking for first block of swap header at block 0.
Setting logical block size of resume device to 4096.
Software Suspend 2.0: Attempting to set blocksize for 302 to 4096.
wait_on_one_page(io_info);
enter wait_on_on_page() ,io_info address=821f0000
will sync
sync_swap_partitions over
into do_suspend_sync()
Software Suspend 2.0: Swap space signature found.
now in function :attempt_to_parse_resume_device
now software_suspend_state = 0
will into swsusp_init_proc() , line:1265 , file:swsusp2.c
numfiles=13
Software Suspend 2.0: Checking for image...
when about to read primary image
Calling dump_stack() , file(swsusp2.c),function(software_resume2),line(1287)
This architecture does not implement dump_stack()
at entrance to __read_primary_suspend_image
wait_on_one_page(io_info);
enter wait_on_on_page() ,io_info address=821f004c
will sync
sync_swap_partitions over
into do_suspend_sync()
after checking whether image exists
before preparing to read header
wait_on_one_page(io_info);
enter wait_on_on_page() ,io_info address=821f0098
will sync
sync_swap_partitions over
into do_suspend_sync()
before preparing to read suspend header
before doing sanity check
has into pm_prepare_console
About to read pagedir.
Reading 2 range pages.
Reading range page 0 [821dc000].
wait_on_one_page(io_info);
enter wait_on_on_page() ,io_info address=821f00e4
will sync
sync_swap_partitions over
into do_suspend_sync()
Reading range page 1 [821db000].
wait_on_one_page(io_info);
enter wait_on_on_page() ,io_info address=821f0130
will sync
sync_swap_partitions over
into do_suspend_sync()
Pagedir_resume.pageset_size is 5903

Allocating memory.
pagedir_resume.pageset_size=5903
Check_pagedir: Prepared 5903 of 5903 pages.
Pagedir prepared. About to read pageset 1.
at start of read pageset
Reading kernel & process data...

finish_at=5903
 23/32 MB |
Finish I/O, flush data and cleanup reads.
statistics
Time to read data: 5903 pages in 297 jiffies => MB read per second: 7.
at end of read pageset

after loading image.
About to restore original kernel.
Calling dump_stack() , file(swsusp2.c),function(software_resume2),line(1292)
This architecture does not implement dump_stack()
Calling dump_stack() , file(swsusp2.c),function(software_resume2),line(1307)
This architecture does not implement dump_stack()
process(ksoftirqd_CPU0) (3) is a syncthread at entrance to fridge
process(mtdblockd) (7) is a syncthread at entrance to fridge
process(khubd) (8) is a syncthread at entrance to fridge
into do_suspend_sync()
before FREEZE_UNREFRIGERATED , swsusp_state=1
begin to freeze remaining processes
Signalling.
keventd thread 2
we try to wake up process(keventd) ,pid(2) , its state is 1
,ksoftirqd_CPU0 thread 3
we try to wake up process(ksoftirqd_CPU0) ,pid(3) , its state is 1
,kswapd thread 4
we try to wake up process(kswapd) ,pid(4) , its state is 1
,bdflush thread 5
we try to wake up process(bdflush) ,pid(5) , its state is 1
,kupdated thread 6
we try to wake up process(kupdated) ,pid(6) , its state is 0
,mtdblockd thread 7
we try to wake up process(mtdblockd) ,pid(7) , its state is 1
,khubd thread 8
we try to wake up process(khubd) ,pid(8) , its state is 1
numsignalled=7
Schedule.
kupdated (6) refrigerated and sigpending recalculated.
kupdated (6) refrigerated.
keventd (2) refrigerated and sigpending recalculated.
keventd (2) refrigerated.
kswapd (4) refrigerated and sigpending recalculated.
kswapd (4) refrigerated.
bdflush (5) refrigerated and sigpending recalculated.
bdflush (5) refrigerated.
mtdblockd (7) refrigerated and sigpending recalculated.
mtdblockd (7) refrigerated.
khubd (8) refrigerated and sigpending recalculated.
khubd (8) refrigerated.
ksoftirqd_CPU0 (3) refrigerated and sigpending recalculated.
ksoftirqd_CPU0 (3) refrigerated.
Examine effect.
 newtodo = 0
Waiting on:
Calling dump_stack() , file(swsusp2.c),function(software_resume2),line(1312)
This architecture does not implement dump_stack()
Copying original kernel back (no status - sensitive!)...

Prior to calling do_swsusp_lowlevel.

before do_swsusp_lowlevel(1)
Calling dump_stack() , file(swsusp2.c),function(software_resume2),line(1327)
This architecture does not implement dump_stack()
swapper_pg_dir = 0x8027a000
Putting other CPUs in swsusp_lowevel in preparation for restoring contexts:

Done.
into do_suspend_sync()
host/usb-ohci.c: USB suspend: usb-00:00.0
ehci_hcd 00:01.0: suspend to state 3
Software Suspend 2.0: Waiting for DMAs to settle down...
Software Suspend 2.0: About to copy pageset1 back...
after do_swsusp_resume_1()
origoffset=0
copyoffset=768
max_low_pfn = 16384
min_low_pfn = 699
will restore_processor_context()
will flush_tlb_all()
will into do_swsusp2_resume_2()
In resume_2 after copy back.
will drivers_resume()
drivers_resume() will RESUME_PHASE2
About to reload secondary pagedir.
Beginning of read_secondary_pagedir:
at start of read pageset
Reading caches...

finish_at=2478
 9/9 MB |
Finish I/O, flush data and cleanup reads.
sync_swap_partitions over
into do_suspend_sync()
statistics
Time to read data: 2478 pages in 124 jiffies => MB read per second: 7.
at end of read pageset

Pagedir 2 read over .

Cleaning up...No Removing image for debugging easily
Removing image...
wait_on_one_page(io_info);
enter wait_on_on_page() ,io_info address=838c1000
will sync
sync_swap_partitions over
into do_suspend_sync()
wait_on_one_page(io_info);
enter wait_on_on_page() ,io_info address=838c104c
will sync
sync_swap_partitions over
into do_suspend_sync()
In resume_2 after fpu end.After unlocking irq_lock.
Resume drivers.
drivers_resume() will RESUME_PHASE2
Argh. Chip not in PM_SUSPENDED state upon resume()
PCI: Enabling bus mastering for device 00:00.0
host/usb-ohci.c: USB continue: usb-00:00.0 from host wakeup
ehci_hcd 00:01.0: resume
ok
At exit from save_image.
enable_swapfile
swapfilename=/dev/hda2
active swap partition result=0
Please include the following information in bug reports:
- SWSUSP core    : 2.0
- Kernel Version : 2.4.21-xfs
- Version spec.  : 2.0.0
- Compiler vers. : 2.91
- Modules loaded : emma_capcom demux vfat fat nfs lockd sunrpc dvbdev
venc emma_teletext emma_av emma_osd emma_bios emma_rtos zlib_deflate
- Attempt number : 1
- Pageset sizes  : 5903 and 2478 (2478 low).
- Parameters     : 0 2048 0 1 0 32
- Calculations   : Image size: 2489. Ram to suspend: 162.
- Limits         : 16384 pages RAM. Initial boot: 11232.
- Overall expected compression percentage: 0.
- Swapwriter active.
 Attempting to automatically swapon: /dev/hda2.
 Swap available for image: 0.
- Debugging compiled in.
- Max ranges used: 358 ranges in 2 pages.
Please include the following information in bug reports:
- SWSUSP core    : 2.0
- Kernel Version : 2.4.21-xfs
- Version spec.  : 2.0.0
- Compiler vers. : 2.91
- Modules loaded : emma_capcom demux vfat fat nfs lockd sunrpc dvbdev
venc emma_teletext emma_av emma_osd emma_bios emma_rtos zlib_deflate
- Attempt number : 1
- Pageset sizes  : 5903 and 2478 (2478 low).
- Parameters     : 0 2048 0 1 0 32
- Calculations   : Image size: 2489. Ram to suspend: 162.
- Limits         : 16384 pages RAM. Initial boot: 11232.
- Overall expected compression percentage: 0.
- Swapwriter active.
 Attempting to automatically swapon: /dev/hda2.
 Swap available for image: 0.
- Debugging compiled in.
- Max ranges used: 358 ranges in 2 pages.
will unsuspend IDE harddisk
free_pagedir(pagedir2)
free_pagedir(pagedir1)
wait_on_one_page(io_info);
enter wait_on_on_page() ,io_info address=838c1098
will sync
sync_swap_partitions over
into do_suspend_sync()
kstat_restore()
thaw_processes
Waking     1: init.
Waking     2: keventd.
Waking     3: ksoftirqd_CPU0.
Waking     4: kswapd.
Waking     5: bdflush.
Waking     6: kupdated.
Waking     7: mtdblockd.
Waking     8: khubd.
Waking    65: lircd.
Waking    67: inetd.
Waking    80: pure-ftpd.
Waking    81: sh.
Waking    86: hibernate.
Waking   163: hibernate.
Waking   164: tee.
About to restore original console.
swsusp_default_console_level = 1
console_loglevel=7
default_message_loglevel = 4
orig_default_message_loglevel=0
at end of do_software_suspend
Kernel unaligned instruction access in unaligned.c::do_ade, line 446:

CPU Regs : ===========================================================
$0 : 00000000 80290000 00000100 fffdffff 00000007 00000006 802342cc 820e83d4
$8 : 00000000 00000000 00000000 820e83dc 820e83f4 820e8000 80278010 00000000
$16: 8028f7b8 0000debe 00001ebe 802a53a0 0000dee0 7fff7d48 00000004 00000014
$24: 8200000c 2abe4090                   820e8000 820e9e70 00000000 0000000a
Hi : 0000007a
Lo : 000000b7
epc   : 0000000a    Tainted: G Z
Status: 10008403
Cause : 10800010
PrId  : 0001906c
Process init (pid: 1, stackpage=820e8000)
show_stack ============================================================
Stack:    80287ce0 0000003e 0000003c 800b93cc 00000000 00000400 80111bb0
 00000000 00001ee0 ffffffff 0000dee0 10008400 00000001 800b9460 0000000b
 00000189 00000004 00000001 10008400 802a4fc4 80287cf0 10008400 00000001
 0000000a 80287ce0 0000003c 800b9ac0 800b99bc 80239200 10008400 802391bc
 80239200 802a4fc2 802a4fc4 800b9868 820b6d94 00000189 820b72e0 80238b12
 7fff7ba8 00000022 00000000 8028a23c 80287cdc 80239200 802391bc 802391bc
 80239200 80287cdc 00000014 00000005 800da9e4 80238af0 19669944 83feb000
 8028a9d4 00000202 00000000 0000000b 7fff7ba8 00000000 00000001 00008400
 820b1ea0 00000000 00000002 8028a9d4 00000003 820e9ef8 00000002 00000000
 7fff7ba8 0000000b 00000000 7fff7a28 7fff7d48 00000004 00000014 00000000
 2ab61a30 00000000 00000000 2abe7bf0 7fff79b8 00000005 0040709c 00000000
 00000000 2ab61a94 00000008 00008413 10800020 fbbffffe fb7fefff ffffdffb
 bbefefef fdf67ffe b6e5efbd f7f7fff6 efedffff
show_trace =============================================================
Call Trace:   [<800b93cc>] [<80111bb0>] [<800b9460>] [<800b9ac0>] [<800b99bc>]
 [<80239200>] [<802391bc>] [<80239200>] [<800b9868>] [<80238b12>] [<80239200>]
 [<802391bc>] [<802391bc>] [<80239200>] [<800da9e4>] [<80238af0>]
show_code ==============================================================

Code:<7>init: Forwarding exception at [<800acfe0>] (80256a18)
 (Bad address in epc)

Kernel panic: Attempted to kill init!
 UART_MSR_ANY_DELTA
DSI_INIT!MMAC_CONFIG_InitialiseEMMAMMAC_CONFIG_InitialiseProcessor(main)
MMAC_CONFIG_InitRamVectors
DSI_INIT!
### MAIN PROCESSOR ### GENERAL EXCEPTION: Interrupt exception ###
