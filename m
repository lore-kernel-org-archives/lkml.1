Return-Path: <linux-kernel-owner+w=401wt.eu-S934065AbXJOSiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbXJOSiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933923AbXJOSeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:34:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:47798 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933900AbXJOSeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:34:04 -0400
Message-ID: <4713B263.5090909@windriver.com>
Date: Mon, 15 Oct 2007 13:33:07 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ralf@linux-mips.org
Subject: [PATCH 9/21] KGDB: This adds basic support to the MIPS architecture
Content-Type: multipart/mixed;
 boundary="------------050407090301090207030201"
X-OriginalArrivalTime: 15 Oct 2007 18:33:51.0640 (UTC) FILETIME=[EF013980:01C80F59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050407090301090207030201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------050407090301090207030201
Content-Type: text/x-patch;
 name="mips-lite.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mips-lite.patch"

mips-lite.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: ralf@linux-mips.org
Subject: [PATCH] This adds basic support to the MIPS architecture

This patch also adds support for the rs232 early kgdb access for MIPS
Malta (via 8250), SiByte 1250-SWARM (32 and 64bit, custom UART), all
from Manish Lachwani, and Toshiba TX493x platforms from Sergei
Shtylyov.

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Tom Rini <trini@kernel.crashing.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/mips/Kconfig                                          |    8 
 arch/mips/Kconfig.debug                                    |   22 
 arch/mips/au1000/common/Makefile                           |    1 
 arch/mips/au1000/common/dbg_io.c                           |  121 -
 arch/mips/basler/excite/Makefile                           |    1 
 arch/mips/basler/excite/excite_dbg_io.c                    |  121 -
 arch/mips/basler/excite/excite_irq.c                       |    7 
 arch/mips/basler/excite/excite_setup.c                     |    4 
 arch/mips/jmr3927/rbhma3100/Makefile                       |    1 
 arch/mips/jmr3927/rbhma3100/kgdb_io.c                      |  105 -
 arch/mips/kernel/Makefile                                  |    3 
 arch/mips/kernel/gdb-low.S                                 |  394 ----
 arch/mips/kernel/gdb-stub.c                                | 1154 -------------
 arch/mips/kernel/irq.c                                     |   33 
 arch/mips/kernel/kgdb-jmp.c                                |  112 +
 arch/mips/kernel/kgdb-setjmp.S                             |   28 
 arch/mips/kernel/kgdb.c                                    |  293 +++
 arch/mips/kernel/kgdb_handler.S                            |  339 +++
 arch/mips/kernel/traps.c                                   |   13 
 arch/mips/mips-boards/atlas/Makefile                       |    1 
 arch/mips/mips-boards/atlas/atlas_gdb.c                    |   97 -
 arch/mips/mips-boards/atlas/atlas_setup.c                  |    7 
 arch/mips/mips-boards/generic/Makefile                     |    1 
 arch/mips/mips-boards/generic/gdb_hook.c                   |  133 -
 arch/mips/mips-boards/generic/init.c                       |   62 
 arch/mips/mips-boards/malta/malta_setup.c                  |    8 
 arch/mips/mm/extable.c                                     |    7 
 arch/mips/pci/fixup-atlas.c                                |   21 
 arch/mips/philips/pnx8550/common/Makefile                  |    1 
 arch/mips/philips/pnx8550/common/gdb_hook.c                |  109 -
 arch/mips/philips/pnx8550/common/setup.c                   |   11 
 arch/mips/pmc-sierra/yosemite/Makefile                     |    1 
 arch/mips/pmc-sierra/yosemite/dbg_io.c                     |  180 --
 arch/mips/pmc-sierra/yosemite/irq.c                        |    9 
 arch/mips/sgi-ip22/ip22-setup.c                            |   24 
 arch/mips/sgi-ip27/Makefile                                |    1 
 arch/mips/sgi-ip27/ip27-dbgio.c                            |   60 
 arch/mips/sibyte/bcm1480/irq.c                             |   81 
 arch/mips/sibyte/cfe/setup.c                               |   14 
 arch/mips/sibyte/sb1250/irq.c                              |   64 
 arch/mips/sibyte/sb1250/kgdb_sibyte.c                      |  145 +
 arch/mips/sibyte/swarm/Makefile                            |    2 
 arch/mips/sibyte/swarm/dbg_io.c                            |   76 
 arch/mips/tx4927/common/Makefile                           |    1 
 arch/mips/tx4927/common/tx4927_dbgio.c                     |   46 
 arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c |   12 
 arch/mips/tx4938/common/Makefile                           |    1 
 arch/mips/tx4938/common/dbgio.c                            |   50 
 arch/mips/tx4938/toshiba_rbtx4938/setup.c                  |   10 
 drivers/serial/Makefile                                    |    1 
 drivers/serial/serial_txx9.c                               |   13 
 drivers/serial/serial_txx9_kgdb.c                          |  152 +
 include/asm-mips/asmmacro-32.h                             |   43 
 include/asm-mips/asmmacro-64.h                             |   99 +
 include/asm-mips/kdebug.h                                  |   30 
 include/asm-mips/kgdb.h                                    |   48 
 lib/Kconfig.kgdb                                           |   19 
 57 files changed, 1384 insertions(+), 3016 deletions(-)

--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -46,28 +46,6 @@ config SMTC_IDLE_HOOK_DEBUG
 	  arch/mips/kernel/smtc.c.  This debugging option result in significant
 	  overhead so should be disabled in production kernels.
 
-config KGDB
-	bool "Remote GDB kernel debugging"
-	depends on DEBUG_KERNEL && SYS_SUPPORTS_KGDB
-	select DEBUG_INFO
-	help
-	  If you say Y here, it will be possible to remotely debug the MIPS
-	  kernel using gdb. This enlarges your kernel image disk size by
-	  several megabytes and requires a machine with more than 16 MB,
-	  better 32 MB RAM to avoid excessive linking time. This is only
-	  useful for kernel hackers. If unsure, say N.
-
-config SYS_SUPPORTS_KGDB
-	bool
-
-config GDB_CONSOLE
-	bool "Console output to GDB"
-	depends on KGDB
-	help
-	  If you are using GDB for remote debugging over a serial port and
-	  would like kernel messages to be formatted into GDB $O packets so
-	  that GDB prints them as program output, say 'Y'.
-
 config SB1XXX_CORELIS
 	bool "Corelis Debugger"
 	depends on SIBYTE_SB1xxx_SOC
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -60,7 +60,8 @@ obj-$(CONFIG_MIPS32_COMPAT)	+= linux32.o
 obj-$(CONFIG_MIPS32_N32)	+= binfmt_elfn32.o scall64-n32.o signal_n32.o
 obj-$(CONFIG_MIPS32_O32)	+= binfmt_elfo32.o scall64-o32.o
 
-obj-$(CONFIG_KGDB)		+= gdb-low.o gdb-stub.o
+obj-$(CONFIG_KGDB)		+= kgdb_handler.o kgdb.o kgdb-jmp.o	\
+					kgdb-setjmp.o
 obj-$(CONFIG_PROC_FS)		+= proc.o
 
 obj-$(CONFIG_64BIT)		+= cpu-bugs64.o
--- a/arch/mips/kernel/gdb-stub.c
+++ /dev/null
@@ -1,1154 +0,0 @@
-/*
- *  arch/mips/kernel/gdb-stub.c
- *
- *  Originally written by Glenn Engel, Lake Stevens Instrument Division
- *
- *  Contributed by HP Systems
- *
- *  Modified for SPARC by Stu Grossman, Cygnus Support.
- *
- *  Modified for Linux/MIPS (and MIPS in general) by Andreas Busse
- *  Send complaints, suggestions etc. to <andy@waldorf-gmbh.de>
- *
- *  Copyright (C) 1995 Andreas Busse
- *
- *  Copyright (C) 2003 MontaVista Software Inc.
- *  Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
- */
-
-/*
- *  To enable debugger support, two things need to happen.  One, a
- *  call to set_debug_traps() is necessary in order to allow any breakpoints
- *  or error conditions to be properly intercepted and reported to gdb.
- *  Two, a breakpoint needs to be generated to begin communication.  This
- *  is most easily accomplished by a call to breakpoint().  Breakpoint()
- *  simulates a breakpoint by executing a BREAK instruction.
- *
- *
- *    The following gdb commands are supported:
- *
- * command          function                               Return value
- *
- *    g             return the value of the CPU registers  hex data or ENN
- *    G             set the value of the CPU registers     OK or ENN
- *
- *    mAA..AA,LLLL  Read LLLL bytes at address AA..AA      hex data or ENN
- *    MAA..AA,LLLL: Write LLLL bytes at address AA.AA      OK or ENN
- *
- *    c             Resume at current address              SNN   ( signal NN)
- *    cAA..AA       Continue at address AA..AA             SNN
- *
- *    s             Step one instruction                   SNN
- *    sAA..AA       Step one instruction from AA..AA       SNN
- *
- *    k             kill
- *
- *    ?             What was the last sigval ?             SNN   (signal NN)
- *
- *    bBB..BB	    Set baud rate to BB..BB		   OK or BNN, then sets
- *							   baud rate
- *
- * All commands and responses are sent with a packet which includes a
- * checksum.  A packet consists of
- *
- * $<packet info>#<checksum>.
- *
- * where
- * <packet info> :: <characters representing the command or response>
- * <checksum>    :: < two hex digits computed as modulo 256 sum of <packetinfo>>
- *
- * When a packet is received, it is first acknowledged with either '+' or '-'.
- * '+' indicates a successful transfer.  '-' indicates a failed transfer.
- *
- * Example:
- *
- * Host:                  Reply:
- * $m0,10#2a               +$00010203040506070809101112131415#42
- *
- *
- *  ==============
- *  MORE EXAMPLES:
- *  ==============
- *
- *  For reference -- the following are the steps that one
- *  company took (RidgeRun Inc) to get remote gdb debugging
- *  going. In this scenario the host machine was a PC and the
- *  target platform was a Galileo EVB64120A MIPS evaluation
- *  board.
- *
- *  Step 1:
- *  First download gdb-5.0.tar.gz from the internet.
- *  and then build/install the package.
- *
- *  Example:
- *    $ tar zxf gdb-5.0.tar.gz
- *    $ cd gdb-5.0
- *    $ ./configure --target=mips-linux-elf
- *    $ make
- *    $ install
- *    $ which mips-linux-elf-gdb
- *    /usr/local/bin/mips-linux-elf-gdb
- *
- *  Step 2:
- *  Configure linux for remote debugging and build it.
- *
- *  Example:
- *    $ cd ~/linux
- *    $ make menuconfig <go to "Kernel Hacking" and turn on remote debugging>
- *    $ make
- *
- *  Step 3:
- *  Download the kernel to the remote target and start
- *  the kernel running. It will promptly halt and wait
- *  for the host gdb session to connect. It does this
- *  since the "Kernel Hacking" option has defined
- *  CONFIG_KGDB which in turn enables your calls
- *  to:
- *     set_debug_traps();
- *     breakpoint();
- *
- *  Step 4:
- *  Start the gdb session on the host.
- *
- *  Example:
- *    $ mips-linux-elf-gdb vmlinux
- *    (gdb) set remotebaud 115200
- *    (gdb) target remote /dev/ttyS1
- *    ...at this point you are connected to
- *       the remote target and can use gdb
- *       in the normal fasion. Setting
- *       breakpoints, single stepping,
- *       printing variables, etc.
- */
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/console.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/spinlock.h>
-#include <linux/slab.h>
-#include <linux/reboot.h>
-
-#include <asm/asm.h>
-#include <asm/cacheflush.h>
-#include <asm/mipsregs.h>
-#include <asm/pgtable.h>
-#include <asm/system.h>
-#include <asm/gdb-stub.h>
-#include <asm/inst.h>
-#include <asm/smp.h>
-
-/*
- * external low-level support routines
- */
-
-extern int putDebugChar(char c);    /* write a single character      */
-extern char getDebugChar(void);     /* read and return a single char */
-extern void trap_low(void);
-
-/*
- * breakpoint and test functions
- */
-extern void breakpoint(void);
-extern void breakinst(void);
-extern void async_breakpoint(void);
-extern void async_breakinst(void);
-extern void adel(void);
-
-/*
- * local prototypes
- */
-
-static void getpacket(char *buffer);
-static void putpacket(char *buffer);
-static int computeSignal(int tt);
-static int hex(unsigned char ch);
-static int hexToInt(char **ptr, int *intValue);
-static int hexToLong(char **ptr, long *longValue);
-static unsigned char *mem2hex(char *mem, char *buf, int count, int may_fault);
-void handle_exception(struct gdb_regs *regs);
-
-int kgdb_enabled;
-
-/*
- * spin locks for smp case
- */
-static DEFINE_SPINLOCK(kgdb_lock);
-static raw_spinlock_t kgdb_cpulock[NR_CPUS] = {
-	[0 ... NR_CPUS-1] = __RAW_SPIN_LOCK_UNLOCKED,
-};
-
-/*
- * BUFMAX defines the maximum number of characters in inbound/outbound buffers
- * at least NUMREGBYTES*2 are needed for register packets
- */
-#define BUFMAX 2048
-
-static char input_buffer[BUFMAX];
-static char output_buffer[BUFMAX];
-static int initialized;	/* !0 means we've been initialized */
-static int kgdb_started;
-static const char hexchars[]="0123456789abcdef";
-
-/* Used to prevent crashes in memory access.  Note that they'll crash anyway if
-   we haven't set up fault handlers yet... */
-int kgdb_read_byte(unsigned char *address, unsigned char *dest);
-int kgdb_write_byte(unsigned char val, unsigned char *dest);
-
-/*
- * Convert ch from a hex digit to an int
- */
-static int hex(unsigned char ch)
-{
-	if (ch >= 'a' && ch <= 'f')
-		return ch-'a'+10;
-	if (ch >= '0' && ch <= '9')
-		return ch-'0';
-	if (ch >= 'A' && ch <= 'F')
-		return ch-'A'+10;
-	return -1;
-}
-
-/*
- * scan for the sequence $<data>#<checksum>
- */
-static void getpacket(char *buffer)
-{
-	unsigned char checksum;
-	unsigned char xmitcsum;
-	int i;
-	int count;
-	unsigned char ch;
-
-	do {
-		/*
-		 * wait around for the start character,
-		 * ignore all other characters
-		 */
-		while ((ch = (getDebugChar() & 0x7f)) != '$') ;
-
-		checksum = 0;
-		xmitcsum = -1;
-		count = 0;
-
-		/*
-		 * now, read until a # or end of buffer is found
-		 */
-		while (count < BUFMAX) {
-			ch = getDebugChar();
-			if (ch == '#')
-				break;
-			checksum = checksum + ch;
-			buffer[count] = ch;
-			count = count + 1;
-		}
-
-		if (count >= BUFMAX)
-			continue;
-
-		buffer[count] = 0;
-
-		if (ch == '#') {
-			xmitcsum = hex(getDebugChar() & 0x7f) << 4;
-			xmitcsum |= hex(getDebugChar() & 0x7f);
-
-			if (checksum != xmitcsum)
-				putDebugChar('-');	/* failed checksum */
-			else {
-				putDebugChar('+'); /* successful transfer */
-
-				/*
-				 * if a sequence char is present,
-				 * reply the sequence ID
-				 */
-				if (buffer[2] == ':') {
-					putDebugChar(buffer[0]);
-					putDebugChar(buffer[1]);
-
-					/*
-					 * remove sequence chars from buffer
-					 */
-					count = strlen(buffer);
-					for (i=3; i <= count; i++)
-						buffer[i-3] = buffer[i];
-				}
-			}
-		}
-	}
-	while (checksum != xmitcsum);
-}
-
-/*
- * send the packet in buffer.
- */
-static void putpacket(char *buffer)
-{
-	unsigned char checksum;
-	int count;
-	unsigned char ch;
-
-	/*
-	 * $<packet info>#<checksum>.
-	 */
-
-	do {
-		putDebugChar('$');
-		checksum = 0;
-		count = 0;
-
-		while ((ch = buffer[count]) != 0) {
-			if (!(putDebugChar(ch)))
-				return;
-			checksum += ch;
-			count += 1;
-		}
-
-		putDebugChar('#');
-		putDebugChar(hexchars[checksum >> 4]);
-		putDebugChar(hexchars[checksum & 0xf]);
-
-	}
-	while ((getDebugChar() & 0x7f) != '+');
-}
-
-
-/*
- * Convert the memory pointed to by mem into hex, placing result in buf.
- * Return a pointer to the last char put in buf (null), in case of mem fault,
- * return 0.
- * may_fault is non-zero if we are reading from arbitrary memory, but is currently
- * not used.
- */
-static unsigned char *mem2hex(char *mem, char *buf, int count, int may_fault)
-{
-	unsigned char ch;
-
-	while (count-- > 0) {
-		if (kgdb_read_byte(mem++, &ch) != 0)
-			return 0;
-		*buf++ = hexchars[ch >> 4];
-		*buf++ = hexchars[ch & 0xf];
-	}
-
-	*buf = 0;
-
-	return buf;
-}
-
-/*
- * convert the hex array pointed to by buf into binary to be placed in mem
- * return a pointer to the character AFTER the last byte written
- * may_fault is non-zero if we are reading from arbitrary memory, but is currently
- * not used.
- */
-static char *hex2mem(char *buf, char *mem, int count, int binary, int may_fault)
-{
-	int i;
-	unsigned char ch;
-
-	for (i=0; i<count; i++)
-	{
-		if (binary) {
-			ch = *buf++;
-			if (ch == 0x7d)
-				ch = 0x20 ^ *buf++;
-		}
-		else {
-			ch = hex(*buf++) << 4;
-			ch |= hex(*buf++);
-		}
-		if (kgdb_write_byte(ch, mem++) != 0)
-			return 0;
-	}
-
-	return mem;
-}
-
-/*
- * This table contains the mapping between SPARC hardware trap types, and
- * signals, which are primarily what GDB understands.  It also indicates
- * which hardware traps we need to commandeer when initializing the stub.
- */
-static struct hard_trap_info {
-	unsigned char tt;		/* Trap type code for MIPS R3xxx and R4xxx */
-	unsigned char signo;		/* Signal that we map this trap into */
-} hard_trap_info[] = {
-	{ 6, SIGBUS },			/* instruction bus error */
-	{ 7, SIGBUS },			/* data bus error */
-	{ 9, SIGTRAP },			/* break */
-	{ 10, SIGILL },			/* reserved instruction */
-/*	{ 11, SIGILL },		*/	/* CPU unusable */
-	{ 12, SIGFPE },			/* overflow */
-	{ 13, SIGTRAP },		/* trap */
-	{ 14, SIGSEGV },		/* virtual instruction cache coherency */
-	{ 15, SIGFPE },			/* floating point exception */
-	{ 23, SIGSEGV },		/* watch */
-	{ 31, SIGSEGV },		/* virtual data cache coherency */
-	{ 0, 0}				/* Must be last */
-};
-
-/* Save the normal trap handlers for user-mode traps. */
-void *saved_vectors[32];
-
-/*
- * Set up exception handlers for tracing and breakpoints
- */
-void set_debug_traps(void)
-{
-	struct hard_trap_info *ht;
-	unsigned long flags;
-	unsigned char c;
-
-	local_irq_save(flags);
-	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
-		saved_vectors[ht->tt] = set_except_vector(ht->tt, trap_low);
-
-	putDebugChar('+'); /* 'hello world' */
-	/*
-	 * In case GDB is started before us, ack any packets
-	 * (presumably "$?#xx") sitting there.
-	 */
-	while((c = getDebugChar()) != '$');
-	while((c = getDebugChar()) != '#');
-	c = getDebugChar(); /* eat first csum byte */
-	c = getDebugChar(); /* eat second csum byte */
-	putDebugChar('+'); /* ack it */
-
-	initialized = 1;
-	local_irq_restore(flags);
-}
-
-void restore_debug_traps(void)
-{
-	struct hard_trap_info *ht;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
-		set_except_vector(ht->tt, saved_vectors[ht->tt]);
-	local_irq_restore(flags);
-}
-
-/*
- * Convert the MIPS hardware trap type code to a Unix signal number.
- */
-static int computeSignal(int tt)
-{
-	struct hard_trap_info *ht;
-
-	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
-		if (ht->tt == tt)
-			return ht->signo;
-
-	return SIGHUP;		/* default for things we don't know about */
-}
-
-/*
- * While we find nice hex chars, build an int.
- * Return number of chars processed.
- */
-static int hexToInt(char **ptr, int *intValue)
-{
-	int numChars = 0;
-	int hexValue;
-
-	*intValue = 0;
-
-	while (**ptr) {
-		hexValue = hex(**ptr);
-		if (hexValue < 0)
-			break;
-
-		*intValue = (*intValue << 4) | hexValue;
-		numChars ++;
-
-		(*ptr)++;
-	}
-
-	return (numChars);
-}
-
-static int hexToLong(char **ptr, long *longValue)
-{
-	int numChars = 0;
-	int hexValue;
-
-	*longValue = 0;
-
-	while (**ptr) {
-		hexValue = hex(**ptr);
-		if (hexValue < 0)
-			break;
-
-		*longValue = (*longValue << 4) | hexValue;
-		numChars ++;
-
-		(*ptr)++;
-	}
-
-	return numChars;
-}
-
-
-#if 0
-/*
- * Print registers (on target console)
- * Used only to debug the stub...
- */
-void show_gdbregs(struct gdb_regs * regs)
-{
-	/*
-	 * Saved main processor registers
-	 */
-	printk("$0 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
-	       regs->reg0, regs->reg1, regs->reg2, regs->reg3,
-	       regs->reg4, regs->reg5, regs->reg6, regs->reg7);
-	printk("$8 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
-	       regs->reg8, regs->reg9, regs->reg10, regs->reg11,
-	       regs->reg12, regs->reg13, regs->reg14, regs->reg15);
-	printk("$16: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
-	       regs->reg16, regs->reg17, regs->reg18, regs->reg19,
-	       regs->reg20, regs->reg21, regs->reg22, regs->reg23);
-	printk("$24: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
-	       regs->reg24, regs->reg25, regs->reg26, regs->reg27,
-	       regs->reg28, regs->reg29, regs->reg30, regs->reg31);
-
-	/*
-	 * Saved cp0 registers
-	 */
-	printk("epc  : %08lx\nStatus: %08lx\nCause : %08lx\n",
-	       regs->cp0_epc, regs->cp0_status, regs->cp0_cause);
-}
-#endif /* dead code */
-
-/*
- * We single-step by setting breakpoints. When an exception
- * is handled, we need to restore the instructions hoisted
- * when the breakpoints were set.
- *
- * This is where we save the original instructions.
- */
-static struct gdb_bp_save {
-	unsigned long addr;
-	unsigned int val;
-} step_bp[2];
-
-#define BP 0x0000000d  /* break opcode */
-
-/*
- * Set breakpoint instructions for single stepping.
- */
-static void single_step(struct gdb_regs *regs)
-{
-	union mips_instruction insn;
-	unsigned long targ;
-	int is_branch, is_cond, i;
-
-	targ = regs->cp0_epc;
-	insn.word = *(unsigned int *)targ;
-	is_branch = is_cond = 0;
-
-	switch (insn.i_format.opcode) {
-	/*
-	 * jr and jalr are in r_format format.
-	 */
-	case spec_op:
-		switch (insn.r_format.func) {
-		case jalr_op:
-		case jr_op:
-			targ = *(&regs->reg0 + insn.r_format.rs);
-			is_branch = 1;
-			break;
-		}
-		break;
-
-	/*
-	 * This group contains:
-	 * bltz_op, bgez_op, bltzl_op, bgezl_op,
-	 * bltzal_op, bgezal_op, bltzall_op, bgezall_op.
-	 */
-	case bcond_op:
-		is_branch = is_cond = 1;
-		targ += 4 + (insn.i_format.simmediate << 2);
-		break;
-
-	/*
-	 * These are unconditional and in j_format.
-	 */
-	case jal_op:
-	case j_op:
-		is_branch = 1;
-		targ += 4;
-		targ >>= 28;
-		targ <<= 28;
-		targ |= (insn.j_format.target << 2);
-		break;
-
-	/*
-	 * These are conditional.
-	 */
-	case beq_op:
-	case beql_op:
-	case bne_op:
-	case bnel_op:
-	case blez_op:
-	case blezl_op:
-	case bgtz_op:
-	case bgtzl_op:
-	case cop0_op:
-	case cop1_op:
-	case cop2_op:
-	case cop1x_op:
-		is_branch = is_cond = 1;
-		targ += 4 + (insn.i_format.simmediate << 2);
-		break;
-	}
-
-	if (is_branch) {
-		i = 0;
-		if (is_cond && targ != (regs->cp0_epc + 8)) {
-			step_bp[i].addr = regs->cp0_epc + 8;
-			step_bp[i++].val = *(unsigned *)(regs->cp0_epc + 8);
-			*(unsigned *)(regs->cp0_epc + 8) = BP;
-		}
-		step_bp[i].addr = targ;
-		step_bp[i].val  = *(unsigned *)targ;
-		*(unsigned *)targ = BP;
-	} else {
-		step_bp[0].addr = regs->cp0_epc + 4;
-		step_bp[0].val  = *(unsigned *)(regs->cp0_epc + 4);
-		*(unsigned *)(regs->cp0_epc + 4) = BP;
-	}
-}
-
-/*
- *  If asynchronously interrupted by gdb, then we need to set a breakpoint
- *  at the interrupted instruction so that we wind up stopped with a
- *  reasonable stack frame.
- */
-static struct gdb_bp_save async_bp;
-
-/*
- * Swap the interrupted EPC with our asynchronous breakpoint routine.
- * This is safer than stuffing the breakpoint in-place, since no cache
- * flushes (or resulting smp_call_functions) are required.  The
- * assumption is that only one CPU will be handling asynchronous bp's,
- * and only one can be active at a time.
- */
-extern spinlock_t smp_call_lock;
-
-void set_async_breakpoint(unsigned long *epc)
-{
-	/* skip breaking into userland */
-	if ((*epc & 0x80000000) == 0)
-		return;
-
-#ifdef CONFIG_SMP
-	/* avoid deadlock if someone is make IPC */
-	if (spin_is_locked(&smp_call_lock))
-		return;
-#endif
-
-	async_bp.addr = *epc;
-	*epc = (unsigned long)async_breakpoint;
-}
-
-static void kgdb_wait(void *arg)
-{
-	unsigned flags;
-	int cpu = smp_processor_id();
-
-	local_irq_save(flags);
-
-	__raw_spin_lock(&kgdb_cpulock[cpu]);
-	__raw_spin_unlock(&kgdb_cpulock[cpu]);
-
-	local_irq_restore(flags);
-}
-
-/*
- * GDB stub needs to call kgdb_wait on all processor with interrupts
- * disabled, so it uses it's own special variant.
- */
-static int kgdb_smp_call_kgdb_wait(void)
-{
-#ifdef CONFIG_SMP
-	cpumask_t mask = cpu_online_map;
-	struct call_data_struct data;
-	int cpu = smp_processor_id();
-	int cpus;
-
-	/*
-	 * Can die spectacularly if this CPU isn't yet marked online
-	 */
-	BUG_ON(!cpu_online(cpu));
-
-	cpu_clear(cpu, mask);
-	cpus = cpus_weight(mask);
-	if (!cpus)
-		return 0;
-
-	if (spin_is_locked(&smp_call_lock)) {
-		/*
-		 * Some other processor is trying to make us do something
-		 * but we're not going to respond... give up
-		 */
-		return -1;
-		}
-
-	/*
-	 * We will continue here, accepting the fact that
-	 * the kernel may deadlock if another CPU attempts
-	 * to call smp_call_function now...
-	 */
-
-	data.func = kgdb_wait;
-	data.info = NULL;
-	atomic_set(&data.started, 0);
-	data.wait = 0;
-
-	spin_lock(&smp_call_lock);
-	call_data = &data;
-	mb();
-
-	core_send_ipi_mask(mask, SMP_CALL_FUNCTION);
-
-	/* Wait for response */
-	/* FIXME: lock-up detection, backtrace on lock-up */
-	while (atomic_read(&data.started) != cpus)
-		barrier();
-
-	call_data = NULL;
-	spin_unlock(&smp_call_lock);
-#endif
-
-	return 0;
-}
-
-/*
- * This function does all command processing for interfacing to gdb.  It
- * returns 1 if you should skip the instruction at the trap address, 0
- * otherwise.
- */
-void handle_exception(struct gdb_regs *regs)
-{
-	int trap;			/* Trap type */
-	int sigval;
-	long addr;
-	int length;
-	char *ptr;
-	unsigned long *stack;
-	int i;
-	int bflag = 0;
-
-	kgdb_started = 1;
-
-	/*
-	 * acquire the big kgdb spinlock
-	 */
-	if (!spin_trylock(&kgdb_lock)) {
-		/*
-		 * some other CPU has the lock, we should go back to
-		 * receive the gdb_wait IPC
-		 */
-		return;
-	}
-
-	/*
-	 * If we're in async_breakpoint(), restore the real EPC from
-	 * the breakpoint.
-	 */
-	if (regs->cp0_epc == (unsigned long)async_breakinst) {
-		regs->cp0_epc = async_bp.addr;
-		async_bp.addr = 0;
-	}
-
-	/*
-	 * acquire the CPU spinlocks
-	 */
-	for_each_online_cpu(i)
-		if (__raw_spin_trylock(&kgdb_cpulock[i]) == 0)
-			panic("kgdb: couldn't get cpulock %d\n", i);
-
-	/*
-	 * force other cpus to enter kgdb
-	 */
-	kgdb_smp_call_kgdb_wait();
-
-	/*
-	 * If we're in breakpoint() increment the PC
-	 */
-	trap = (regs->cp0_cause & 0x7c) >> 2;
-	if (trap == 9 && regs->cp0_epc == (unsigned long)breakinst)
-		regs->cp0_epc += 4;
-
-	/*
-	 * If we were single_stepping, restore the opcodes hoisted
-	 * for the breakpoint[s].
-	 */
-	if (step_bp[0].addr) {
-		*(unsigned *)step_bp[0].addr = step_bp[0].val;
-		step_bp[0].addr = 0;
-
-		if (step_bp[1].addr) {
-			*(unsigned *)step_bp[1].addr = step_bp[1].val;
-			step_bp[1].addr = 0;
-		}
-	}
-
-	stack = (long *)regs->reg29;			/* stack ptr */
-	sigval = computeSignal(trap);
-
-	/*
-	 * reply to host that an exception has occurred
-	 */
-	ptr = output_buffer;
-
-	/*
-	 * Send trap type (converted to signal)
-	 */
-	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
-
-	/*
-	 * Send Error PC
-	 */
-	*ptr++ = hexchars[REG_EPC >> 4];
-	*ptr++ = hexchars[REG_EPC & 0xf];
-	*ptr++ = ':';
-	ptr = mem2hex((char *)&regs->cp0_epc, ptr, sizeof(long), 0);
-	*ptr++ = ';';
-
-	/*
-	 * Send frame pointer
-	 */
-	*ptr++ = hexchars[REG_FP >> 4];
-	*ptr++ = hexchars[REG_FP & 0xf];
-	*ptr++ = ':';
-	ptr = mem2hex((char *)&regs->reg30, ptr, sizeof(long), 0);
-	*ptr++ = ';';
-
-	/*
-	 * Send stack pointer
-	 */
-	*ptr++ = hexchars[REG_SP >> 4];
-	*ptr++ = hexchars[REG_SP & 0xf];
-	*ptr++ = ':';
-	ptr = mem2hex((char *)&regs->reg29, ptr, sizeof(long), 0);
-	*ptr++ = ';';
-
-	*ptr++ = 0;
-	putpacket(output_buffer);	/* send it off... */
-
-	/*
-	 * Wait for input from remote GDB
-	 */
-	while (1) {
-		output_buffer[0] = 0;
-		getpacket(input_buffer);
-
-		switch (input_buffer[0])
-		{
-		case '?':
-			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
-			output_buffer[3] = 0;
-			break;
-
-		/*
-		 * Detach debugger; let CPU run
-		 */
-		case 'D':
-			putpacket(output_buffer);
-			goto finish_kgdb;
-			break;
-
-		case 'd':
-			/* toggle debug flag */
-			break;
-
-		/*
-		 * Return the value of the CPU registers
-		 */
-		case 'g':
-			ptr = output_buffer;
-			ptr = mem2hex((char *)&regs->reg0, ptr, 32*sizeof(long), 0); /* r0...r31 */
-			ptr = mem2hex((char *)&regs->cp0_status, ptr, 6*sizeof(long), 0); /* cp0 */
-			ptr = mem2hex((char *)&regs->fpr0, ptr, 32*sizeof(long), 0); /* f0...31 */
-			ptr = mem2hex((char *)&regs->cp1_fsr, ptr, 2*sizeof(long), 0); /* cp1 */
-			ptr = mem2hex((char *)&regs->frame_ptr, ptr, 2*sizeof(long), 0); /* frp */
-			ptr = mem2hex((char *)&regs->cp0_index, ptr, 16*sizeof(long), 0); /* cp0 */
-			break;
-
-		/*
-		 * set the value of the CPU registers - return OK
-		 */
-		case 'G':
-		{
-			ptr = &input_buffer[1];
-			hex2mem(ptr, (char *)&regs->reg0, 32*sizeof(long), 0, 0);
-			ptr += 32*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->cp0_status, 6*sizeof(long), 0, 0);
-			ptr += 6*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->fpr0, 32*sizeof(long), 0, 0);
-			ptr += 32*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->cp1_fsr, 2*sizeof(long), 0, 0);
-			ptr += 2*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->frame_ptr, 2*sizeof(long), 0, 0);
-			ptr += 2*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->cp0_index, 16*sizeof(long), 0, 0);
-			strcpy(output_buffer, "OK");
-		 }
-		break;
-
-		/*
-		 * mAA..AA,LLLL  Read LLLL bytes at address AA..AA
-		 */
-		case 'm':
-			ptr = &input_buffer[1];
-
-			if (hexToLong(&ptr, &addr)
-				&& *ptr++ == ','
-				&& hexToInt(&ptr, &length)) {
-				if (mem2hex((char *)addr, output_buffer, length, 1))
-					break;
-				strcpy(output_buffer, "E03");
-			} else
-				strcpy(output_buffer, "E01");
-			break;
-
-		/*
-		 * XAA..AA,LLLL: Write LLLL escaped binary bytes at address AA.AA
-		 */
-		case 'X':
-			bflag = 1;
-			/* fall through */
-
-		/*
-		 * MAA..AA,LLLL: Write LLLL bytes at address AA.AA return OK
-		 */
-		case 'M':
-			ptr = &input_buffer[1];
-
-			if (hexToLong(&ptr, &addr)
-				&& *ptr++ == ','
-				&& hexToInt(&ptr, &length)
-				&& *ptr++ == ':') {
-				if (hex2mem(ptr, (char *)addr, length, bflag, 1))
-					strcpy(output_buffer, "OK");
-				else
-					strcpy(output_buffer, "E03");
-			}
-			else
-				strcpy(output_buffer, "E02");
-			break;
-
-		/*
-		 * cAA..AA    Continue at address AA..AA(optional)
-		 */
-		case 'c':
-			/* try to read optional parameter, pc unchanged if no parm */
-
-			ptr = &input_buffer[1];
-			if (hexToLong(&ptr, &addr))
-				regs->cp0_epc = addr;
-
-			goto exit_kgdb_exception;
-			break;
-
-		/*
-		 * kill the program; let us try to restart the machine
-		 * Reset the whole machine.
-		 */
-		case 'k':
-		case 'r':
-			machine_restart("kgdb restarts machine");
-			break;
-
-		/*
-		 * Step to next instruction
-		 */
-		case 's':
-			/*
-			 * There is no single step insn in the MIPS ISA, so we
-			 * use breakpoints and continue, instead.
-			 */
-			single_step(regs);
-			goto exit_kgdb_exception;
-			/* NOTREACHED */
-			break;
-
-		/*
-		 * Set baud rate (bBB)
-		 * FIXME: Needs to be written
-		 */
-		case 'b':
-		{
-#if 0
-			int baudrate;
-			extern void set_timer_3();
-
-			ptr = &input_buffer[1];
-			if (!hexToInt(&ptr, &baudrate))
-			{
-				strcpy(output_buffer, "B01");
-				break;
-			}
-
-			/* Convert baud rate to uart clock divider */
-
-			switch (baudrate)
-			{
-				case 38400:
-					baudrate = 16;
-					break;
-				case 19200:
-					baudrate = 33;
-					break;
-				case 9600:
-					baudrate = 65;
-					break;
-				default:
-					baudrate = 0;
-					strcpy(output_buffer, "B02");
-					goto x1;
-			}
-
-			if (baudrate) {
-				putpacket("OK");	/* Ack before changing speed */
-				set_timer_3(baudrate); /* Set it */
-			}
-#endif
-		}
-		break;
-
-		}			/* switch */
-
-		/*
-		 * reply to the request
-		 */
-
-		putpacket(output_buffer);
-
-	} /* while */
-
-	return;
-
-finish_kgdb:
-	restore_debug_traps();
-
-exit_kgdb_exception:
-	/* release locks so other CPUs can go */
-	for_each_online_cpu(i)
-		__raw_spin_unlock(&kgdb_cpulock[i]);
-	spin_unlock(&kgdb_lock);
-
-	__flush_cache_all();
-	return;
-}
-
-/*
- * This function will generate a breakpoint exception.  It is used at the
- * beginning of a program to sync up with a debugger and can be used
- * otherwise as a quick means to stop program execution and "break" into
- * the debugger.
- */
-void breakpoint(void)
-{
-	if (!initialized)
-		return;
-
-	__asm__ __volatile__(
-			".globl	breakinst\n\t"
-			".set\tnoreorder\n\t"
-			"nop\n"
-			"breakinst:\tbreak\n\t"
-			"nop\n\t"
-			".set\treorder"
-			);
-}
-
-/* Nothing but the break; don't pollute any registers */
-void async_breakpoint(void)
-{
-	__asm__ __volatile__(
-			".globl	async_breakinst\n\t"
-			".set\tnoreorder\n\t"
-			"nop\n"
-			"async_breakinst:\tbreak\n\t"
-			"nop\n\t"
-			".set\treorder"
-			);
-}
-
-void adel(void)
-{
-	__asm__ __volatile__(
-			".globl\tadel\n\t"
-			"lui\t$8,0x8000\n\t"
-			"lw\t$9,1($8)\n\t"
-			);
-}
-
-/*
- * malloc is needed by gdb client in "call func()", even a private one
- * will make gdb happy
- */
-static void __used *malloc(size_t size)
-{
-	return kmalloc(size, GFP_ATOMIC);
-}
-
-static void __used free(void *where)
-{
-	kfree(where);
-}
-
-#ifdef CONFIG_GDB_CONSOLE
-
-void gdb_putsn(const char *str, int l)
-{
-	char outbuf[18];
-
-	if (!kgdb_started)
-		return;
-
-	outbuf[0]='O';
-
-	while(l) {
-		int i = (l>8)?8:l;
-		mem2hex((char *)str, &outbuf[1], i, 0);
-		outbuf[(i*2)+1]=0;
-		putpacket(outbuf);
-		str += i;
-		l -= i;
-	}
-}
-
-static void gdb_console_write(struct console *con, const char *s, unsigned n)
-{
-	gdb_putsn(s, n);
-}
-
-static struct console gdb_console = {
-	.name	= "gdb",
-	.write	= gdb_console_write,
-	.flags	= CON_PRINTBUFFER,
-	.index	= -1
-};
-
-static int __init register_gdb_console(void)
-{
-	register_console(&gdb_console);
-
-	return 0;
-}
-
-console_initcall(register_gdb_console);
-
-#endif
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -21,11 +21,15 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
+/* Keep track of if we've done certain initialization already or not. */
+int kgdb_early_setup;
+
 static unsigned long irq_map[NR_IRQS / BITS_PER_LONG];
 
 int allocate_irqno(void)
@@ -130,28 +134,23 @@ asmlinkage void spurious_interrupt(void)
 	atomic_inc(&irq_err_count);
 }
 
-#ifdef CONFIG_KGDB
-extern void breakpoint(void);
-extern void set_debug_traps(void);
-
-static int kgdb_flag = 1;
-static int __init nokgdb(char *str)
+void __init init_IRQ(void)
 {
-	kgdb_flag = 0;
-	return 1;
-}
-__setup("nokgdb", nokgdb);
+
+#ifdef CONFIG_KGDB
+	if (kgdb_early_setup)
+		return;
 #endif
 
-void __init init_IRQ(void)
-{
 	arch_init_irq();
 
+
 #ifdef CONFIG_KGDB
-	if (kgdb_flag) {
-		printk("Wait for gdb client connection ...\n");
-		set_debug_traps();
-		breakpoint();
-	}
+	/*
+	 * We have been called before kgdb_arch_init(). Hence,
+	 * we dont want the traps to be reinitialized
+	 */
+	if (kgdb_early_setup == 0)
+		kgdb_early_setup = 1;
 #endif
 }
--- /dev/null
+++ b/arch/mips/kernel/kgdb-jmp.c
@@ -0,0 +1,112 @@
+/*
+ * arch/mips/kernel/kgdb-jmp.c
+ *
+ * Save and restore system registers so that within a limited frame we
+ * may have a fault and "jump back" to a known safe location.
+ *
+ * Author: Tom Rini <trini@kernel.crashing.org>
+ * Author: Manish Lachwani <mlachwani@mvista.com>
+ *
+ * Cribbed from glibc, which carries the following:
+ * Copyright (C) 1996, 1997, 2000, 2002, 2003 Free Software Foundation, Inc.
+ * Copyright (C) 2005-2006 by MontaVista Software.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program as licensed "as is" without any warranty of
+ * any kind, whether express or implied.
+ */
+
+#include <linux/kgdb.h>
+
+#ifdef CONFIG_64BIT
+/*
+ * MIPS 64-bit
+ */
+
+int kgdb_fault_setjmp_aux(unsigned long *curr_context, unsigned long sp,
+	unsigned long fp)
+{
+	__asm__ __volatile__ ("sd $gp, %0" : : "m" (curr_context[0]));
+	__asm__ __volatile__ ("sd $16, %0" : : "m" (curr_context[1]));
+	__asm__ __volatile__ ("sd $17, %0" : : "m" (curr_context[2]));
+	__asm__ __volatile__ ("sd $18, %0" : : "m" (curr_context[3]));
+	__asm__ __volatile__ ("sd $19, %0" : : "m" (curr_context[4]));
+	__asm__ __volatile__ ("sd $20, %0" : : "m" (curr_context[5]));
+	__asm__ __volatile__ ("sd $21, %0" : : "m" (curr_context[6]));
+	__asm__ __volatile__ ("sd $22, %0" : : "m" (curr_context[7]));
+	__asm__ __volatile__ ("sd $23, %0" : : "m" (curr_context[8]));
+	__asm__ __volatile__ ("sd $31, %0" : : "m" (curr_context[9]));
+	curr_context[10] = sp;
+	curr_context[11] = fp;
+
+	return 0;
+}
+
+void kgdb_fault_longjmp(unsigned long *curr_context)
+{
+	__asm__ __volatile__ ("ld $gp, %0" : : "m" (curr_context[0]));
+	__asm__ __volatile__ ("ld $16, %0" : : "m" (curr_context[1]));
+	__asm__ __volatile__ ("ld $17, %0" : : "m" (curr_context[2]));
+	__asm__ __volatile__ ("ld $18, %0" : : "m" (curr_context[3]));
+	__asm__ __volatile__ ("ld $19, %0" : : "m" (curr_context[4]));
+	__asm__ __volatile__ ("ld $20, %0" : : "m" (curr_context[5]));
+	__asm__ __volatile__ ("ld $21, %0" : : "m" (curr_context[6]));
+	__asm__ __volatile__ ("ld $22, %0" : : "m" (curr_context[7]));
+	__asm__ __volatile__ ("ld $23, %0" : : "m" (curr_context[8]));
+	__asm__ __volatile__ ("ld $25, %0" : : "m" (curr_context[9]));
+	__asm__ __volatile__ ("ld $29, %0\n\t"
+			      "ld $30, %1\n\t" : :
+			      "m" (curr_context[10]), "m" (curr_context[11]));
+
+	__asm__ __volatile__ ("dli $2, 1");
+	__asm__ __volatile__ ("j $25");
+
+	for (;;);
+}
+#else
+/*
+ * MIPS 32-bit
+ */
+
+int kgdb_fault_setjmp_aux(unsigned long *curr_context, unsigned long sp,
+	unsigned long fp)
+{
+	__asm__ __volatile__("sw $gp, %0" : : "m" (curr_context[0]));
+	__asm__ __volatile__("sw $16, %0" : : "m" (curr_context[1]));
+	__asm__ __volatile__("sw $17, %0" : : "m" (curr_context[2]));
+	__asm__ __volatile__("sw $18, %0" : : "m" (curr_context[3]));
+	__asm__ __volatile__("sw $19, %0" : : "m" (curr_context[4]));
+	__asm__ __volatile__("sw $20, %0" : : "m" (curr_context[5]));
+	__asm__ __volatile__("sw $21, %0" : : "m" (curr_context[6]));
+	__asm__ __volatile__("sw $22, %0" : : "m" (curr_context[7]));
+	__asm__ __volatile__("sw $23, %0" : : "m" (curr_context[8]));
+	__asm__ __volatile__("sw $31, %0" : : "m" (curr_context[9]));
+	curr_context[10] = sp;
+	curr_context[11] = fp;
+
+	return 0;
+}
+
+void kgdb_fault_longjmp(unsigned long *curr_context)
+{
+	__asm__ __volatile__("lw $gp, %0" : : "m" (curr_context[0]));
+	__asm__ __volatile__("lw $16, %0" : : "m" (curr_context[1]));
+	__asm__ __volatile__("lw $17, %0" : : "m" (curr_context[2]));
+	__asm__ __volatile__("lw $18, %0" : : "m" (curr_context[3]));
+	__asm__ __volatile__("lw $19, %0" : : "m" (curr_context[4]));
+	__asm__ __volatile__("lw $20, %0" : : "m" (curr_context[5]));
+	__asm__ __volatile__("lw $21, %0" : : "m" (curr_context[6]));
+	__asm__ __volatile__("lw $22, %0" : : "m" (curr_context[7]));
+	__asm__ __volatile__("lw $23, %0" : : "m" (curr_context[8]));
+	__asm__ __volatile__("lw $25, %0" : : "m" (curr_context[9]));
+
+	__asm__ __volatile__("lw $29, %0\n\t"
+			     "lw $30, %1\n\t" : :
+			     "m" (curr_context[10]), "m" (curr_context[11]));
+
+	__asm__ __volatile__("li $2, 1");
+	__asm__ __volatile__("jr $25");
+
+	for (;;);
+}
+#endif
--- /dev/null
+++ b/arch/mips/kernel/kgdb-setjmp.S
@@ -0,0 +1,28 @@
+/*
+ * arch/mips/kernel/kgdb-jmp.c
+ *
+ * Save and restore system registers so that within a limited frame we
+ * may have a fault and "jump back" to a known safe location.
+ *
+ * Copyright (C) 2005 by MontaVista Software.
+ * Author: Manish Lachwani (mlachwani@mvista.com)
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program as licensed "as is" without any warranty of
+ * any kind, whether express or implied.
+ */
+
+#include <asm/asm.h>
+#include <asm/mipsregs.h>
+#include <asm/regdef.h>
+#include <asm/stackframe.h>
+
+	.ent	kgdb_fault_setjmp,0
+ENTRY (kgdb_fault_setjmp)
+	move    a1, sp
+	move	a2, fp
+#ifdef CONFIG_64BIT
+	nop
+#endif
+	j	kgdb_fault_setjmp_aux
+	.end	kgdb_fault_setjmp
--- /dev/null
+++ b/arch/mips/kernel/kgdb.c
@@ -0,0 +1,293 @@
+/*
+ * arch/mips/kernel/kgdb.c
+ *
+ *  Originally written by Glenn Engel, Lake Stevens Instrument Division
+ *
+ *  Contributed by HP Systems
+ *
+ *  Modified for SPARC by Stu Grossman, Cygnus Support.
+ *
+ *  Modified for Linux/MIPS (and MIPS in general) by Andreas Busse
+ *  Send complaints, suggestions etc. to <andy@waldorf-gmbh.de>
+ *
+ *  Copyright (C) 1995 Andreas Busse
+ *
+ *  Copyright (C) 2003 MontaVista Software Inc.
+ *  Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
+ *
+ *  Copyright (C) 2004-2005 MontaVista Software Inc.
+ *  Author: Manish Lachwani, mlachwani@mvista.com or manish@koffee-break.com
+ *
+ *  This file is licensed under the terms of the GNU General Public License
+ *  version 2. This program is licensed "as is" without any warranty of any
+ *  kind, whether express or implied.
+ */
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/ptrace.h>		/* for linux pt_regs struct */
+#include <asm/system.h>
+#include <linux/kgdb.h>
+#include <linux/init.h>
+#include <linux/kdebug.h>
+#include <asm/inst.h>
+#include <asm/gdb-stub.h>
+#include <asm/cacheflush.h>
+
+static struct hard_trap_info {
+	unsigned char tt;	/* Trap type code for MIPS R3xxx and R4xxx */
+	unsigned char signo;	/* Signal that we map this trap into */
+} hard_trap_info[] = {
+	{ 6, SIGBUS },		/* instruction bus error */
+	{ 7, SIGBUS },		/* data bus error */
+	{ 9, SIGTRAP },		/* break */
+/*	{ 11, SIGILL },	*/	/* CPU unusable */
+	{ 12, SIGFPE },		/* overflow */
+	{ 13, SIGTRAP },	/* trap */
+	{ 14, SIGSEGV },	/* virtual instruction cache coherency */
+	{ 15, SIGFPE },		/* floating point exception */
+	{ 23, SIGSEGV },	/* watch */
+	{ 31, SIGSEGV },	/* virtual data cache coherency */
+	{ 0, 0}			/* Must be last */
+};
+
+/* Save the normal trap handlers for user-mode traps. */
+void *saved_vectors[32];
+
+extern void trap_low(void);
+extern void breakinst(void);
+extern void init_IRQ(void);
+
+void kgdb_call_nmi_hook(void *ignored)
+{
+	kgdb_nmihook(smp_processor_id(), (void *)0);
+}
+
+void kgdb_roundup_cpus(unsigned long flags)
+{
+	local_irq_enable();
+	smp_call_function(kgdb_call_nmi_hook, 0, 0, 0);
+	local_irq_disable();
+}
+
+static int compute_signal(int tt)
+{
+	struct hard_trap_info *ht;
+
+	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
+		if (ht->tt == tt)
+			return ht->signo;
+
+	return SIGHUP;		/* default for things we don't know about */
+}
+
+/*
+ * Set up exception handlers for tracing and breakpoints
+ */
+void handle_exception(struct pt_regs *regs)
+{
+	int trap = (regs->cp0_cause & 0x7c) >> 2;
+
+	if (fixup_exception(regs))
+		return;
+
+	if (atomic_read(&debugger_active))
+		kgdb_nmihook(smp_processor_id(), regs);
+
+	if (atomic_read(&kgdb_setting_breakpoint))
+		if ((trap == 9) && (regs->cp0_epc == (unsigned long)breakinst))
+			regs->cp0_epc += 4;
+
+	kgdb_handle_exception(0, compute_signal(trap), 0, regs);
+
+	/* In SMP mode, __flush_cache_all does IPI */
+	local_irq_enable();
+	__flush_cache_all();
+}
+
+void set_debug_traps(void)
+{
+	struct hard_trap_info *ht;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
+		saved_vectors[ht->tt] = set_except_vector(ht->tt, trap_low);
+
+	local_irq_restore(flags);
+}
+
+void regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	int reg;
+#if (KGDB_GDB_REG_SIZE == 32)
+	u32 *ptr = (u32 *)gdb_regs;
+#else
+	u64 *ptr = (u64 *)gdb_regs;
+#endif
+
+	for (reg = 0; reg < 32; reg++)
+		*(ptr++) = regs->regs[reg];
+
+	*(ptr++) = regs->cp0_status;
+	*(ptr++) = regs->lo;
+	*(ptr++) = regs->hi;
+	*(ptr++) = regs->cp0_badvaddr;
+	*(ptr++) = regs->cp0_cause;
+	*(ptr++) = regs->cp0_epc;
+
+	return;
+}
+
+void gdb_regs_to_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+
+	int reg;
+#if (KGDB_GDB_REG_SIZE == 32)
+	const u32 *ptr = (u32 *)gdb_regs;
+#else
+	const u64 *ptr = (u64 *)gdb_regs;
+#endif
+
+	for (reg = 0; reg < 32; reg++)
+		regs->regs[reg] = *(ptr++);
+
+	regs->cp0_status = *(ptr++);
+	regs->lo = *(ptr++);
+	regs->hi = *(ptr++);
+	regs->cp0_badvaddr = *(ptr++);
+	regs->cp0_cause = *(ptr++);
+	regs->cp0_epc = *(ptr++);
+
+	return;
+}
+
+/*
+ * Similar to regs_to_gdb_regs() except that process is sleeping and so
+ * we may not be able to get all the info.
+ */
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
+{
+	int reg;
+	struct thread_info *ti = task_thread_info(p);
+	unsigned long ksp = (unsigned long)ti + THREAD_SIZE - 32;
+	struct pt_regs *regs = (struct pt_regs *)ksp - 1;
+#if (KGDB_GDB_REG_SIZE == 32)
+	u32 *ptr = (u32 *)gdb_regs;
+#else
+	u64 *ptr = (u64 *)gdb_regs;
+#endif
+
+	for (reg = 0; reg < 16; reg++)
+		*(ptr++) = regs->regs[reg];
+
+	/* S0 - S7 */
+	for (reg = 16; reg < 24; reg++)
+		*(ptr++) = regs->regs[reg];
+
+	for (reg = 24; reg < 28; reg++)
+		*(ptr++) = 0;
+
+	/* GP, SP, FP, RA */
+	for (reg = 28; reg < 32; reg++)
+		*(ptr++) = regs->regs[reg];
+
+	*(ptr++) = regs->cp0_status;
+	*(ptr++) = regs->lo;
+	*(ptr++) = regs->hi;
+	*(ptr++) = regs->cp0_badvaddr;
+	*(ptr++) = regs->cp0_cause;
+	*(ptr++) = regs->cp0_epc;
+
+	return;
+}
+
+/*
+ * Calls linux_debug_hook before the kernel dies. If KGDB is enabled,
+ * then try to fall into the debugger
+ */
+static int kgdb_mips_notify(struct notifier_block *self, unsigned long cmd,
+			    void *ptr)
+{
+	struct die_args *args = (struct die_args *)ptr;
+	struct pt_regs *regs = args->regs;
+	int trap = (regs->cp0_cause & 0x7c) >> 2;
+
+	/* See if KGDB is interested. */
+	if (user_mode(regs))
+		/* Userpace events, ignore. */
+		return NOTIFY_DONE;
+
+	kgdb_handle_exception(trap, compute_signal(trap), 0, regs);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kgdb_notifier = {
+	.notifier_call = kgdb_mips_notify,
+};
+
+/*
+ * Handle the 's' and 'c' commands
+ */
+int kgdb_arch_handle_exception(int vector, int signo, int err_code,
+			       char *remcom_in_buffer, char *remcom_out_buffer,
+			       struct pt_regs *regs)
+{
+	char *ptr;
+	unsigned long address;
+	int cpu = smp_processor_id();
+
+	switch (remcom_in_buffer[0]) {
+	case 's':
+	case 'c':
+		/* handle the optional parameter */
+		ptr = &remcom_in_buffer[1];
+		if (kgdb_hex2long(&ptr, &address))
+			regs->cp0_epc = address;
+
+		atomic_set(&cpu_doing_single_step, -1);
+		if (remcom_in_buffer[0] == 's')
+			if (kgdb_contthread)
+				atomic_set(&cpu_doing_single_step, cpu);
+
+		return 0;
+	}
+
+	return -1;
+}
+
+struct kgdb_arch arch_kgdb_ops = {
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+	.gdb_bpt_instr = {0xd},
+#else /* ! CONFIG_CPU_LITTLE_ENDIAN */
+	.gdb_bpt_instr = {0x00, 0x00, 0x00, 0x0d},
+#endif
+};
+
+/*
+ * We use kgdb_early_setup so that functions we need to call now don't
+ * cause trouble when called again later.
+ */
+__init int kgdb_arch_init(void)
+{
+	/* Board-specifics. */
+	/* Force some calls to happen earlier. */
+	if (kgdb_early_setup == 0) {
+		trap_init();
+		init_IRQ();
+		kgdb_early_setup = 1;
+	}
+
+	/* Set our traps. */
+	/* This needs to be done more finely grained again, paired in
+	 * a before/after in kgdb_handle_exception(...) -- Tom */
+	set_debug_traps();
+	register_die_notifier(&kgdb_notifier);
+
+	return 0;
+}
--- /dev/null
+++ b/arch/mips/kernel/kgdb_handler.S
@@ -0,0 +1,339 @@
+/*
+ * arch/mips/kernel/kgdb_handler.S
+ *
+ * Copyright (C) 2007 Wind River Systems, Inc
+ *
+ * Copyright (C) 2004-2005 MontaVista Software Inc.
+ * Author: Manish Lachwani, mlachwani@mvista.com or manish@koffee-break.com
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/*
+ * Trap Handler for the new KGDB framework. The main KGDB handler is
+ * handle_exception that will be called from here
+ *
+ */
+
+#include <linux/sys.h>
+
+#include <asm/asm.h>
+#include <asm/errno.h>
+#include <asm/mipsregs.h>
+#include <asm/regdef.h>
+#include <asm/stackframe.h>
+#include <asm/gdb-stub.h>
+
+#ifdef CONFIG_32BIT
+#define DMFC0	mfc0
+#define DMTC0	mtc0
+#define LDC1	lwc1
+#define SDC1	swc1
+#endif
+#ifdef CONFIG_64BIT
+#define DMFC0	dmfc0
+#define DMTC0	dmtc0
+#define LDC1	ldc1
+#define SDC1	sdc1
+#endif
+
+#include <asm/asmmacro.h>
+
+/*
+ * [jsun] We reserves about 2x GDB_FR_SIZE in stack.  The lower (addressed)
+ * part is used to store registers and passed to exception handler.
+ * The upper part is reserved for "call func" feature where gdb client
+ * saves some of the regs, setups call frame and passes args.
+ *
+ * A trace shows about 200 bytes are used to store about half of all regs.
+ * The rest should be big enough for frame setup and passing args.
+ */
+
+/*
+ * The low level trap handler
+ */
+		.align 	5
+		NESTED(trap_low, GDB_FR_SIZE, sp)
+ 		.set	noat
+		.set 	noreorder
+
+		mfc0	k0, CP0_STATUS
+		sll	k0, 3     		/* extract cu0 bit */
+		bltz	k0, 1f
+		move	k1, sp
+
+		/*
+		 * Called from user mode, go somewhere else.
+		 */
+#if defined(CONFIG_32BIT)
+		lui	k1, %hi(saved_vectors)
+		mfc0	k0, CP0_CAUSE
+		andi	k0, k0, 0x7c
+		add	k1, k1, k0
+		lw	k0, %lo(saved_vectors)(k1)
+#elif defined(CONFIG_64BIT) && defined(CONFIG_BUILD_ELF64)
+		DMFC0	k0, CP0_CAUSE
+		lui	k1, %highest(saved_vectors)
+                andi    k0, k0, 0x7c           /* mask exception type */
+                dsll    k0, 1                  /* turn into byte offset */
+		daddiu	k1, %higher(saved_vectors)
+		dsll	k1, k1, 16
+		daddiu	k1, %hi(saved_vectors)
+		dsll	k1, k1, 16
+		daddu	k1, k1, k0
+		LONG_L	k0, %lo(saved_vectors)(k1)
+#else
+#error "MIPS configuration is unsupported for kgdb!!"
+#endif
+		jr	k0
+		nop
+1:
+		move	k0, sp
+		PTR_SUBU sp, k1, GDB_FR_SIZE*2	# see comment above
+		LONG_S	k0, GDB_FR_REG29(sp)
+		LONG_S	$2, GDB_FR_REG2(sp)
+
+/*
+ * First save the CP0 and special registers
+ */
+
+		mfc0	v0, CP0_STATUS
+		LONG_S	v0, GDB_FR_STATUS(sp)
+		mfc0	v0, CP0_CAUSE
+		LONG_S	v0, GDB_FR_CAUSE(sp)
+		DMFC0	v0, CP0_EPC
+		LONG_S	v0, GDB_FR_EPC(sp)
+		DMFC0	v0, CP0_BADVADDR
+		LONG_S	v0, GDB_FR_BADVADDR(sp)
+		mfhi	v0
+		LONG_S	v0, GDB_FR_HI(sp)
+		mflo	v0
+		LONG_S	v0, GDB_FR_LO(sp)
+
+/*
+ * Now the integer registers
+ */
+
+		LONG_S	zero, GDB_FR_REG0(sp)		/* I know... */
+		LONG_S	$1, GDB_FR_REG1(sp)
+		/* v0 already saved */
+		LONG_S	$3, GDB_FR_REG3(sp)
+		LONG_S	$4, GDB_FR_REG4(sp)
+		LONG_S	$5, GDB_FR_REG5(sp)
+		LONG_S	$6, GDB_FR_REG6(sp)
+		LONG_S	$7, GDB_FR_REG7(sp)
+		LONG_S	$8, GDB_FR_REG8(sp)
+		LONG_S	$9, GDB_FR_REG9(sp)
+		LONG_S	$10, GDB_FR_REG10(sp)
+		LONG_S	$11, GDB_FR_REG11(sp)
+		LONG_S	$12, GDB_FR_REG12(sp)
+		LONG_S	$13, GDB_FR_REG13(sp)
+		LONG_S	$14, GDB_FR_REG14(sp)
+		LONG_S	$15, GDB_FR_REG15(sp)
+		LONG_S	$16, GDB_FR_REG16(sp)
+		LONG_S	$17, GDB_FR_REG17(sp)
+		LONG_S	$18, GDB_FR_REG18(sp)
+		LONG_S	$19, GDB_FR_REG19(sp)
+		LONG_S	$20, GDB_FR_REG20(sp)
+		LONG_S	$21, GDB_FR_REG21(sp)
+		LONG_S	$22, GDB_FR_REG22(sp)
+		LONG_S	$23, GDB_FR_REG23(sp)
+		LONG_S	$24, GDB_FR_REG24(sp)
+		LONG_S	$25, GDB_FR_REG25(sp)
+		LONG_S	$26, GDB_FR_REG26(sp)
+		LONG_S	$27, GDB_FR_REG27(sp)
+		LONG_S	$28, GDB_FR_REG28(sp)
+		/* sp already saved */
+		LONG_S	$30, GDB_FR_REG30(sp)
+		LONG_S	$31, GDB_FR_REG31(sp)
+
+		CLI				/* disable interrupts */
+
+/*
+ * Followed by the floating point registers
+ */
+		mfc0	v0, CP0_STATUS		/* FPU enabled? */
+		srl	v0, v0, 16
+		andi	v0, v0, (ST0_CU1 >> 16)
+
+		beqz	v0,3f			/* disabled, skip */
+		 nop
+
+		li	t0, 0
+#ifdef CONFIG_64BIT
+		mfc0	t0, CP0_STATUS
+#endif
+		fpu_save_double_kgdb sp t0 t1	# clobbers t1
+
+
+/*
+ * Current stack frame ptr
+ */
+
+3:
+		LONG_S	sp, GDB_FR_FRP(sp)
+
+/*
+ * CP0 registers (R4000/R4400 unused registers skipped)
+ */
+
+		mfc0	v0, CP0_INDEX
+		LONG_S	v0, GDB_FR_CP0_INDEX(sp)
+		mfc0	v0, CP0_RANDOM
+		LONG_S	v0, GDB_FR_CP0_RANDOM(sp)
+		DMFC0	v0, CP0_ENTRYLO0
+		LONG_S	v0, GDB_FR_CP0_ENTRYLO0(sp)
+		DMFC0	v0, CP0_ENTRYLO1
+		LONG_S	v0, GDB_FR_CP0_ENTRYLO1(sp)
+		DMFC0	v0, CP0_CONTEXT
+		LONG_S	v0, GDB_FR_CP0_CONTEXT(sp)
+		mfc0	v0, CP0_PAGEMASK
+		LONG_S	v0, GDB_FR_CP0_PAGEMASK(sp)
+		mfc0	v0, CP0_WIRED
+		LONG_S	v0, GDB_FR_CP0_WIRED(sp)
+		DMFC0	v0, CP0_ENTRYHI
+		LONG_S	v0, GDB_FR_CP0_ENTRYHI(sp)
+		mfc0	v0, CP0_PRID
+		LONG_S	v0, GDB_FR_CP0_PRID(sp)
+
+		.set	at
+
+/*
+ * Continue with the higher level handler
+ */
+
+		move	a0,sp
+
+		jal	handle_exception
+		 nop
+
+/*
+ * Restore all writable registers, in reverse order
+ */
+
+		.set	noat
+
+		LONG_L	v0, GDB_FR_CP0_ENTRYHI(sp)
+		LONG_L	v1, GDB_FR_CP0_WIRED(sp)
+		DMTC0	v0, CP0_ENTRYHI
+		mtc0	v1, CP0_WIRED
+		LONG_L	v0, GDB_FR_CP0_PAGEMASK(sp)
+		LONG_L	v1, GDB_FR_CP0_ENTRYLO1(sp)
+		mtc0	v0, CP0_PAGEMASK
+		DMTC0	v1, CP0_ENTRYLO1
+		LONG_L	v0, GDB_FR_CP0_ENTRYLO0(sp)
+		LONG_L	v1, GDB_FR_CP0_INDEX(sp)
+		DMTC0	v0, CP0_ENTRYLO0
+		LONG_L	v0, GDB_FR_CP0_CONTEXT(sp)
+		mtc0	v1, CP0_INDEX
+		DMTC0	v0, CP0_CONTEXT
+
+
+/*
+ * Next, the floating point registers
+ */
+		mfc0	v0, CP0_STATUS		/* check if FPU is enabled */
+		srl	v0, v0, 16
+		andi	v0, v0, (ST0_CU1 >> 16)
+
+		beqz	v0, 3f			/* disabled, skip */
+		 nop
+
+		li	t0, 0
+#ifdef CONFIG_64BIT
+		mfc0	t0, CP0_STATUS
+#endif
+		fpu_restore_double_kgdb sp t0 t1 # clobbers t1
+
+
+/*
+ * Now the CP0 and integer registers
+ */
+
+3:
+		mfc0	t0, CP0_STATUS
+		ori	t0, 0x1f
+		xori	t0, 0x1f
+		mtc0	t0, CP0_STATUS
+
+		LONG_L	v0, GDB_FR_STATUS(sp)
+		LONG_L	v1, GDB_FR_EPC(sp)
+		mtc0	v0, CP0_STATUS
+		DMTC0	v1, CP0_EPC
+		LONG_L	v0, GDB_FR_HI(sp)
+		LONG_L	v1, GDB_FR_LO(sp)
+		mthi	v0
+		mtlo	v1
+		LONG_L	$31, GDB_FR_REG31(sp)
+		LONG_L	$30, GDB_FR_REG30(sp)
+		LONG_L	$28, GDB_FR_REG28(sp)
+		LONG_L	$27, GDB_FR_REG27(sp)
+		LONG_L	$26, GDB_FR_REG26(sp)
+		LONG_L	$25, GDB_FR_REG25(sp)
+		LONG_L	$24, GDB_FR_REG24(sp)
+		LONG_L	$23, GDB_FR_REG23(sp)
+		LONG_L	$22, GDB_FR_REG22(sp)
+		LONG_L	$21, GDB_FR_REG21(sp)
+		LONG_L	$20, GDB_FR_REG20(sp)
+		LONG_L	$19, GDB_FR_REG19(sp)
+		LONG_L	$18, GDB_FR_REG18(sp)
+		LONG_L	$17, GDB_FR_REG17(sp)
+		LONG_L	$16, GDB_FR_REG16(sp)
+		LONG_L	$15, GDB_FR_REG15(sp)
+		LONG_L	$14, GDB_FR_REG14(sp)
+		LONG_L	$13, GDB_FR_REG13(sp)
+		LONG_L	$12, GDB_FR_REG12(sp)
+		LONG_L	$11, GDB_FR_REG11(sp)
+		LONG_L	$10, GDB_FR_REG10(sp)
+		LONG_L	$9, GDB_FR_REG9(sp)
+		LONG_L	$8, GDB_FR_REG8(sp)
+		LONG_L	$7, GDB_FR_REG7(sp)
+		LONG_L	$6, GDB_FR_REG6(sp)
+		LONG_L	$5, GDB_FR_REG5(sp)
+		LONG_L	$4, GDB_FR_REG4(sp)
+		LONG_L	$3, GDB_FR_REG3(sp)
+		LONG_L	$2, GDB_FR_REG2(sp)
+		LONG_L	$1, GDB_FR_REG1(sp)
+#if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
+		LONG_L	k0, GDB_FR_EPC(sp)
+		LONG_L	$29, GDB_FR_REG29(sp)		/* Deallocate stack */
+		jr	k0
+		rfe
+#else
+		LONG_L	sp, GDB_FR_REG29(sp)		/* Deallocate stack */
+
+		.set	mips3
+		eret
+		.set	mips0
+#endif
+		.set	at
+		.set	reorder
+		END(trap_low)
+
+LEAF(kgdb_read_byte)
+4:		lb	t0, (a0)
+		sb	t0, (a1)
+		li	v0, 0
+		jr	ra
+		.section __ex_table,"a"
+		PTR	4b, kgdbfault
+		.previous
+		END(kgdb_read_byte)
+
+LEAF(kgdb_write_byte)
+5:		sb	a0, (a1)
+		li	v0, 0
+		jr	ra
+		.section __ex_table,"a"
+		PTR	5b, kgdbfault
+		.previous
+		END(kgdb_write_byte)
+
+		.type	kgdbfault@function
+		.ent	kgdbfault
+
+kgdbfault:	li	v0, -EFAULT
+		jr	ra
+		.end	kgdbfault
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -10,6 +10,8 @@
  * Kevin D. Kissell, kevink@mips.com and Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2000, 01 MIPS Technologies, Inc.
  * Copyright (C) 2002, 2003, 2004, 2005  Maciej W. Rozycki
+ *
+ * KGDB specific changes - Manish Lachwani (mlachwani@mvista.com)
  */
 #include <linux/bug.h>
 #include <linux/init.h>
@@ -21,6 +23,8 @@
 #include <linux/kallsyms.h>
 #include <linux/bootmem.h>
 #include <linux/interrupt.h>
+#include <linux/kgdb.h>
+#include <linux/kdebug.h>
 
 #include <asm/bootinfo.h>
 #include <asm/branch.h>
@@ -319,6 +323,10 @@ void __noreturn die(const char * str, st
 	unsigned long dvpret = dvpe();
 #endif /* CONFIG_MIPS_MT_SMTC */
 
+#ifdef CONFIG_KGDB
+	if (kgdb_may_fault)
+		kgdb_fault_longjmp(kgdb_fault_jmp_regs);
+#endif
 	console_verbose();
 	spin_lock_irq(&die_lock);
 	bust_spinlocks(1);
@@ -1470,6 +1478,11 @@ void __init trap_init(void)
 	extern char except_vec4;
 	unsigned long i;
 
+#if defined(CONFIG_KGDB)
+	if (kgdb_early_setup)
+		return;	/* Already done */
+#endif
+
 	if (cpu_has_veic || cpu_has_vint)
 		ebase = (unsigned long) alloc_bootmem_low_pages(0x200 + VECTORSPACING*64);
 	else
--- a/arch/mips/mips-boards/generic/Makefile
+++ b/arch/mips/mips-boards/generic/Makefile
@@ -23,6 +23,5 @@ obj-y				:= reset.o display.o init.o mem
 
 obj-$(CONFIG_EARLY_PRINTK)	+= console.o
 obj-$(CONFIG_PCI)		+= pci.o
-obj-$(CONFIG_KGDB)		+= gdb_hook.o
 
 EXTRA_CFLAGS += -Werror
--- a/arch/mips/mips-boards/generic/init.c
+++ b/arch/mips/mips-boards/generic/init.c
@@ -37,15 +37,6 @@
 
 #include <asm/mips-boards/malta.h>
 
-#ifdef CONFIG_KGDB
-extern int rs_kgdb_hook(int, int);
-extern int rs_putDebugChar(char);
-extern char rs_getDebugChar(void);
-extern int saa9730_kgdb_hook(int);
-extern int saa9730_putDebugChar(char);
-extern char saa9730_getDebugChar(void);
-#endif
-
 int prom_argc;
 int *_prom_argv, *_prom_envp;
 
@@ -173,59 +164,6 @@ static void __init console_config(void)
 }
 #endif
 
-#ifdef CONFIG_KGDB
-void __init kgdb_config(void)
-{
-	extern int (*generic_putDebugChar)(char);
-	extern char (*generic_getDebugChar)(void);
-	char *argptr;
-	int line, speed;
-
-	argptr = prom_getcmdline();
-	if ((argptr = strstr(argptr, "kgdb=ttyS")) != NULL) {
-		argptr += strlen("kgdb=ttyS");
-		if (*argptr != '0' && *argptr != '1')
-			printk("KGDB: Unknown serial line /dev/ttyS%c, "
-			       "falling back to /dev/ttyS1\n", *argptr);
-		line = *argptr == '0' ? 0 : 1;
-		printk("KGDB: Using serial line /dev/ttyS%d for session\n", line);
-
-		speed = 0;
-		if (*++argptr == ',')
-		{
-			int c;
-			while ((c = *++argptr) && ('0' <= c && c <= '9'))
-				speed = speed * 10 + c - '0';
-		}
-#ifdef CONFIG_MIPS_ATLAS
-		if (line == 1) {
-			speed = saa9730_kgdb_hook(speed);
-			generic_putDebugChar = saa9730_putDebugChar;
-			generic_getDebugChar = saa9730_getDebugChar;
-		}
-		else
-#endif
-		{
-			speed = rs_kgdb_hook(line, speed);
-			generic_putDebugChar = rs_putDebugChar;
-			generic_getDebugChar = rs_getDebugChar;
-		}
-
-		pr_info("KGDB: Using serial line /dev/ttyS%d at %d for "
-		        "session, please connect your debugger\n",
-		        line ? 1 : 0, speed);
-
-		{
-			char *s;
-			for (s = "Please connect GDB to this port\r\n"; *s; )
-				generic_putDebugChar(*s++);
-		}
-
-		/* Breakpoint is invoked after interrupts are initialised */
-	}
-}
-#endif
-
 void __init mips_nmi_setup(void)
 {
 	void *base;
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -38,10 +38,6 @@
 extern void mips_reboot_setup(void);
 extern unsigned long mips_rtc_get_time(void);
 
-#ifdef CONFIG_KGDB
-extern void kgdb_config(void);
-#endif
-
 struct resource standard_io_resources[] = {
 	{ .name = "dma1", .start = 0x00, .end = 0x1f, .flags = IORESOURCE_BUSY },
 	{ .name = "timer", .start = 0x40, .end = 0x5f, .flags = IORESOURCE_BUSY },
@@ -98,10 +94,6 @@ void __init plat_mem_setup(void)
 	 */
 	enable_dma(4);
 
-#ifdef CONFIG_KGDB
-	kgdb_config();
-#endif
-
 	if (mips_revision_sconid == MIPS_REVISION_SCON_BONITO) {
 		char *argptr;
 
--- a/arch/mips/mm/extable.c
+++ b/arch/mips/mm/extable.c
@@ -3,6 +3,7 @@
  */
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/kgdb.h>
 #include <asm/branch.h>
 #include <asm/uaccess.h>
 
@@ -16,6 +17,12 @@ int fixup_exception(struct pt_regs *regs
 
 		return 1;
 	}
+#ifdef CONFIG_KGDB
+	if (atomic_read(&debugger_active) && kgdb_may_fault)
+		/* Restore our previous state. */
+		kgdb_fault_longjmp(kgdb_fault_jmp_regs);
+		/* Not reached. */
+#endif
 
 	return 0;
 }
--- a/arch/mips/sibyte/cfe/setup.c
+++ b/arch/mips/sibyte/cfe/setup.c
@@ -58,10 +58,6 @@ int cfe_cons_handle;
 extern unsigned long initrd_start, initrd_end;
 #endif
 
-#ifdef CONFIG_KGDB
-extern int kgdb_port;
-#endif
-
 static void __noreturn cfe_linux_exit(void *arg)
 {
 	int warm = *(int *)arg;
@@ -242,9 +238,6 @@ void __init prom_init(void)
 	int argc = fw_arg0;
 	char **envp = (char **) fw_arg2;
 	int *prom_vec = (int *) fw_arg3;
-#ifdef CONFIG_KGDB
-	char *arg;
-#endif
 
 	_machine_restart   = cfe_linux_restart;
 	_machine_halt      = cfe_linux_halt;
@@ -308,13 +301,6 @@ void __init prom_init(void)
 		}
 	}
 
-#ifdef CONFIG_KGDB
-	if ((arg = strstr(arcs_cmdline, "kgdb=duart")) != NULL)
-		kgdb_port = (arg[10] == '0') ? 0 : 1;
-	else
-		kgdb_port = 1;
-#endif
-
 #ifdef CONFIG_BLK_DEV_INITRD
 	{
 		char *ptr;
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/kernel_stat.h>
+#include <linux/kgdb.h>
 
 #include <asm/errno.h>
 #include <asm/signal.h>
@@ -57,16 +58,6 @@ static void sb1250_set_affinity(unsigned
 extern unsigned long ldt_eoi_space;
 #endif
 
-#ifdef CONFIG_KGDB
-static int kgdb_irq;
-
-/* Default to UART1 */
-int kgdb_port = 1;
-#ifdef CONFIG_SERIAL_SB1250_DUART
-extern char sb1250_duart_present[];
-#endif
-#endif
-
 static struct irq_chip sb1250_irq_type = {
 	.name = "SB1250-IMR",
 	.ack = ack_sb1250_irq,
@@ -305,6 +296,11 @@ void __init arch_init_irq(void)
 	unsigned int imask = STATUSF_IP4 | STATUSF_IP3 | STATUSF_IP2 |
 		STATUSF_IP1 | STATUSF_IP0;
 
+#ifdef CONFIG_KGDB
+	if (kgdb_early_setup)
+		return;
+#endif
+
 	/* Default everything to IP2 */
 	for (i = 0; i < SB1250_NR_IRQS; i++) {	/* was I0 */
 		__raw_writeq(IMR_IP2_VAL,
@@ -350,56 +346,13 @@ void __init arch_init_irq(void)
 	 * does its own management of IP7.
 	 */
 
-#ifdef CONFIG_KGDB
+#ifdef CONFIG_KGDB_SIBYTE
 	imask |= STATUSF_IP6;
 #endif
 	/* Enable necessary IPs, disable the rest */
 	change_c0_status(ST0_IM, imask);
-
-#ifdef CONFIG_KGDB
-	if (kgdb_flag) {
-		kgdb_irq = K_INT_UART_0 + kgdb_port;
-
-#ifdef CONFIG_SERIAL_SB1250_DUART
-		sb1250_duart_present[kgdb_port] = 0;
-#endif
-		/* Setup uart 1 settings, mapper */
-		__raw_writeq(M_DUART_IMR_BRK,
-			     IOADDR(A_DUART_IMRREG(kgdb_port)));
-
-		sb1250_steal_irq(kgdb_irq);
-		__raw_writeq(IMR_IP6_VAL,
-			     IOADDR(A_IMR_REGISTER(0,
-						   R_IMR_INTERRUPT_MAP_BASE) +
-				    (kgdb_irq << 3)));
-		sb1250_unmask_irq(0, kgdb_irq);
-	}
-#endif
 }
 
-#ifdef CONFIG_KGDB
-
-#include <linux/delay.h>
-
-#define duart_out(reg, val)     csr_out32(val, IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-#define duart_in(reg)           csr_in32(IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-
-static void sb1250_kgdb_interrupt(void)
-{
-	/*
-	 * Clear break-change status (allow some time for the remote
-	 * host to stop the break, since we would see another
-	 * interrupt on the end-of-break too)
-	 */
-	kstat_this_cpu.irqs[kgdb_irq]++;
-	mdelay(500);
-	duart_out(R_DUART_CMD, V_DUART_MISC_CMD_RESET_BREAK_INT |
-				M_DUART_RX_EN | M_DUART_TX_EN);
-	set_async_breakpoint(&get_irq_regs()->cp0_epc);
-}
-
-#endif 	/* CONFIG_KGDB */
-
 static inline void sb1250_timer_interrupt(void)
 {
 	int cpu = smp_processor_id();
@@ -434,6 +387,7 @@ static inline void sb1250_timer_interrup
 }
 
 extern void sb1250_mailbox_interrupt(void);
+extern void sb1250_kgdb_interrupt(void);
 
 asmlinkage void plat_irq_dispatch(void)
 {
@@ -461,7 +415,7 @@ asmlinkage void plat_irq_dispatch(void)
 		sb1250_mailbox_interrupt();
 #endif
 
-#ifdef CONFIG_KGDB
+#ifdef CONFIG_KGDB_SIBYTE
 	else if (pending & CAUSEF_IP6)			/* KGDB (uart 1) */
 		sb1250_kgdb_interrupt();
 #endif
--- /dev/null
+++ b/arch/mips/sibyte/sb1250/kgdb_sibyte.c
@@ -0,0 +1,145 @@
+/*
+ * arch/mips/sibyte/sb1250/kgdb_sibyte.c
+ *
+ * Author: Manish Lachwani, mlachwani@mvista.com or manish@koffee-break.com
+ *
+ * 2004 (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ */
+
+/*
+ * Support for KGDB on the Broadcom Sibyte. The SWARM board
+ * for example does not have a 8250/16550 compatible serial
+ * port. Hence, we need to have a driver for the serial
+ * ports to handle KGDB.  This board needs nothing in addition
+ * to what is normally provided by the gdb portion of the stub.
+ */
+
+#include <linux/delay.h>
+#include <linux/kernel_stat.h>
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/io.h>
+
+#include <asm/sibyte/sb1250.h>
+#include <asm/sibyte/sb1250_regs.h>
+#include <asm/sibyte/sb1250_uart.h>
+#include <asm/sibyte/sb1250_int.h>
+#include <asm/addrspace.h>
+
+int kgdb_port = 1;
+static int kgdb_irq;
+
+extern char sb1250_duart_present[];
+extern int sb1250_steal_irq(int irq);
+
+/* Forward declarations. */
+static void kgdbsibyte_init_duart(void);
+static int kgdb_init_io(void);
+
+#define IMR_IP6_VAL	K_INT_MAP_I4
+#define	duart_out(reg, val)	csr_out32(val, \
+		IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
+#define duart_in(reg) csr_in32(IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
+
+static void kgdbsibyte_write_char(u8 c)
+{
+	while ((duart_in(R_DUART_STATUS) & M_DUART_TX_RDY) == 0) ;
+	duart_out(R_DUART_TX_HOLD, c);
+}
+
+static int kgdbsibyte_read_char(void)
+{
+	int ret_char;
+	unsigned int status;
+
+	do {
+		status = duart_in(R_DUART_STATUS);
+	} while ((status & M_DUART_RX_RDY) == 0);
+
+	/*
+	 * Check for framing error
+	 */
+	if (status & M_DUART_FRM_ERR) {
+		kgdbsibyte_init_duart();
+		kgdbsibyte_write_char('-');
+		return '-';
+	}
+
+	ret_char = duart_in(R_DUART_RX_HOLD);
+
+	return ret_char;
+}
+
+void sb1250_kgdb_interrupt(void)
+{
+	int kgdb_irq = K_INT_UART_0 + kgdb_port;
+
+	/*
+	 * Clear break-change status (allow some time for the remote
+	 * host to stop the break, since we would see another
+	 * interrupt on the end-of-break too)
+	 */
+	kstat_this_cpu.irqs[kgdb_irq]++;
+	mdelay(500);
+	duart_out(R_DUART_CMD, V_DUART_MISC_CMD_RESET_BREAK_INT |
+		  M_DUART_RX_EN | M_DUART_TX_EN);
+	breakpoint();
+
+}
+
+/*
+ * We use port #1 and we set it for 115200 BAUD, 8n1.
+ */
+static void kgdbsibyte_init_duart(void)
+{
+	/* Set 8n1. */
+	duart_out(R_DUART_MODE_REG_1,
+		  V_DUART_BITS_PER_CHAR_8 | V_DUART_PARITY_MODE_NONE);
+	duart_out(R_DUART_MODE_REG_2, M_DUART_STOP_BIT_LEN_1);
+	/* Set baud rate of 115200. */
+	duart_out(R_DUART_CLK_SEL, V_DUART_BAUD_RATE(115200));
+	/* Enable rx and tx */
+	duart_out(R_DUART_CMD, M_DUART_RX_EN | M_DUART_TX_EN);
+}
+
+static int kgdb_init_io(void)
+{
+#ifdef CONFIG_SIBYTE_SB1250_DUART
+	sb1250_duart_present[kgdb_port] = 0;
+#endif
+
+	kgdbsibyte_init_duart();
+
+	return 0;
+}
+
+/*
+ * Hookup our IRQ line.  We will already have been initialized a
+ * this point.
+ */
+static void __init kgdbsibyte_hookup_irq(void)
+{
+	/* Steal the IRQ. */
+	kgdb_irq = K_INT_UART_0 + kgdb_port;
+
+	/* Setup uart 1 settings, mapper */
+	__raw_writeq(M_DUART_IMR_BRK, IOADDR(A_DUART_IMRREG(kgdb_port)));
+
+	sb1250_steal_irq(kgdb_irq);
+
+	__raw_writeq(IMR_IP6_VAL,
+		     IOADDR(A_IMR_REGISTER(0, R_IMR_INTERRUPT_MAP_BASE) +
+			    (kgdb_irq << 3)));
+
+	sb1250_unmask_irq(0, kgdb_irq);
+}
+
+struct kgdb_io kgdb_io_ops = {
+	.read_char  = kgdbsibyte_read_char,
+	.write_char = kgdbsibyte_write_char,
+	.init = kgdb_init_io,
+	.late_init  = kgdbsibyte_hookup_irq,
+};
--- a/arch/mips/sibyte/swarm/Makefile
+++ b/arch/mips/sibyte/swarm/Makefile
@@ -1,3 +1 @@
 lib-y				= setup.o rtc_xicor1241.o rtc_m41t81.o
-
-lib-$(CONFIG_KGDB)		+= dbg_io.o
--- a/arch/mips/sibyte/swarm/dbg_io.c
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * kgdb debug routines for SiByte boards.
- *
- * Copyright (C) 2001 MontaVista Software Inc.
- * Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- *
- */
-
-/* -------------------- BEGINNING OF CONFIG --------------------- */
-
-#include <linux/delay.h>
-#include <asm/io.h>
-#include <asm/sibyte/sb1250.h>
-#include <asm/sibyte/sb1250_regs.h>
-#include <asm/sibyte/sb1250_uart.h>
-#include <asm/sibyte/sb1250_int.h>
-#include <asm/addrspace.h>
-
-/*
- * We use the second serial port for kgdb traffic.
- * 	115200, 8, N, 1.
- */
-
-#define	BAUD_RATE		115200
-#define	CLK_DIVISOR		V_DUART_BAUD_RATE(BAUD_RATE)
-#define	DATA_BITS		V_DUART_BITS_PER_CHAR_8		/* or 7    */
-#define	PARITY			V_DUART_PARITY_MODE_NONE	/* or even */
-#define	STOP_BITS		M_DUART_STOP_BIT_LEN_1		/* or 2    */
-
-static int duart_initialized = 0;	/* 0: need to be init'ed by kgdb */
-
-/* -------------------- END OF CONFIG --------------------- */
-extern int kgdb_port;
-
-#define	duart_out(reg, val)	csr_out32(val, IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-#define duart_in(reg)		csr_in32(IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-
-void putDebugChar(unsigned char c);
-unsigned char getDebugChar(void);
-static void
-duart_init(int clk_divisor, int data, int parity, int stop)
-{
-	duart_out(R_DUART_MODE_REG_1, data | parity);
-	duart_out(R_DUART_MODE_REG_2, stop);
-	duart_out(R_DUART_CLK_SEL, clk_divisor);
-
-	duart_out(R_DUART_CMD, M_DUART_RX_EN | M_DUART_TX_EN);	/* enable rx and tx */
-}
-
-void
-putDebugChar(unsigned char c)
-{
-	if (!duart_initialized) {
-		duart_initialized = 1;
-		duart_init(CLK_DIVISOR, DATA_BITS, PARITY, STOP_BITS);
-	}
-	while ((duart_in(R_DUART_STATUS) & M_DUART_TX_RDY) == 0);
-	duart_out(R_DUART_TX_HOLD, c);
-}
-
-unsigned char
-getDebugChar(void)
-{
-	if (!duart_initialized) {
-		duart_initialized = 1;
-		duart_init(CLK_DIVISOR, DATA_BITS, PARITY, STOP_BITS);
-	}
-	while ((duart_in(R_DUART_STATUS) & M_DUART_RX_RDY) == 0) ;
-	return duart_in(R_DUART_RX_HOLD);
-}
-
--- a/arch/mips/tx4927/common/Makefile
+++ b/arch/mips/tx4927/common/Makefile
@@ -9,6 +9,5 @@
 obj-y	+= tx4927_prom.o tx4927_setup.o tx4927_irq.o
 
 obj-$(CONFIG_TOSHIBA_FPCIB0)	   += smsc_fdc37m81x.o
-obj-$(CONFIG_KGDB)                 += tx4927_dbgio.o
 
 EXTRA_CFLAGS += -Werror
--- a/arch/mips/tx4927/common/tx4927_dbgio.c
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * linux/arch/mips/tx4927/common/tx4927_dbgio.c
- *
- * kgdb interface for gdb
- *
- * Author: MontaVista Software, Inc.
- *         source@mvista.com
- *
- * Copyright 2001-2002 MontaVista Software Inc.
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License as published by the
- *  Free Software Foundation; either version 2 of the License, or (at your
- *  option) any later version.
- *
- *  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
- *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
- *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
- *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
- *  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
- *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- *  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <asm/mipsregs.h>
-#include <asm/system.h>
-
-u8 getDebugChar(void)
-{
-	extern u8 txx9_sio_kdbg_rd(void);
-	return (txx9_sio_kdbg_rd());
-}
-
-
-int putDebugChar(u8 byte)
-{
-	extern int txx9_sio_kdbg_wr( u8 ch );
-	return (txx9_sio_kdbg_wr(byte));
-}
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
+++ b/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
@@ -76,7 +76,7 @@
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #endif
-#ifdef CONFIG_SERIAL_TXX9
+#if defined(CONFIG_SERIAL_TXX9) || defined(CONFIG_KGDB_TXX9)
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
@@ -891,9 +891,10 @@ void __init toshiba_rbtx4927_setup(void)
 
 #endif /* CONFIG_PCI */
 
-#ifdef CONFIG_SERIAL_TXX9
+#if defined(CONFIG_SERIAL_TXX9) || defined(CONFIG_KGDB_TXX9)
 	{
 		extern int early_serial_txx9_setup(struct uart_port *port);
+		extern int txx9_kgdb_add_port(int n, struct uart_port *port);
 		int i;
 		struct uart_port req;
 		for(i = 0; i < 2; i++) {
@@ -905,7 +906,12 @@ void __init toshiba_rbtx4927_setup(void)
 			req.irq = TX4927_IRQ_PIC_BEG + 8 + i;
 			req.flags |= UPF_BUGGY_UART /*HAVE_CTS_LINE*/;
 			req.uartclk = 50000000;
+#ifdef CONFIG_SERIAL_TXX9
 			early_serial_txx9_setup(&req);
+#endif
+#ifdef CONFIG_KGDB_TXX9
+			txx9_kgdb_add_port(i, &req);
+#endif
 		}
 	}
 #ifdef CONFIG_SERIAL_TXX9_CONSOLE
@@ -914,7 +920,7 @@ void __init toshiba_rbtx4927_setup(void)
                 strcat(argptr, " console=ttyS0,38400");
         }
 #endif
-#endif
+#endif /* defined(CONFIG_SERIAL_TXX9) || defined(CONFIG_KGDB_TXX9) */
 
 #ifdef CONFIG_ROOT_NFS
         argptr = prom_getcmdline();
--- a/arch/mips/tx4938/common/Makefile
+++ b/arch/mips/tx4938/common/Makefile
@@ -7,6 +7,5 @@
 #
 
 obj-y	+= prom.o setup.o irq.o
-obj-$(CONFIG_KGDB) += dbgio.o
 
 EXTRA_CFLAGS += -Werror
--- a/arch/mips/tx4938/common/dbgio.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * linux/arch/mips/tx4938/common/dbgio.c
- *
- * kgdb interface for gdb
- *
- * Author: MontaVista Software, Inc.
- *         source@mvista.com
- *
- * Copyright 2005 MontaVista Software Inc.
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License as published by the
- *  Free Software Foundation; either version 2 of the License, or (at your
- *  option) any later version.
- *
- *  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
- *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
- *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
- *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
- *  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
- *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- *  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Support for TX4938 in 2.6 - Hiroshi DOYU <Hiroshi_DOYU@montavista.co.jp>
- */
-
-#include <asm/mipsregs.h>
-#include <asm/system.h>
-#include <asm/tx4938/tx4938_mips.h>
-
-extern u8 txx9_sio_kdbg_rd(void);
-extern int txx9_sio_kdbg_wr( u8 ch );
-
-u8 getDebugChar(void)
-{
-	return (txx9_sio_kdbg_rd());
-}
-
-int putDebugChar(u8 byte)
-{
-	return (txx9_sio_kdbg_wr(byte));
-}
-
--- a/arch/mips/tx4938/toshiba_rbtx4938/setup.c
+++ b/arch/mips/tx4938/toshiba_rbtx4938/setup.c
@@ -30,7 +30,7 @@
 #include <asm/io.h>
 #include <asm/bootinfo.h>
 #include <asm/tx4938/rbtx4938.h>
-#ifdef CONFIG_SERIAL_TXX9
+#if defined(CONFIG_SERIAL_TXX9) || defined(CONFIG_KGDB_TXX9)
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
@@ -878,9 +878,10 @@ void __init toshiba_rbtx4938_setup(void)
 	set_io_port_base(RBTX4938_ETHER_BASE);
 #endif
 
-#ifdef CONFIG_SERIAL_TXX9
+#if defined(CONFIG_SERIAL_TXX9) || defined(CONFIG_KGDB_TXX9)
 	{
 		extern int early_serial_txx9_setup(struct uart_port *port);
+		extern int txx9_kgdb_add_port(int n, struct uart_port *port);
 		int i;
 		struct uart_port req;
 		for(i = 0; i < 2; i++) {
@@ -892,7 +893,12 @@ void __init toshiba_rbtx4938_setup(void)
 			req.irq = RBTX4938_IRQ_IRC_SIO(i);
 			req.flags |= UPF_BUGGY_UART /*HAVE_CTS_LINE*/;
 			req.uartclk = 50000000;
+#ifdef CONFIG_SERIAL_TXX9
 			early_serial_txx9_setup(&req);
+#endif
+#ifdef CONFIG_KGDB_TXX9
+			txx9_kgdb_add_port(i, &req);
+#endif
 		}
 	}
 #ifdef CONFIG_SERIAL_TXX9_CONSOLE
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_SERIAL_SB1250_DUART) += sb1
 obj-$(CONFIG_ETRAX_SERIAL) += crisv10.o
 obj-$(CONFIG_SERIAL_JSM) += jsm/
 obj-$(CONFIG_SERIAL_TXX9) += serial_txx9.o
+obj-$(CONFIG_KGDB_TXX9) += serial_txx9_kgdb.o
 obj-$(CONFIG_SERIAL_VR41XX) += vr41xx_siu.o
 obj-$(CONFIG_SERIAL_SGI_IOC4) += ioc4_serial.o
 obj-$(CONFIG_SERIAL_SGI_IOC3) += ioc3_serial.o
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -40,6 +40,10 @@
 static char *serial_version = "1.10";
 static char *serial_name = "TX39/49 Serial driver";
 
+#ifndef CONFIG_KGDB_TXX9
+#define CONFIG_KGDB_PORT_NUM -1
+#endif
+
 #define PASS_LIMIT	256
 
 #if !defined(CONFIG_SERIAL_TXX9_STDSERIAL)
@@ -473,6 +477,9 @@ static int serial_txx9_startup(struct ua
 	unsigned long flags;
 	int retval;
 
+	if (up->port.line == CONFIG_KGDB_PORT_NUM)
+		return -EBUSY;
+
 	/*
 	 * Clear the FIFO buffers and disable them.
 	 * (they will be reenabled in set_termios())
@@ -807,6 +814,9 @@ static void __init serial_txx9_register_
 	for (i = 0; i < UART_NR; i++) {
 		struct uart_txx9_port *up = &serial_txx9_ports[i];
 
+		if (up->port.line == CONFIG_KGDB_PORT_NUM)
+			continue;
+
 		up->port.line = i;
 		up->port.ops = &serial_txx9_pops;
 		up->port.dev = dev;
@@ -975,6 +985,9 @@ static int __devinit serial_txx9_registe
 
 	mutex_lock(&serial_txx9_mutex);
 	for (i = 0; i < UART_NR; i++) {
+		if (i == CONFIG_KGDB_PORT_NUM)
+			continue;
+
 		uart = &serial_txx9_ports[i];
 		if (uart_match_port(&uart->port, port)) {
 			uart_remove_one_port(&serial_txx9_reg, &uart->port);
--- a/include/asm-mips/kdebug.h
+++ b/include/asm-mips/kdebug.h
@@ -1 +1,29 @@
-#include <asm-generic/kdebug.h>
+/*
+ *
+ * Copyright (C) 2004  MontaVista Software Inc.
+ * Author: Manish Lachwani, mlachwani@mvista.com or manish@koffee-break.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+#ifndef _MIPS_KDEBUG_H
+#define _MIPS_KDEBUG_H
+
+#include <linux/notifier.h>
+
+struct pt_regs;
+
+extern struct atomic_notifier_head mips_die_head;
+
+enum die_val {
+	DIE_OOPS = 1,
+	DIE_PANIC,
+	DIE_DIE,
+	DIE_KERNELDEBUG,
+	DIE_TRAP,
+};
+
+#endif /* _MIPS_KDEBUG_H */
--- /dev/null
+++ b/include/asm-mips/kgdb.h
@@ -0,0 +1,48 @@
+#ifdef __KERNEL__
+#ifndef _ASM_KGDB_H_
+#define _ASM_KGDB_H_
+
+#include <asm/sgidefs.h>
+#include <asm-generic/kgdb.h>
+
+#ifndef __ASSEMBLY__
+#if (_MIPS_ISA == _MIPS_ISA_MIPS1) || (_MIPS_ISA == _MIPS_ISA_MIPS2) || \
+	(_MIPS_ISA == _MIPS_ISA_MIPS32)
+
+#define KGDB_GDB_REG_SIZE 32
+
+#elif (_MIPS_ISA == _MIPS_ISA_MIPS3) || (_MIPS_ISA == _MIPS_ISA_MIPS4) || \
+	(_MIPS_ISA == _MIPS_ISA_MIPS64)
+
+#ifdef CONFIG_32BIT
+#define KGDB_GDB_REG_SIZE 32
+#else /* CONFIG_CPU_32BIT */
+#define KGDB_GDB_REG_SIZE 64
+#endif
+#else
+#error "Need to set KGDB_GDB_REG_SIZE for MIPS ISA"
+#endif /* _MIPS_ISA */
+
+#define BUFMAX			2048
+#if (KGDB_GDB_REG_SIZE == 32)
+#define NUMREGBYTES		(90*sizeof(u32))
+#define NUMCRITREGBYTES		(12*sizeof(u32))
+#else
+#define NUMREGBYTES		(90*sizeof(u64))
+#define NUMCRITREGBYTES		(12*sizeof(u64))
+#endif
+#define BREAK_INSTR_SIZE	4
+#define BREAKPOINT()		__asm__ __volatile__(\
+					".globl breakinst\n\t"	\
+					".set\tnoreorder\n\t"	\
+					"nop\n"			\
+					"breakinst:\tbreak\n\t"	\
+					"nop\n\t"		\
+					".set\treorder")
+#define CACHE_FLUSH_IS_SAFE	0
+
+extern int kgdb_early_setup;
+
+#endif				/* !__ASSEMBLY__ */
+#endif				/* _ASM_KGDB_H_ */
+#endif				/* __KERNEL__ */
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -13,7 +13,7 @@ config UNWIND_INFO
 config KGDB
 	bool "KGDB: kernel debugging with remote gdb"
 	select WANT_EXTRA_DEBUG_INFORMATION
-	depends on DEBUG_KERNEL && (X86 || PPC)
+	depends on DEBUG_KERNEL && (X86 || MIPS || PPC)
 	help
 	  If you say Y here, it will be possible to remotely debug the
 	  kernel using gdb.  Documentation of kernel debugger is available
@@ -41,6 +41,8 @@ choice
 	depends on KGDB
 	default KGDB_MPSC if SERIAL_MPSC
 	default KGDB_CPM_UART if (CPM2 || 8xx)
+	default KGDB_SIBYTE if SIBYTE_SB1xxx_SOC
+ 	default KGDB_TXX9 if CPU_TX49XX
 	default KGDB_8250_NOMODULE
 	help
 	  There are a number of different ways in which you can communicate
@@ -91,6 +93,16 @@ config KGDB_CPM_UART
 	depends on PPC && (CPM2 || 8xx)
  	help
  	  Uses CPM UART to communicate with the host GDB.
+
+config KGDB_SIBYTE
+	bool "KGDB: On Broadcom SB1xxx serial port"
+	depends on MIPS && SIBYTE_SB1xxx_SOC
+
+config KGDB_TXX9
+	bool "KGDB: On TX49xx serial port"
+	depends on MIPS && CPU_TX49XX
+	help
+	  Uses TX49xx serial port to communicate with the host GDB.
 endchoice
 
 choice
@@ -158,7 +170,8 @@ config KGDB_SIMPLE_SERIAL
 config KGDB_BAUDRATE
 	int "Debug serial port baud rate"
 	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL) || \
-		KGDB_MPSC || KGDB_CPM_UART
+		KGDB_MPSC || KGDB_CPM_UART || \
+		KGDB_TXX9
 	default "115200"
 	help
 	  gdb and the kernel stub need to agree on the baud rate to be
@@ -169,7 +182,7 @@ config KGDB_PORT_NUM
 	int "Serial port number for KGDB"
 	range 0 1 if KGDB_MPSC
 	range 0 3
-	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL) || KGDB_MPSC
+	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL) || KGDB_MPSC || KGDB_TXX9
 	default "1"
 	help
 	  Pick the port number (0 based) for KGDB to use.
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -30,7 +30,6 @@ config BASLER_EXCITE
 	select SYS_HAS_CPU_RM9000
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	help
 	  The eXcite is a smart camera platform manufactured by
 	  Basler Vision Technologies AG.
@@ -302,7 +301,6 @@ config PMC_MSP
 	select SYS_HAS_CPU_MIPS32_R2
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	select IRQ_CPU
 	select SERIAL_8250
 	select SERIAL_8250_CONSOLE
@@ -326,7 +324,6 @@ config PMC_YOSEMITE
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_HIGHMEM
-	select SYS_SUPPORTS_KGDB
 	select SYS_SUPPORTS_SMP
 	help
 	  Yosemite is an evaluation board for the RM9000x2 processor
@@ -394,7 +391,6 @@ config SGI_IP27
 	select SYS_HAS_CPU_R10000
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SMP
 	select GENERIC_HARDIRQS_NO__DO_IRQ
@@ -476,7 +472,6 @@ config SIBYTE_SWARM
 	select SYS_HAS_CPU_SB1
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_HIGHMEM
-	select SYS_SUPPORTS_KGDB
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 
 config SIBYTE_LITTLESUR
@@ -587,7 +582,6 @@ config TOSHIBA_RBTX4927
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	select GENERIC_HARDIRQS_NO__DO_IRQ
 	help
 	  This Toshiba board is based on the TX4927 processor. Say Y here to
@@ -605,7 +599,6 @@ config TOSHIBA_RBTX4938
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	select GENERIC_HARDIRQS_NO__DO_IRQ
 	select GENERIC_GPIO
 	help
@@ -860,7 +853,6 @@ config SOC_PNX8550
 	select SYS_HAS_EARLY_PRINTK
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select GENERIC_HARDIRQS_NO__DO_IRQ
-	select SYS_SUPPORTS_KGDB
 	select GENERIC_GPIO
 
 config SWAP_IO_SPACE
--- a/arch/mips/au1000/common/Makefile
+++ b/arch/mips/au1000/common/Makefile
@@ -10,7 +10,6 @@ obj-y += prom.o irq.o puts.o time.o rese
 	au1xxx_irqmap.o clocks.o platform.o power.o setup.o \
 	sleeper.o cputable.o dma.o dbdma.o gpio.o
 
-obj-$(CONFIG_KGDB)		+= dbg_io.o
 obj-$(CONFIG_PCI)		+= pci.o
 
 EXTRA_CFLAGS += -Werror
--- a/arch/mips/au1000/common/dbg_io.c
+++ /dev/null
@@ -1,121 +0,0 @@
-
-#include <asm/io.h>
-#include <asm/mach-au1x00/au1000.h>
-
-#ifdef CONFIG_KGDB
-
-/*
- * FIXME the user should be able to select the
- * uart to be used for debugging.
- */
-#define DEBUG_BASE  UART_DEBUG_BASE
-/**/
-
-/* we need uint32 uint8 */
-/* #include "types.h" */
-typedef         unsigned char uint8;
-typedef         unsigned int  uint32;
-
-#define         UART16550_BAUD_2400             2400
-#define         UART16550_BAUD_4800             4800
-#define         UART16550_BAUD_9600             9600
-#define         UART16550_BAUD_19200            19200
-#define         UART16550_BAUD_38400            38400
-#define         UART16550_BAUD_57600            57600
-#define         UART16550_BAUD_115200           115200
-
-#define         UART16550_PARITY_NONE           0
-#define         UART16550_PARITY_ODD            0x08
-#define         UART16550_PARITY_EVEN           0x18
-#define         UART16550_PARITY_MARK           0x28
-#define         UART16550_PARITY_SPACE          0x38
-
-#define         UART16550_DATA_5BIT             0x0
-#define         UART16550_DATA_6BIT             0x1
-#define         UART16550_DATA_7BIT             0x2
-#define         UART16550_DATA_8BIT             0x3
-
-#define         UART16550_STOP_1BIT             0x0
-#define         UART16550_STOP_2BIT             0x4
-
-
-#define UART_RX		0	/* Receive buffer */
-#define UART_TX		4	/* Transmit buffer */
-#define UART_IER	8	/* Interrupt Enable Register */
-#define UART_IIR	0xC	/* Interrupt ID Register */
-#define UART_FCR	0x10	/* FIFO Control Register */
-#define UART_LCR	0x14	/* Line Control Register */
-#define UART_MCR	0x18	/* Modem Control Register */
-#define UART_LSR	0x1C	/* Line Status Register */
-#define UART_MSR	0x20	/* Modem Status Register */
-#define UART_CLK	0x28	/* Baud Rat4e Clock Divider */
-#define UART_MOD_CNTRL	0x100	/* Module Control */
-
-/* memory-mapped read/write of the port */
-#define UART16550_READ(y)    (au_readl(DEBUG_BASE + y) & 0xff)
-#define UART16550_WRITE(y, z) (au_writel(z&0xff, DEBUG_BASE + y))
-
-extern unsigned long get_au1x00_uart_baud_base(void);
-extern unsigned long cal_r4koff(void);
-
-void debugInit(uint32 baud, uint8 data, uint8 parity, uint8 stop)
-{
-
-	if (UART16550_READ(UART_MOD_CNTRL) != 0x3) {
-		UART16550_WRITE(UART_MOD_CNTRL, 3);
-	}
-	cal_r4koff();
-
-	/* disable interrupts */
-	UART16550_WRITE(UART_IER, 0);
-
-	/* set up baud rate */
-	{
-		uint32 divisor;
-
-		/* set divisor */
-		divisor = get_au1x00_uart_baud_base() / baud;
-		UART16550_WRITE(UART_CLK, divisor & 0xffff);
-	}
-
-	/* set data format */
-	UART16550_WRITE(UART_LCR, (data | parity | stop));
-}
-
-static int remoteDebugInitialized = 0;
-
-uint8 getDebugChar(void)
-{
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(UART16550_BAUD_115200,
-			  UART16550_DATA_8BIT,
-			  UART16550_PARITY_NONE,
-			  UART16550_STOP_1BIT);
-	}
-
-	while((UART16550_READ(UART_LSR) & 0x1) == 0);
-	return UART16550_READ(UART_RX);
-}
-
-
-int putDebugChar(uint8 byte)
-{
-//	int i;
-
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(UART16550_BAUD_115200,
-			  UART16550_DATA_8BIT,
-			  UART16550_PARITY_NONE,
-			  UART16550_STOP_1BIT);
-	}
-
-	while ((UART16550_READ(UART_LSR)&0x40) == 0);
-	UART16550_WRITE(UART_TX, byte);
-	//for (i=0;i<0xfff;i++);
-
-	return 1;
-}
-
-#endif
--- a/arch/mips/basler/excite/Makefile
+++ b/arch/mips/basler/excite/Makefile
@@ -5,5 +5,4 @@
 obj-$(CONFIG_BASLER_EXCITE)	+= excite_irq.o excite_prom.o excite_setup.o \
 				   excite_device.o excite_procfs.o
 
-obj-$(CONFIG_KGDB)		+= excite_dbg_io.o
 obj-m				+= excite_iodev.o
--- a/arch/mips/basler/excite/excite_dbg_io.c
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- *  Copyright (C) 2004 by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslerweb.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <asm/gdb-stub.h>
-#include <asm/rm9k-ocd.h>
-#include <excite.h>
-
-#if defined(CONFIG_SERIAL_8250) && CONFIG_SERIAL_8250_NR_UARTS > 1
-#error Debug port used by serial driver
-#endif
-
-#define UART_CLK		25000000
-#define BASE_BAUD		(UART_CLK / 16)
-#define REGISTER_BASE_0		0x0208UL
-#define REGISTER_BASE_1		0x0238UL
-
-#define REGISTER_BASE_DBG	REGISTER_BASE_1
-
-#define CPRR	0x0004
-#define UACFG	0x0200
-#define UAINTS	0x0204
-#define UARBR	(REGISTER_BASE_DBG + 0x0000)
-#define UATHR	(REGISTER_BASE_DBG + 0x0004)
-#define UADLL	(REGISTER_BASE_DBG + 0x0008)
-#define UAIER	(REGISTER_BASE_DBG + 0x000c)
-#define UADLH	(REGISTER_BASE_DBG + 0x0010)
-#define UAIIR	(REGISTER_BASE_DBG + 0x0014)
-#define UAFCR	(REGISTER_BASE_DBG + 0x0018)
-#define UALCR	(REGISTER_BASE_DBG + 0x001c)
-#define UAMCR	(REGISTER_BASE_DBG + 0x0020)
-#define UALSR	(REGISTER_BASE_DBG + 0x0024)
-#define UAMSR	(REGISTER_BASE_DBG + 0x0028)
-#define UASCR	(REGISTER_BASE_DBG + 0x002c)
-
-#define	PARITY_NONE	0
-#define	PARITY_ODD	0x08
-#define	PARITY_EVEN	0x18
-#define	PARITY_MARK	0x28
-#define	PARITY_SPACE	0x38
-
-#define	DATA_5BIT	0x0
-#define	DATA_6BIT	0x1
-#define	DATA_7BIT	0x2
-#define	DATA_8BIT	0x3
-
-#define	STOP_1BIT	0x0
-#define	STOP_2BIT	0x4
-
-#define BAUD_DBG	57600
-#define	PARITY_DBG	PARITY_NONE
-#define	DATA_DBG	DATA_8BIT
-#define	STOP_DBG	STOP_1BIT
-
-/* Initialize the serial port for KGDB debugging */
-void __init excite_kgdb_init(void)
-{
-	const u32 divisor = BASE_BAUD / BAUD_DBG;
-
-	/* Take the UART out of reset */
-	titan_writel(0x00ff1cff, CPRR);
-	titan_writel(0x00000000, UACFG);
-	titan_writel(0x00000002, UACFG);
-
-	titan_writel(0x0, UALCR);
-	titan_writel(0x0, UAIER);
-
-	/* Disable FIFOs */
-	titan_writel(0x00, UAFCR);
-
-	titan_writel(0x80, UALCR);
-	titan_writel(divisor & 0xff, UADLL);
-	titan_writel((divisor & 0xff00) >> 8, UADLH);
-	titan_writel(0x0, UALCR);
-
-	titan_writel(DATA_DBG | PARITY_DBG | STOP_DBG, UALCR);
-
-	/* Enable receiver interrupt */
-	titan_readl(UARBR);
-	titan_writel(0x1, UAIER);
-}
-
-int getDebugChar(void)
-{
-	while (!(titan_readl(UALSR) & 0x1));
-	return titan_readl(UARBR);
-}
-
-int putDebugChar(int data)
-{
-	while (!(titan_readl(UALSR) & 0x20));
-	titan_writel(data, UATHR);
-	return 1;
-}
-
-/* KGDB interrupt handler */
-asmlinkage void excite_kgdb_inthdl(void)
-{
-	if (unlikely(
-		((titan_readl(UAIIR) & 0x7) == 4)
-		&& ((titan_readl(UARBR) & 0xff) == 0x3)))
-			set_async_breakpoint(&regs->cp0_epc);
-}
--- a/arch/mips/basler/excite/excite_irq.c
+++ b/arch/mips/basler/excite/excite_irq.c
@@ -50,10 +50,6 @@ void __init arch_init_irq(void)
 	mips_cpu_irq_init();
 	rm7k_cpu_irq_init();
 	rm9k_cpu_irq_init();
-
-#ifdef CONFIG_KGDB
-	excite_kgdb_init();
-#endif
 }
 
 asmlinkage void plat_irq_dispatch(void)
@@ -90,9 +86,6 @@ asmlinkage void plat_irq_dispatch(void)
 	msgint	    = msgintflags & msgintmask & (0x1 << (TITAN_MSGINT % 0x20));
 	if ((pending & (1 << TITAN_IRQ)) && msgint) {
 		ocd_writel(msgint, INTP0Clear0 + (TITAN_MSGINT / 0x20 * 0x10));
-#if defined(CONFIG_KGDB)
-		excite_kgdb_inthdl();
-#endif
 		do_IRQ(TITAN_IRQ);
 		return;
 	}
--- a/arch/mips/basler/excite/excite_setup.c
+++ b/arch/mips/basler/excite/excite_setup.c
@@ -96,13 +96,13 @@ static int __init excite_init_console(vo
 	/* Take the DUART out of reset */
 	titan_writel(0x00ff1cff, CPRR);
 
-#if defined(CONFIG_KGDB) || (CONFIG_SERIAL_8250_NR_UARTS > 1)
+#if (CONFIG_SERIAL_8250_NR_UARTS > 1)
 	/* Enable both ports */
 	titan_writel(MASK_SER0 | MASK_SER1, UACFG);
 #else
 	/* Enable port #0 only */
 	titan_writel(MASK_SER0, UACFG);
-#endif	/* defined(CONFIG_KGDB) */
+#endif
 
  	/*
 	 * Set up serial port #0. Do not use autodetection; the result is
--- a/arch/mips/jmr3927/rbhma3100/Makefile
+++ b/arch/mips/jmr3927/rbhma3100/Makefile
@@ -3,6 +3,5 @@
 #
 
 obj-y	 			+= init.o irq.o setup.o
-obj-$(CONFIG_KGDB)		+= kgdb_io.o
 
 EXTRA_CFLAGS += -Werror
--- a/arch/mips/jmr3927/rbhma3100/kgdb_io.c
+++ /dev/null
@@ -1,105 +0,0 @@
-/*
- * BRIEF MODULE DESCRIPTION
- *	Low level uart routines to directly access a TX[34]927 SIO.
- *
- * Copyright 2001 MontaVista Software Inc.
- * Author: MontaVista Software, Inc.
- *         	ahennessy@mvista.com or source@mvista.com
- *
- * Based on arch/mips/ddb5xxx/ddb5477/kgdb_io.c
- *
- * Copyright (C) 2000-2001 Toshiba Corporation
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <asm/jmr3927/jmr3927.h>
-
-#define TIMEOUT       0xffffff
-
-static int remoteDebugInitialized = 0;
-static void debugInit(int baud);
-
-int putDebugChar(unsigned char c)
-{
-        int i = 0;
-
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(38400);
-	}
-
-        do {
-            slow_down();
-            i++;
-            if (i>TIMEOUT) {
-                break;
-            }
-        } while (!(tx3927_sioptr(0)->cisr & TXx927_SICISR_TXALS));
-	tx3927_sioptr(0)->tfifo = c;
-
-	return 1;
-}
-
-unsigned char getDebugChar(void)
-{
-        int i = 0;
-	int dicr;
-	char c;
-
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(38400);
-	}
-
-	/* diable RX int. */
-	dicr = tx3927_sioptr(0)->dicr;
-	tx3927_sioptr(0)->dicr = 0;
-
-        do {
-            slow_down();
-            i++;
-            if (i>TIMEOUT) {
-                break;
-            }
-        } while (tx3927_sioptr(0)->disr & TXx927_SIDISR_UVALID)
-		;
-	c = tx3927_sioptr(0)->rfifo;
-
-	/* clear RX int. status */
-	tx3927_sioptr(0)->disr &= ~TXx927_SIDISR_RDIS;
-	/* enable RX int. */
-	tx3927_sioptr(0)->dicr = dicr;
-
-	return c;
-}
-
-static void debugInit(int baud)
-{
-	tx3927_sioptr(0)->lcr = 0x020;
-	tx3927_sioptr(0)->dicr = 0;
-	tx3927_sioptr(0)->disr = 0x4100;
-	tx3927_sioptr(0)->cisr = 0x014;
-	tx3927_sioptr(0)->fcr = 0;
-	tx3927_sioptr(0)->flcr = 0x02;
-	tx3927_sioptr(0)->bgr = ((JMR3927_BASE_BAUD + baud / 2) / baud) |
-		TXx927_SIBGR_BCLK_T0;
-}
--- a/arch/mips/kernel/gdb-low.S
+++ /dev/null
@@ -1,394 +0,0 @@
-/*
- * gdb-low.S contains the low-level trap handler for the GDB stub.
- *
- * Copyright (C) 1995 Andreas Busse
- */
-#include <linux/sys.h>
-
-#include <asm/asm.h>
-#include <asm/errno.h>
-#include <asm/irqflags.h>
-#include <asm/mipsregs.h>
-#include <asm/regdef.h>
-#include <asm/stackframe.h>
-#include <asm/gdb-stub.h>
-
-#ifdef CONFIG_32BIT
-#define DMFC0	mfc0
-#define DMTC0	mtc0
-#define LDC1	lwc1
-#define SDC1	lwc1
-#endif
-#ifdef CONFIG_64BIT
-#define DMFC0	dmfc0
-#define DMTC0	dmtc0
-#define LDC1	ldc1
-#define SDC1	ldc1
-#endif
-
-/*
- * [jsun] We reserves about 2x GDB_FR_SIZE in stack.  The lower (addressed)
- * part is used to store registers and passed to exception handler.
- * The upper part is reserved for "call func" feature where gdb client
- * saves some of the regs, setups call frame and passes args.
- *
- * A trace shows about 200 bytes are used to store about half of all regs.
- * The rest should be big enough for frame setup and passing args.
- */
-
-/*
- * The low level trap handler
- */
-		.align 	5
-		NESTED(trap_low, GDB_FR_SIZE, sp)
-		.set	noat
-		.set 	noreorder
-
-		mfc0	k0, CP0_STATUS
-		sll	k0, 3     		/* extract cu0 bit */
-		bltz	k0, 1f
-		move	k1, sp
-
-		/*
-		 * Called from user mode, go somewhere else.
-		 */
-		mfc0	k0, CP0_CAUSE
-		andi	k0, k0, 0x7c
-#ifdef CONFIG_64BIT
-		dsll	k0, k0, 1
-#endif
-		PTR_L	k1, saved_vectors(k0)
-		jr	k1
-		nop
-1:
-		move	k0, sp
-		PTR_SUBU sp, k1, GDB_FR_SIZE*2	# see comment above
-		LONG_S	k0, GDB_FR_REG29(sp)
-		LONG_S	$2, GDB_FR_REG2(sp)
-
-/*
- * First save the CP0 and special registers
- */
-
-		mfc0	v0, CP0_STATUS
-		LONG_S	v0, GDB_FR_STATUS(sp)
-		mfc0	v0, CP0_CAUSE
-		LONG_S	v0, GDB_FR_CAUSE(sp)
-		DMFC0	v0, CP0_EPC
-		LONG_S	v0, GDB_FR_EPC(sp)
-		DMFC0	v0, CP0_BADVADDR
-		LONG_S	v0, GDB_FR_BADVADDR(sp)
-		mfhi	v0
-		LONG_S	v0, GDB_FR_HI(sp)
-		mflo	v0
-		LONG_S	v0, GDB_FR_LO(sp)
-
-/*
- * Now the integer registers
- */
-
-		LONG_S	zero, GDB_FR_REG0(sp)		/* I know... */
-		LONG_S	$1, GDB_FR_REG1(sp)
-		/* v0 already saved */
-		LONG_S	$3, GDB_FR_REG3(sp)
-		LONG_S	$4, GDB_FR_REG4(sp)
-		LONG_S	$5, GDB_FR_REG5(sp)
-		LONG_S	$6, GDB_FR_REG6(sp)
-		LONG_S	$7, GDB_FR_REG7(sp)
-		LONG_S	$8, GDB_FR_REG8(sp)
-		LONG_S	$9, GDB_FR_REG9(sp)
-		LONG_S	$10, GDB_FR_REG10(sp)
-		LONG_S	$11, GDB_FR_REG11(sp)
-		LONG_S	$12, GDB_FR_REG12(sp)
-		LONG_S	$13, GDB_FR_REG13(sp)
-		LONG_S	$14, GDB_FR_REG14(sp)
-		LONG_S	$15, GDB_FR_REG15(sp)
-		LONG_S	$16, GDB_FR_REG16(sp)
-		LONG_S	$17, GDB_FR_REG17(sp)
-		LONG_S	$18, GDB_FR_REG18(sp)
-		LONG_S	$19, GDB_FR_REG19(sp)
-		LONG_S	$20, GDB_FR_REG20(sp)
-		LONG_S	$21, GDB_FR_REG21(sp)
-		LONG_S	$22, GDB_FR_REG22(sp)
-		LONG_S	$23, GDB_FR_REG23(sp)
-		LONG_S	$24, GDB_FR_REG24(sp)
-		LONG_S	$25, GDB_FR_REG25(sp)
-		LONG_S	$26, GDB_FR_REG26(sp)
-		LONG_S	$27, GDB_FR_REG27(sp)
-		LONG_S	$28, GDB_FR_REG28(sp)
-		/* sp already saved */
-		LONG_S	$30, GDB_FR_REG30(sp)
-		LONG_S	$31, GDB_FR_REG31(sp)
-
-		CLI				/* disable interrupts */
-		TRACE_IRQS_OFF
-
-/*
- * Followed by the floating point registers
- */
-		mfc0	v0, CP0_STATUS		/* FPU enabled? */
-		srl	v0, v0, 16
-		andi	v0, v0, (ST0_CU1 >> 16)
-
-		beqz	v0,2f			/* disabled, skip */
-		 nop
-
-		SDC1	$0, GDB_FR_FPR0(sp)
-		SDC1	$1, GDB_FR_FPR1(sp)
-		SDC1	$2, GDB_FR_FPR2(sp)
-		SDC1	$3, GDB_FR_FPR3(sp)
-		SDC1	$4, GDB_FR_FPR4(sp)
-		SDC1	$5, GDB_FR_FPR5(sp)
-		SDC1	$6, GDB_FR_FPR6(sp)
-		SDC1	$7, GDB_FR_FPR7(sp)
-		SDC1	$8, GDB_FR_FPR8(sp)
-		SDC1	$9, GDB_FR_FPR9(sp)
-		SDC1	$10, GDB_FR_FPR10(sp)
-		SDC1	$11, GDB_FR_FPR11(sp)
-		SDC1	$12, GDB_FR_FPR12(sp)
-		SDC1	$13, GDB_FR_FPR13(sp)
-		SDC1	$14, GDB_FR_FPR14(sp)
-		SDC1	$15, GDB_FR_FPR15(sp)
-		SDC1	$16, GDB_FR_FPR16(sp)
-		SDC1	$17, GDB_FR_FPR17(sp)
-		SDC1	$18, GDB_FR_FPR18(sp)
-		SDC1	$19, GDB_FR_FPR19(sp)
-		SDC1	$20, GDB_FR_FPR20(sp)
-		SDC1	$21, GDB_FR_FPR21(sp)
-		SDC1	$22, GDB_FR_FPR22(sp)
-		SDC1	$23, GDB_FR_FPR23(sp)
-		SDC1	$24, GDB_FR_FPR24(sp)
-		SDC1	$25, GDB_FR_FPR25(sp)
-		SDC1	$26, GDB_FR_FPR26(sp)
-		SDC1	$27, GDB_FR_FPR27(sp)
-		SDC1	$28, GDB_FR_FPR28(sp)
-		SDC1	$29, GDB_FR_FPR29(sp)
-		SDC1	$30, GDB_FR_FPR30(sp)
-		SDC1	$31, GDB_FR_FPR31(sp)
-
-/*
- * FPU control registers
- */
-
-		cfc1	v0, CP1_STATUS
-		LONG_S	v0, GDB_FR_FSR(sp)
-		cfc1	v0, CP1_REVISION
-		LONG_S	v0, GDB_FR_FIR(sp)
-
-/*
- * Current stack frame ptr
- */
-
-2:
-		LONG_S	sp, GDB_FR_FRP(sp)
-
-/*
- * CP0 registers (R4000/R4400 unused registers skipped)
- */
-
-		mfc0	v0, CP0_INDEX
-		LONG_S	v0, GDB_FR_CP0_INDEX(sp)
-		mfc0	v0, CP0_RANDOM
-		LONG_S	v0, GDB_FR_CP0_RANDOM(sp)
-		DMFC0	v0, CP0_ENTRYLO0
-		LONG_S	v0, GDB_FR_CP0_ENTRYLO0(sp)
-		DMFC0	v0, CP0_ENTRYLO1
-		LONG_S	v0, GDB_FR_CP0_ENTRYLO1(sp)
-		DMFC0	v0, CP0_CONTEXT
-		LONG_S	v0, GDB_FR_CP0_CONTEXT(sp)
-		mfc0	v0, CP0_PAGEMASK
-		LONG_S	v0, GDB_FR_CP0_PAGEMASK(sp)
-		mfc0	v0, CP0_WIRED
-		LONG_S	v0, GDB_FR_CP0_WIRED(sp)
-		DMFC0	v0, CP0_ENTRYHI
-		LONG_S	v0, GDB_FR_CP0_ENTRYHI(sp)
-		mfc0	v0, CP0_PRID
-		LONG_S	v0, GDB_FR_CP0_PRID(sp)
-
-		.set	at
-
-/*
- * Continue with the higher level handler
- */
-
-		move	a0,sp
-
-		jal	handle_exception
-		 nop
-
-/*
- * Restore all writable registers, in reverse order
- */
-
-		.set	noat
-
-		LONG_L	v0, GDB_FR_CP0_ENTRYHI(sp)
-		LONG_L	v1, GDB_FR_CP0_WIRED(sp)
-		DMTC0	v0, CP0_ENTRYHI
-		mtc0	v1, CP0_WIRED
-		LONG_L	v0, GDB_FR_CP0_PAGEMASK(sp)
-		LONG_L	v1, GDB_FR_CP0_ENTRYLO1(sp)
-		mtc0	v0, CP0_PAGEMASK
-		DMTC0	v1, CP0_ENTRYLO1
-		LONG_L	v0, GDB_FR_CP0_ENTRYLO0(sp)
-		LONG_L	v1, GDB_FR_CP0_INDEX(sp)
-		DMTC0	v0, CP0_ENTRYLO0
-		LONG_L	v0, GDB_FR_CP0_CONTEXT(sp)
-		mtc0	v1, CP0_INDEX
-		DMTC0	v0, CP0_CONTEXT
-
-
-/*
- * Next, the floating point registers
- */
-		mfc0	v0, CP0_STATUS		/* check if the FPU is enabled */
-		srl	v0, v0, 16
-		andi	v0, v0, (ST0_CU1 >> 16)
-
-		beqz	v0, 3f			/* disabled, skip */
-		 nop
-
-		LDC1	$31, GDB_FR_FPR31(sp)
-		LDC1	$30, GDB_FR_FPR30(sp)
-		LDC1	$29, GDB_FR_FPR29(sp)
-		LDC1	$28, GDB_FR_FPR28(sp)
-		LDC1	$27, GDB_FR_FPR27(sp)
-		LDC1	$26, GDB_FR_FPR26(sp)
-		LDC1	$25, GDB_FR_FPR25(sp)
-		LDC1	$24, GDB_FR_FPR24(sp)
-		LDC1	$23, GDB_FR_FPR23(sp)
-		LDC1	$22, GDB_FR_FPR22(sp)
-		LDC1	$21, GDB_FR_FPR21(sp)
-		LDC1	$20, GDB_FR_FPR20(sp)
-		LDC1	$19, GDB_FR_FPR19(sp)
-		LDC1	$18, GDB_FR_FPR18(sp)
-		LDC1	$17, GDB_FR_FPR17(sp)
-		LDC1	$16, GDB_FR_FPR16(sp)
-		LDC1	$15, GDB_FR_FPR15(sp)
-		LDC1	$14, GDB_FR_FPR14(sp)
-		LDC1	$13, GDB_FR_FPR13(sp)
-		LDC1	$12, GDB_FR_FPR12(sp)
-		LDC1	$11, GDB_FR_FPR11(sp)
-		LDC1	$10, GDB_FR_FPR10(sp)
-		LDC1	$9, GDB_FR_FPR9(sp)
-		LDC1	$8, GDB_FR_FPR8(sp)
-		LDC1	$7, GDB_FR_FPR7(sp)
-		LDC1	$6, GDB_FR_FPR6(sp)
-		LDC1	$5, GDB_FR_FPR5(sp)
-		LDC1	$4, GDB_FR_FPR4(sp)
-		LDC1	$3, GDB_FR_FPR3(sp)
-		LDC1	$2, GDB_FR_FPR2(sp)
-		LDC1	$1, GDB_FR_FPR1(sp)
-		LDC1	$0, GDB_FR_FPR0(sp)
-
-/*
- * Now the CP0 and integer registers
- */
-
-3:
-#ifdef CONFIG_MIPS_MT_SMTC
-		/* Read-modify write of Status must be atomic */
-		mfc0	t2, CP0_TCSTATUS
-		ori	t1, t2, TCSTATUS_IXMT
-		mtc0	t1, CP0_TCSTATUS
-		andi	t2, t2, TCSTATUS_IXMT
-		_ehb
-		DMT	9				# dmt	t1
-		jal	mips_ihb
-		nop
-#endif /* CONFIG_MIPS_MT_SMTC */
-		mfc0	t0, CP0_STATUS
-		ori	t0, 0x1f
-		xori	t0, 0x1f
-		mtc0	t0, CP0_STATUS
-#ifdef CONFIG_MIPS_MT_SMTC
-        	andi    t1, t1, VPECONTROL_TE
-        	beqz    t1, 9f
-		nop
-        	EMT					# emt
-9:
-		mfc0	t1, CP0_TCSTATUS
-		xori	t1, t1, TCSTATUS_IXMT
-		or	t1, t1, t2
-		mtc0	t1, CP0_TCSTATUS
-		_ehb
-#endif /* CONFIG_MIPS_MT_SMTC */
-		LONG_L	v0, GDB_FR_STATUS(sp)
-		LONG_L	v1, GDB_FR_EPC(sp)
-		mtc0	v0, CP0_STATUS
-		DMTC0	v1, CP0_EPC
-		LONG_L	v0, GDB_FR_HI(sp)
-		LONG_L	v1, GDB_FR_LO(sp)
-		mthi	v0
-		mtlo	v1
-		LONG_L	$31, GDB_FR_REG31(sp)
-		LONG_L	$30, GDB_FR_REG30(sp)
-		LONG_L	$28, GDB_FR_REG28(sp)
-		LONG_L	$27, GDB_FR_REG27(sp)
-		LONG_L	$26, GDB_FR_REG26(sp)
-		LONG_L	$25, GDB_FR_REG25(sp)
-		LONG_L	$24, GDB_FR_REG24(sp)
-		LONG_L	$23, GDB_FR_REG23(sp)
-		LONG_L	$22, GDB_FR_REG22(sp)
-		LONG_L	$21, GDB_FR_REG21(sp)
-		LONG_L	$20, GDB_FR_REG20(sp)
-		LONG_L	$19, GDB_FR_REG19(sp)
-		LONG_L	$18, GDB_FR_REG18(sp)
-		LONG_L	$17, GDB_FR_REG17(sp)
-		LONG_L	$16, GDB_FR_REG16(sp)
-		LONG_L	$15, GDB_FR_REG15(sp)
-		LONG_L	$14, GDB_FR_REG14(sp)
-		LONG_L	$13, GDB_FR_REG13(sp)
-		LONG_L	$12, GDB_FR_REG12(sp)
-		LONG_L	$11, GDB_FR_REG11(sp)
-		LONG_L	$10, GDB_FR_REG10(sp)
-		LONG_L	$9, GDB_FR_REG9(sp)
-		LONG_L	$8, GDB_FR_REG8(sp)
-		LONG_L	$7, GDB_FR_REG7(sp)
-		LONG_L	$6, GDB_FR_REG6(sp)
-		LONG_L	$5, GDB_FR_REG5(sp)
-		LONG_L	$4, GDB_FR_REG4(sp)
-		LONG_L	$3, GDB_FR_REG3(sp)
-		LONG_L	$2, GDB_FR_REG2(sp)
-		LONG_L	$1, GDB_FR_REG1(sp)
-#if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
-		LONG_L	k0, GDB_FR_EPC(sp)
-		LONG_L	$29, GDB_FR_REG29(sp)		/* Deallocate stack */
-		jr	k0
-		rfe
-#else
-		LONG_L	sp, GDB_FR_REG29(sp)		/* Deallocate stack */
-
-		.set	mips3
-		eret
-		.set	mips0
-#endif
-		.set	at
-		.set	reorder
-		END(trap_low)
-
-LEAF(kgdb_read_byte)
-4:		lb	t0, (a0)
-		sb	t0, (a1)
-		li	v0, 0
-		jr	ra
-		.section __ex_table,"a"
-		PTR	4b, kgdbfault
-		.previous
-		END(kgdb_read_byte)
-
-LEAF(kgdb_write_byte)
-5:		sb	a0, (a1)
-		li	v0, 0
-		jr	ra
-		.section __ex_table,"a"
-		PTR	5b, kgdbfault
-		.previous
-		END(kgdb_write_byte)
-
-		.type	kgdbfault@function
-		.ent	kgdbfault
-
-kgdbfault:	li	v0, -EFAULT
-		jr	ra
-		.end	kgdbfault
--- a/arch/mips/mips-boards/atlas/Makefile
+++ b/arch/mips/mips-boards/atlas/Makefile
@@ -17,6 +17,5 @@
 #
 
 obj-y			:= atlas_int.o atlas_setup.o
-obj-$(CONFIG_KGDB)	+= atlas_gdb.o
 
 EXTRA_CFLAGS += -Werror
--- a/arch/mips/mips-boards/atlas/atlas_gdb.c
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * Carsten Langgaard, carstenl@mips.com
- * Copyright (C) 2000 MIPS Technologies, Inc.  All rights reserved.
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * This is the interface to the remote debugger stub.
- */
-#include <asm/io.h>
-#include <asm/mips-boards/atlas.h>
-#include <asm/mips-boards/saa9730_uart.h>
-
-#define INB(a)     inb((unsigned long)a)
-#define OUTB(x, a)  outb(x, (unsigned long)a)
-
-/*
- * This is the interface to the remote debugger stub
- * if the Philips part is used for the debug port,
- * called from the platform setup code.
- */
-void *saa9730_base = (void *)ATLAS_SAA9730_REG;
-
-static int saa9730_kgdb_active = 0;
-
-#define SAA9730_BAUDCLOCK(baud) (((ATLAS_SAA9730_BAUDCLOCK/(baud))/16)-1)
-
-int saa9730_kgdb_hook(int speed)
-{
-	int baudclock;
-	t_uart_saa9730_regmap *kgdb_uart = (t_uart_saa9730_regmap *)(saa9730_base + SAA9730_UART_REGS_ADDR);
-
-        /*
-         * Clear all interrupts
-         */
-	(void) INB(&kgdb_uart->Lsr);
-	(void) INB(&kgdb_uart->Msr);
-	(void) INB(&kgdb_uart->Thr_Rbr);
-	(void) INB(&kgdb_uart->Iir_Fcr);
-
-        /*
-         * Now, initialize the UART
-         */
-	/* 8 data bits, one stop bit, no parity */
-	OUTB(SAA9730_LCR_DATA8, &kgdb_uart->Lcr);
-
-	baudclock = SAA9730_BAUDCLOCK(speed);
-
-	OUTB((baudclock >> 16) & 0xff, &kgdb_uart->BaudDivMsb);
-	OUTB( baudclock        & 0xff, &kgdb_uart->BaudDivLsb);
-
-	/* Set RTS/DTR active */
-	OUTB(SAA9730_MCR_DTR | SAA9730_MCR_RTS, &kgdb_uart->Mcr);
-	saa9730_kgdb_active = 1;
-
-	return speed;
-}
-
-int saa9730_putDebugChar(char c)
-{
-	t_uart_saa9730_regmap *kgdb_uart = (t_uart_saa9730_regmap *)(saa9730_base + SAA9730_UART_REGS_ADDR);
-
-        if (!saa9730_kgdb_active) {     /* need to init device first */
-                return 0;
-        }
-
-        while (!(INB(&kgdb_uart->Lsr) & SAA9730_LSR_THRE))
-                ;
-	OUTB(c, &kgdb_uart->Thr_Rbr);
-
-        return 1;
-}
-
-char saa9730_getDebugChar(void)
-{
-	t_uart_saa9730_regmap *kgdb_uart = (t_uart_saa9730_regmap *)(saa9730_base + SAA9730_UART_REGS_ADDR);
-	char c;
-
-        if (!saa9730_kgdb_active) {     /* need to init device first */
-                return 0;
-        }
-        while (!(INB(&kgdb_uart->Lsr) & SAA9730_LSR_DR))
-                ;
-
-	c = INB(&kgdb_uart->Thr_Rbr);
-	return(c);
-}
--- a/arch/mips/mips-boards/atlas/atlas_setup.c
+++ b/arch/mips/mips-boards/atlas/atlas_setup.c
@@ -36,10 +36,6 @@
 
 extern void mips_reboot_setup(void);
 
-#ifdef CONFIG_KGDB
-extern void kgdb_config(void);
-#endif
-
 static void __init serial_init(void);
 
 const char *get_system_type(void)
@@ -57,9 +53,6 @@ void __init plat_mem_setup(void)
 
 	serial_init();
 
-#ifdef CONFIG_KGDB
-	kgdb_config();
-#endif
 	mips_reboot_setup();
 }
 
--- a/arch/mips/mips-boards/generic/gdb_hook.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
- * Carsten Langgaard, carstenl@mips.com
- * Copyright (C) 2000 MIPS Technologies, Inc.  All rights reserved.
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * This is the interface to the remote debugger stub.
- */
-#include <linux/types.h>
-#include <linux/serial.h>
-#include <linux/serialP.h>
-#include <linux/serial_reg.h>
-
-#include <asm/serial.h>
-#include <asm/io.h>
-
-static struct serial_state rs_table[] = {
-	SERIAL_PORT_DFNS	/* Defined in serial.h */
-};
-
-static struct async_struct kdb_port_info = {0};
-
-int (*generic_putDebugChar)(char);
-char (*generic_getDebugChar)(void);
-
-static __inline__ unsigned int serial_in(struct async_struct *info, int offset)
-{
-	return inb(info->port + offset);
-}
-
-static __inline__ void serial_out(struct async_struct *info, int offset,
-				int value)
-{
-	outb(value, info->port+offset);
-}
-
-int rs_kgdb_hook(int tty_no, int speed) {
-	int t;
-	struct serial_state *ser = &rs_table[tty_no];
-
-	kdb_port_info.state = ser;
-	kdb_port_info.magic = SERIAL_MAGIC;
-	kdb_port_info.port = ser->port;
-	kdb_port_info.flags = ser->flags;
-
-	/*
-	 * Clear all interrupts
-	 */
-	serial_in(&kdb_port_info, UART_LSR);
-	serial_in(&kdb_port_info, UART_RX);
-	serial_in(&kdb_port_info, UART_IIR);
-	serial_in(&kdb_port_info, UART_MSR);
-
-	/*
-	 * Now, initialize the UART
-	 */
-	serial_out(&kdb_port_info, UART_LCR, UART_LCR_WLEN8);	/* reset DLAB */
-	if (kdb_port_info.flags & ASYNC_FOURPORT) {
-		kdb_port_info.MCR = UART_MCR_DTR | UART_MCR_RTS;
-		t = UART_MCR_DTR | UART_MCR_OUT1;
-	} else {
-		kdb_port_info.MCR
-			= UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2;
-		t = UART_MCR_DTR | UART_MCR_RTS;
-	}
-
-	kdb_port_info.MCR = t;		/* no interrupts, please */
-	serial_out(&kdb_port_info, UART_MCR, kdb_port_info.MCR);
-
-	/*
-	 * and set the speed of the serial port
-	 */
-	if (speed == 0)
-		speed = 9600;
-
-	t = kdb_port_info.state->baud_base / speed;
-	/* set DLAB */
-	serial_out(&kdb_port_info, UART_LCR, UART_LCR_WLEN8 | UART_LCR_DLAB);
-	serial_out(&kdb_port_info, UART_DLL, t & 0xff);/* LS of divisor */
-	serial_out(&kdb_port_info, UART_DLM, t >> 8);  /* MS of divisor */
-	/* reset DLAB */
-	serial_out(&kdb_port_info, UART_LCR, UART_LCR_WLEN8);
-
-	return speed;
-}
-
-int putDebugChar(char c)
-{
-	return generic_putDebugChar(c);
-}
-
-char getDebugChar(void)
-{
-	return generic_getDebugChar();
-}
-
-int rs_putDebugChar(char c)
-{
-
-	if (!kdb_port_info.state) { 	/* need to init device first */
-		return 0;
-	}
-
-	while ((serial_in(&kdb_port_info, UART_LSR) & UART_LSR_THRE) == 0)
-		;
-
-	serial_out(&kdb_port_info, UART_TX, c);
-
-	return 1;
-}
-
-char rs_getDebugChar(void)
-{
-	if (!kdb_port_info.state) { 	/* need to init device first */
-		return 0;
-	}
-
-	while (!(serial_in(&kdb_port_info, UART_LSR) & 1))
-		;
-
-	return serial_in(&kdb_port_info, UART_RX);
-}
--- a/arch/mips/pci/fixup-atlas.c
+++ b/arch/mips/pci/fixup-atlas.c
@@ -68,24 +68,3 @@ int pcibios_plat_dev_init(struct pci_dev
 {
 	return 0;
 }
-
-#ifdef CONFIG_KGDB
-/*
- * The PCI scan may have moved the saa9730 I/O address, so reread
- * the address here.
- * This does mean that it's not possible to debug the PCI bus configuration
- * code, but it is better than nothing...
- */
-
-static void atlas_saa9730_base_fixup(struct pci_dev *pdev)
-{
-	extern void *saa9730_base;
-	if (pdev->bus == 0 && PCI_SLOT(pdev->devfn) == 19)
-		(void) pci_read_config_dword(pdev, 0x14, (u32 *)&saa9730_base);
-	printk("saa9730_base = %x\n", saa9730_base);
-}
-
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PHILIPS, PCI_DEVICE_ID_PHILIPS_SAA9730,
-	 atlas_saa9730_base_fixup);
-
-#endif
--- a/arch/mips/philips/pnx8550/common/Makefile
+++ b/arch/mips/philips/pnx8550/common/Makefile
@@ -24,6 +24,5 @@
 
 obj-y := setup.o prom.o int.o reset.o time.o proc.o platform.o
 obj-$(CONFIG_PCI) += pci.o
-obj-$(CONFIG_KGDB) += gdb_hook.o
 
 EXTRA_CFLAGS += -Werror
--- a/arch/mips/philips/pnx8550/common/gdb_hook.c
+++ /dev/null
@@ -1,109 +0,0 @@
-/*
- * Carsten Langgaard, carstenl@mips.com
- * Copyright (C) 2000 MIPS Technologies, Inc.  All rights reserved.
- *
- * ########################################################################
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * ########################################################################
- *
- * This is the interface to the remote debugger stub.
- *
- */
-#include <linux/types.h>
-#include <linux/serial.h>
-#include <linux/serialP.h>
-#include <linux/serial_reg.h>
-#include <linux/serial_ip3106.h>
-
-#include <asm/serial.h>
-#include <asm/io.h>
-
-#include <uart.h>
-
-static struct serial_state rs_table[IP3106_NR_PORTS] = {
-};
-static struct async_struct kdb_port_info = {0};
-
-void rs_kgdb_hook(int tty_no)
-{
-	struct serial_state *ser = &rs_table[tty_no];
-
-	kdb_port_info.state = ser;
-	kdb_port_info.magic = SERIAL_MAGIC;
-	kdb_port_info.port  = tty_no;
-	kdb_port_info.flags = ser->flags;
-
-	/*
-	 * Clear all interrupts
-	 */
-	/* Clear all the transmitter FIFO counters (pointer and status) */
-	ip3106_lcr(UART_BASE, tty_no) |= IP3106_UART_LCR_TX_RST;
-	/* Clear all the receiver FIFO counters (pointer and status) */
-	ip3106_lcr(UART_BASE, tty_no) |= IP3106_UART_LCR_RX_RST;
-	/* Clear all interrupts */
-	ip3106_iclr(UART_BASE, tty_no) = IP3106_UART_INT_ALLRX |
-		IP3106_UART_INT_ALLTX;
-
-	/*
-	 * Now, initialize the UART
-	 */
-	ip3106_lcr(UART_BASE, tty_no) = IP3106_UART_LCR_8BIT;
-	ip3106_baud(UART_BASE, tty_no) = 5; // 38400 Baud
-}
-
-int putDebugChar(char c)
-{
-	/* Wait until FIFO not full */
-	while (((ip3106_fifo(UART_BASE, kdb_port_info.port) & IP3106_UART_FIFO_TXFIFO) >> 16) >= 16)
-		;
-	/* Send one char */
-	ip3106_fifo(UART_BASE, kdb_port_info.port) = c;
-
-	return 1;
-}
-
-char getDebugChar(void)
-{
-	char ch;
-
-	/* Wait until there is a char in the FIFO */
-	while (!((ip3106_fifo(UART_BASE, kdb_port_info.port) &
-					IP3106_UART_FIFO_RXFIFO) >> 8))
-		;
-	/* Read one char */
-	ch = ip3106_fifo(UART_BASE, kdb_port_info.port) &
-		IP3106_UART_FIFO_RBRTHR;
-	/* Advance the RX FIFO read pointer */
-	ip3106_lcr(UART_BASE, kdb_port_info.port) |= IP3106_UART_LCR_RX_NEXT;
-	return (ch);
-}
-
-void rs_disable_debug_interrupts(void)
-{
-	ip3106_ien(UART_BASE, kdb_port_info.port) = 0; /* Disable all interrupts */
-}
-
-void rs_enable_debug_interrupts(void)
-{
-	/* Clear all the transmitter FIFO counters (pointer and status) */
-	ip3106_lcr(UART_BASE, kdb_port_info.port) |= IP3106_UART_LCR_TX_RST;
-	/* Clear all the receiver FIFO counters (pointer and status) */
-	ip3106_lcr(UART_BASE, kdb_port_info.port) |= IP3106_UART_LCR_RX_RST;
-	/* Clear all interrupts */
-	ip3106_iclr(UART_BASE, kdb_port_info.port) = IP3106_UART_INT_ALLRX |
-		IP3106_UART_INT_ALLTX;
-	ip3106_ien(UART_BASE, kdb_port_info.port)  = IP3106_UART_INT_ALLRX; /* Enable RX interrupts */
-}
--- a/arch/mips/philips/pnx8550/common/setup.c
+++ b/arch/mips/philips/pnx8550/common/setup.c
@@ -142,16 +142,5 @@ void __init plat_mem_setup(void)
 		ip3106_baud(UART_BASE, pnx8550_console_port) = 5;
 	}
 
-#ifdef CONFIG_KGDB
-	argptr = prom_getcmdline();
-	if ((argptr = strstr(argptr, "kgdb=ttyS")) != NULL) {
-		int line;
-		argptr += strlen("kgdb=ttyS");
-		line = *argptr == '0' ? 0 : 1;
-		rs_kgdb_hook(line);
-		pr_info("KGDB: Using ttyS%i for session, "
-		        "please connect your debugger\n", line ? 1 : 0);
-	}
-#endif
 	return;
 }
--- a/arch/mips/pmc-sierra/yosemite/Makefile
+++ b/arch/mips/pmc-sierra/yosemite/Makefile
@@ -4,7 +4,6 @@
 
 obj-y    += irq.o prom.o py-console.o setup.o
 
-obj-$(CONFIG_KGDB)		+= dbg_io.o
 obj-$(CONFIG_SMP)		+= smp.o
 
 EXTRA_CFLAGS += -Werror
--- a/arch/mips/pmc-sierra/yosemite/dbg_io.c
+++ /dev/null
@@ -1,180 +0,0 @@
-/*
- * Copyright 2003 PMC-Sierra
- * Author: Manish Lachwani (lachwani@pmc-sierra.com)
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-/*
- * Support for KGDB for the Yosemite board. We make use of single serial
- * port to be used for KGDB as well as console. The second serial port
- * seems to be having a problem. Single IRQ is allocated for both the
- * ports. Hence, the interrupt routing code needs to figure out whether
- * the interrupt came from channel A or B.
- */
-
-#include <asm/serial.h>
-
-/*
- * Baud rate, Parity, Data and Stop bit settings for the
- * serial port on the Yosemite. Note that the Early printk
- * patch has been added. So, we should be all set to go
- */
-#define	YOSEMITE_BAUD_2400	2400
-#define	YOSEMITE_BAUD_4800	4800
-#define	YOSEMITE_BAUD_9600	9600
-#define	YOSEMITE_BAUD_19200	19200
-#define	YOSEMITE_BAUD_38400	38400
-#define	YOSEMITE_BAUD_57600	57600
-#define	YOSEMITE_BAUD_115200	115200
-
-#define	YOSEMITE_PARITY_NONE	0
-#define	YOSEMITE_PARITY_ODD	0x08
-#define	YOSEMITE_PARITY_EVEN	0x18
-#define	YOSEMITE_PARITY_MARK	0x28
-#define	YOSEMITE_PARITY_SPACE	0x38
-
-#define	YOSEMITE_DATA_5BIT	0x0
-#define	YOSEMITE_DATA_6BIT	0x1
-#define	YOSEMITE_DATA_7BIT	0x2
-#define	YOSEMITE_DATA_8BIT	0x3
-
-#define	YOSEMITE_STOP_1BIT	0x0
-#define	YOSEMITE_STOP_2BIT	0x4
-
-/* This is crucial */
-#define	SERIAL_REG_OFS		0x1
-
-#define	SERIAL_RCV_BUFFER	0x0
-#define	SERIAL_TRANS_HOLD	0x0
-#define	SERIAL_SEND_BUFFER	0x0
-#define	SERIAL_INTR_ENABLE	(1 * SERIAL_REG_OFS)
-#define	SERIAL_INTR_ID		(2 * SERIAL_REG_OFS)
-#define	SERIAL_DATA_FORMAT	(3 * SERIAL_REG_OFS)
-#define	SERIAL_LINE_CONTROL	(3 * SERIAL_REG_OFS)
-#define	SERIAL_MODEM_CONTROL	(4 * SERIAL_REG_OFS)
-#define	SERIAL_RS232_OUTPUT	(4 * SERIAL_REG_OFS)
-#define	SERIAL_LINE_STATUS	(5 * SERIAL_REG_OFS)
-#define	SERIAL_MODEM_STATUS	(6 * SERIAL_REG_OFS)
-#define	SERIAL_RS232_INPUT	(6 * SERIAL_REG_OFS)
-#define	SERIAL_SCRATCH_PAD	(7 * SERIAL_REG_OFS)
-
-#define	SERIAL_DIVISOR_LSB	(0 * SERIAL_REG_OFS)
-#define	SERIAL_DIVISOR_MSB	(1 * SERIAL_REG_OFS)
-
-/*
- * Functions to READ and WRITE to serial port 0
- */
-#define	SERIAL_READ(ofs)		(*((volatile unsigned char*)	\
-					(TITAN_SERIAL_BASE + ofs)))
-
-#define	SERIAL_WRITE(ofs, val)		((*((volatile unsigned char*)	\
-					(TITAN_SERIAL_BASE + ofs))) = val)
-
-/*
- * Functions to READ and WRITE to serial port 1
- */
-#define	SERIAL_READ_1(ofs)		(*((volatile unsigned char*)	\
-					(TITAN_SERIAL_BASE_1 + ofs)))
-
-#define	SERIAL_WRITE_1(ofs, val)	((*((volatile unsigned char*)	\
-					(TITAN_SERIAL_BASE_1 + ofs))) = val)
-
-/*
- * Second serial port initialization
- */
-void init_second_port(void)
-{
-	/* Disable Interrupts */
-	SERIAL_WRITE_1(SERIAL_LINE_CONTROL, 0x0);
-	SERIAL_WRITE_1(SERIAL_INTR_ENABLE, 0x0);
-
-	{
-		unsigned int divisor;
-
-		SERIAL_WRITE_1(SERIAL_LINE_CONTROL, 0x80);
-		divisor = TITAN_SERIAL_BASE_BAUD / YOSEMITE_BAUD_115200;
-		SERIAL_WRITE_1(SERIAL_DIVISOR_LSB, divisor & 0xff);
-
-		SERIAL_WRITE_1(SERIAL_DIVISOR_MSB,
-			       (divisor & 0xff00) >> 8);
-		SERIAL_WRITE_1(SERIAL_LINE_CONTROL, 0x0);
-	}
-
-	SERIAL_WRITE_1(SERIAL_DATA_FORMAT, YOSEMITE_DATA_8BIT |
-		       YOSEMITE_PARITY_NONE | YOSEMITE_STOP_1BIT);
-
-	/* Enable Interrupts */
-	SERIAL_WRITE_1(SERIAL_INTR_ENABLE, 0xf);
-}
-
-/* Initialize the serial port for KGDB debugging */
-void debugInit(unsigned int baud, unsigned char data, unsigned char parity,
-	       unsigned char stop)
-{
-	/* Disable Interrupts */
-	SERIAL_WRITE(SERIAL_LINE_CONTROL, 0x0);
-	SERIAL_WRITE(SERIAL_INTR_ENABLE, 0x0);
-
-	{
-		unsigned int divisor;
-
-		SERIAL_WRITE(SERIAL_LINE_CONTROL, 0x80);
-
-		divisor = TITAN_SERIAL_BASE_BAUD / baud;
-		SERIAL_WRITE(SERIAL_DIVISOR_LSB, divisor & 0xff);
-
-		SERIAL_WRITE(SERIAL_DIVISOR_MSB, (divisor & 0xff00) >> 8);
-		SERIAL_WRITE(SERIAL_LINE_CONTROL, 0x0);
-	}
-
-	SERIAL_WRITE(SERIAL_DATA_FORMAT, data | parity | stop);
-}
-
-static int remoteDebugInitialized = 0;
-
-unsigned char getDebugChar(void)
-{
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(YOSEMITE_BAUD_115200,
-			  YOSEMITE_DATA_8BIT,
-			  YOSEMITE_PARITY_NONE, YOSEMITE_STOP_1BIT);
-	}
-
-	while ((SERIAL_READ(SERIAL_LINE_STATUS) & 0x1) == 0);
-	return SERIAL_READ(SERIAL_RCV_BUFFER);
-}
-
-int putDebugChar(unsigned char byte)
-{
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(YOSEMITE_BAUD_115200,
-			  YOSEMITE_DATA_8BIT,
-			  YOSEMITE_PARITY_NONE, YOSEMITE_STOP_1BIT);
-	}
-
-	while ((SERIAL_READ(SERIAL_LINE_STATUS) & 0x20) == 0);
-	SERIAL_WRITE(SERIAL_SEND_BUFFER, byte);
-
-	return 1;
-}
--- a/arch/mips/pmc-sierra/yosemite/irq.c
+++ b/arch/mips/pmc-sierra/yosemite/irq.c
@@ -141,10 +141,6 @@ asmlinkage void plat_irq_dispatch(void)
 	}
 }
 
-#ifdef CONFIG_KGDB
-extern void init_second_port(void);
-#endif
-
 /*
  * Initialize the next level interrupt handler
  */
@@ -156,11 +152,6 @@ void __init arch_init_irq(void)
 	rm7k_cpu_irq_init();
 	rm9k_cpu_irq_init();
 
-#ifdef CONFIG_KGDB
-	/* At this point, initialize the second serial port */
-	init_second_port();
-#endif
-
 #ifdef CONFIG_GDB_CONSOLE
 	register_gdb_console();
 #endif
--- a/arch/mips/sgi-ip22/ip22-setup.c
+++ b/arch/mips/sgi-ip22/ip22-setup.c
@@ -100,30 +100,6 @@ void __init plat_mem_setup(void)
 		add_preferred_console("arc", 0, NULL);
 	}
 
-#ifdef CONFIG_KGDB
-	{
-	char *kgdb_ttyd = prom_getcmdline();
-
-	if ((kgdb_ttyd = strstr(kgdb_ttyd, "kgdb=ttyd")) != NULL) {
-		int line;
-		kgdb_ttyd += strlen("kgdb=ttyd");
-		if (*kgdb_ttyd != '1' && *kgdb_ttyd != '2')
-			printk(KERN_INFO "KGDB: Uknown serial line /dev/ttyd%c"
-			       ", falling back to /dev/ttyd1\n", *kgdb_ttyd);
-		line = *kgdb_ttyd == '2' ? 0 : 1;
-		printk(KERN_INFO "KGDB: Using serial line /dev/ttyd%d for "
-		       "session\n", line ? 1 : 2);
-		rs_kgdb_hook(line);
-
-		printk(KERN_INFO "KGDB: Using serial line /dev/ttyd%d for "
-		       "session, please connect your debugger\n", line ? 1:2);
-
-		kgdb_enabled = 1;
-		/* Breakpoints and stuff are in sgi_irq_setup() */
-	}
-	}
-#endif
-
 #if defined(CONFIG_VT) && defined(CONFIG_SGI_NEWPORT_CONSOLE)
 	{
 		ULONG *gfxinfo;
--- a/arch/mips/sgi-ip27/Makefile
+++ b/arch/mips/sgi-ip27/Makefile
@@ -7,7 +7,6 @@ obj-y	:= ip27-berr.o ip27-irq.o ip27-ini
 	   ip27-xtalk.o
 
 obj-$(CONFIG_EARLY_PRINTK)	+= ip27-console.o
-obj-$(CONFIG_KGDB)		+= ip27-dbgio.o
 obj-$(CONFIG_SMP)		+= ip27-smp.o
 
 EXTRA_CFLAGS += -Werror
--- a/arch/mips/sgi-ip27/ip27-dbgio.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Copyright 2004 Ralf Baechle <ralf@linux-mips.org>
- */
-#include <asm/sn/addrs.h>
-#include <asm/sn/sn0/hub.h>
-#include <asm/sn/klconfig.h>
-#include <asm/sn/ioc3.h>
-#include <asm/sn/sn_private.h>
-
-#include <linux/serial.h>
-#include <linux/serial_core.h>
-#include <linux/serial_reg.h>
-
-#define IOC3_CLK        (22000000 / 3)
-#define IOC3_FLAGS      (0)
-
-static inline struct ioc3_uartregs *console_uart(void)
-{
-	struct ioc3 *ioc3;
-
-	ioc3 = (struct ioc3 *)KL_CONFIG_CH_CONS_INFO(get_nasid())->memory_base;
-
-	return &ioc3->sregs.uarta;
-}
-
-unsigned char getDebugChar(void)
-{
-	struct ioc3_uartregs *uart = console_uart();
-
-	while ((uart->iu_lsr & UART_LSR_DR) == 0);
-	return uart->iu_rbr;
-}
-
-void putDebugChar(unsigned char c)
-{
-	struct ioc3_uartregs *uart = console_uart();
-
-	while ((uart->iu_lsr & UART_LSR_THRE) == 0);
-	uart->iu_thr = c;
-}
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -57,30 +57,6 @@ static void bcm1480_set_affinity(unsigne
 extern unsigned long ht_eoi_space;
 #endif
 
-#ifdef CONFIG_KGDB
-#include <asm/gdb-stub.h>
-extern void breakpoint(void);
-static int kgdb_irq;
-#ifdef CONFIG_GDB_CONSOLE
-extern void register_gdb_console(void);
-#endif
-
-/* kgdb is on when configured.  Pass "nokgdb" kernel arg to turn it off */
-static int kgdb_flag = 1;
-static int __init nokgdb(char *str)
-{
-	kgdb_flag = 0;
-	return 1;
-}
-__setup("nokgdb", nokgdb);
-
-/* Default to UART1 */
-int kgdb_port = 1;
-#ifdef CONFIG_SERIAL_SB1250_DUART
-extern char sb1250_duart_present[];
-#endif
-#endif
-
 static struct irq_chip bcm1480_irq_type = {
 	.name = "BCM1480-IMR",
 	.ack = ack_bcm1480_irq,
@@ -394,62 +370,10 @@ void __init arch_init_irq(void)
 	 * does its own management of IP7.
 	 */
 
-#ifdef CONFIG_KGDB
-	imask |= STATUSF_IP6;
-#endif
 	/* Enable necessary IPs, disable the rest */
 	change_c0_status(ST0_IM, imask);
-
-#ifdef CONFIG_KGDB
-	if (kgdb_flag) {
-		kgdb_irq = K_BCM1480_INT_UART_0 + kgdb_port;
-
-#ifdef CONFIG_SERIAL_SB1250_DUART
-		sb1250_duart_present[kgdb_port] = 0;
-#endif
-		/* Setup uart 1 settings, mapper */
-		/* QQQ FIXME */
-		__raw_writeq(M_DUART_IMR_BRK, IO_SPACE_BASE + A_DUART_IMRREG(kgdb_port));
-
-		bcm1480_steal_irq(kgdb_irq);
-		__raw_writeq(IMR_IP6_VAL,
-			     IO_SPACE_BASE + A_BCM1480_IMR_REGISTER(0, R_BCM1480_IMR_INTERRUPT_MAP_BASE_H) +
-			     (kgdb_irq<<3));
-		bcm1480_unmask_irq(0, kgdb_irq);
-
-#ifdef CONFIG_GDB_CONSOLE
-		register_gdb_console();
-#endif
-		printk("Waiting for GDB on UART port %d\n", kgdb_port);
-		set_debug_traps();
-		breakpoint();
-	}
-#endif
-}
-
-#ifdef CONFIG_KGDB
-
-#include <linux/delay.h>
-
-#define duart_out(reg, val)     csr_out32(val, IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-#define duart_in(reg)           csr_in32(IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-
-static void bcm1480_kgdb_interrupt(void)
-{
-	/*
-	 * Clear break-change status (allow some time for the remote
-	 * host to stop the break, since we would see another
-	 * interrupt on the end-of-break too)
-	 */
-	kstat.irqs[smp_processor_id()][kgdb_irq]++;
-	mdelay(500);
-	duart_out(R_DUART_CMD, V_DUART_MISC_CMD_RESET_BREAK_INT |
-				M_DUART_RX_EN | M_DUART_TX_EN);
-	set_async_breakpoint(&get_irq_regs()->cp0_epc);
 }
 
-#endif 	/* CONFIG_KGDB */
-
 extern void bcm1480_mailbox_interrupt(void);
 
 asmlinkage void plat_irq_dispatch(void)
@@ -485,11 +409,6 @@ asmlinkage void plat_irq_dispatch(void)
 		bcm1480_mailbox_interrupt();
 #endif
 
-#ifdef CONFIG_KGDB
-	else if (pending & CAUSEF_IP6)
-		bcm1480_kgdb_interrupt();		/* KGDB (uart 1) */
-#endif
-
 	else if (pending & CAUSEF_IP2) {
 		unsigned long long mask_h, mask_l;
 		unsigned long base;
--- /dev/null
+++ b/drivers/serial/serial_txx9_kgdb.c
@@ -0,0 +1,152 @@
+/*
+ * drivers/serial/serial_txx9_kgdb.c
+ *
+ * kgdb interface for gdb
+ *
+ * Author: MontaVista Software, Inc.
+ *         source@mvista.com
+ *
+ * Copyright (C) 2005-2006 MontaVista Software Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License as published by the
+ *  Free Software Foundation; either version 2 of the License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/io.h>
+
+/* Speed of the UART. */
+static unsigned int kgdb_txx9_baud = CONFIG_KGDB_BAUDRATE;
+
+#define TXX9_NPORT 4		/* TX4939 has 4 UARTs, others only have 2 */
+
+static struct uart_port  kgdb_txx9_ports[TXX9_NPORT];
+static struct uart_port *kgdb_port;
+
+/* TXX9 Serial Registers */
+#define TXX9_SILCR	0x00
+#define TXX9_SIDISR	0x08
+#define TXX9_SISCISR	0x0c
+#define TXX9_SIFCR	0x10
+#define TXX9_SIFLCR	0x14
+#define TXX9_SIBGR	0x18
+#define TXX9_SITFIFO	0x1c
+#define TXX9_SIRFIFO	0x20
+
+/* SILCR : Line Control */
+#define TXX9_SILCR_SCS_IMCLK_BG	0x00000020
+#define TXX9_SILCR_SCS_SCLK_BG	0x00000060
+#define TXX9_SILCR_USBL_1BIT	0x00000000
+#define TXX9_SILCR_UMODE_8BIT	0x00000000
+
+/* SIDISR : DMA/Int. Status */
+#define TXX9_SIDISR_RFDN_MASK	0x0000001f
+
+/* SISCISR : Status Change Int. Status */
+#define TXX9_SISCISR_TRDY	0x00000004
+
+/* SIFCR : FIFO Control */
+#define TXX9_SIFCR_SWRST	0x00008000
+
+/* SIBGR : Baud Rate Control */
+#define TXX9_SIBGR_BCLK_T0	0x00000000
+#define TXX9_SIBGR_BCLK_T2	0x00000100
+#define TXX9_SIBGR_BCLK_T4	0x00000200
+#define TXX9_SIBGR_BCLK_T6	0x00000300
+
+static inline unsigned int sio_in(struct uart_port *port, int offset)
+{
+	return *(volatile u32 *)(port->membase + offset);
+}
+
+static inline void sio_out(struct uart_port *port, int offset,
+	unsigned int value)
+{
+	*(volatile u32 *)(port->membase + offset) = value;
+}
+
+void __init txx9_kgdb_add_port(int n, struct uart_port *port)
+{
+	memcpy(&kgdb_txx9_ports[n], port, sizeof(struct uart_port));
+}
+
+static int txx9_kgdb_init(void)
+{
+	unsigned int quot, sibgr;
+
+	kgdb_port = &kgdb_txx9_ports[CONFIG_KGDB_PORT_NUM];
+
+	if (kgdb_port->iotype != UPIO_MEM &&
+	    kgdb_port->iotype != UPIO_MEM32)
+		return -1;
+
+	/* Reset the UART. */
+	sio_out(kgdb_port, TXX9_SIFCR, TXX9_SIFCR_SWRST);
+#ifdef CONFIG_CPU_TX49XX
+	/*
+	 * TX4925 BUG WORKAROUND.  Accessing SIOC register
+	 * immediately after soft reset causes bus error.
+	 */
+	iob();
+	udelay(1);
+#endif
+	/* Wait until reset is complete. */
+	while (sio_in(kgdb_port, TXX9_SIFCR) & TXX9_SIFCR_SWRST);
+
+	/* Select the frame format and input clock. */
+	sio_out(kgdb_port, TXX9_SILCR,
+		TXX9_SILCR_UMODE_8BIT | TXX9_SILCR_USBL_1BIT |
+		((kgdb_port->flags & UPF_MAGIC_MULTIPLIER) ?
+		TXX9_SILCR_SCS_SCLK_BG : TXX9_SILCR_SCS_IMCLK_BG));
+
+	/* Select the input clock prescaler that fits the baud rate. */
+	quot = (kgdb_port->uartclk + 8 * kgdb_txx9_baud) /
+		(16 * kgdb_txx9_baud);
+	if (quot < (256 << 1))
+		sibgr = (quot >> 1) | TXX9_SIBGR_BCLK_T0;
+	else if (quot < ( 256 << 3))
+		sibgr = (quot >> 3) | TXX9_SIBGR_BCLK_T2;
+	else if (quot < ( 256 << 5))
+		sibgr = (quot >> 5) | TXX9_SIBGR_BCLK_T4;
+	else if (quot < ( 256 << 7))
+		sibgr = (quot >> 7) | TXX9_SIBGR_BCLK_T6;
+	else
+		sibgr = 0xff | TXX9_SIBGR_BCLK_T6;
+
+	sio_out(kgdb_port, TXX9_SIBGR, sibgr);
+
+	/* Enable receiver and transmitter. */
+	sio_out(kgdb_port, TXX9_SIFLCR, 0);
+
+	return 0;
+}
+
+static void txx9_kgdb_late_init(void)
+{
+	request_mem_region(kgdb_port->mapbase, 0x40, "serial_txx9(debug)");
+}
+
+static int txx9_kgdb_read(void)
+{
+	while (!(sio_in(kgdb_port, TXX9_SIDISR) & TXX9_SIDISR_RFDN_MASK));
+
+	return sio_in(kgdb_port, TXX9_SIRFIFO);
+}
+
+static void txx9_kgdb_write(u8 ch)
+{
+	while (!(sio_in(kgdb_port, TXX9_SISCISR) & TXX9_SISCISR_TRDY));
+
+	sio_out(kgdb_port, TXX9_SITFIFO, ch);
+}
+
+struct kgdb_io kgdb_io_ops = {
+	.read_char	= txx9_kgdb_read,
+	.write_char	= txx9_kgdb_write,
+	.init		= txx9_kgdb_init,
+	.late_init	= txx9_kgdb_late_init
+};
--- a/include/asm-mips/asmmacro-32.h
+++ b/include/asm-mips/asmmacro-32.h
@@ -11,6 +11,28 @@
 #include <asm/regdef.h>
 #include <asm/fpregdef.h>
 #include <asm/mipsregs.h>
+#include <asm/gdb-stub.h>
+
+	.macro	fpu_save_double_kgdb stack status tmp1 = t0
+	cfc1	\tmp1,  fcr31
+	sdc1	$f0, GDB_FR_FPR0(\stack)
+	sdc1	$f2, GDB_FR_FPR2(\stack)
+	sdc1	$f4, GDB_FR_FPR4(\stack)
+	sdc1	$f6, GDB_FR_FPR6(\stack)
+	sdc1	$f8, GDB_FR_FPR8(\stack)
+	sdc1	$f10, GDB_FR_FPR10(\stack)
+	sdc1	$f12, GDB_FR_FPR12(\stack)
+	sdc1	$f14, GDB_FR_FPR14(\stack)
+	sdc1	$f16, GDB_FR_FPR16(\stack)
+	sdc1	$f18, GDB_FR_FPR18(\stack)
+	sdc1	$f20, GDB_FR_FPR20(\stack)
+	sdc1	$f22, GDB_FR_FPR22(\stack)
+	sdc1	$f24, GDB_FR_FPR24(\stack)
+	sdc1	$f26, GDB_FR_FPR26(\stack)
+	sdc1	$f28, GDB_FR_FPR28(\stack)
+	sdc1	$f30, GDB_FR_FPR30(\stack)
+	sw	\tmp1, GDB_FR_FSR(\stack)
+	.endm
 
 	.macro	fpu_save_double thread status tmp1=t0
 	cfc1	\tmp1,  fcr31
@@ -91,6 +113,27 @@
 	ctc1	\tmp, fcr31
 	.endm
 
+	.macro	fpu_restore_double_kgdb stack status tmp = t0
+	lw	\tmp, GDB_FR_FSR(\stack)
+	ldc1	$f0,  GDB_FR_FPR0(\stack)
+	ldc1	$f2,  GDB_FR_FPR2(\stack)
+	ldc1	$f4,  GDB_FR_FPR4(\stack)
+	ldc1	$f6,  GDB_FR_FPR6(\stack)
+	ldc1	$f8,  GDB_FR_FPR8(\stack)
+	ldc1	$f10, GDB_FR_FPR10(\stack)
+	ldc1	$f12, GDB_FR_FPR12(\stack)
+	ldc1	$f14, GDB_FR_FPR14(\stack)
+	ldc1	$f16, GDB_FR_FPR16(\stack)
+	ldc1	$f18, GDB_FR_FPR18(\stack)
+	ldc1	$f20, GDB_FR_FPR20(\stack)
+	ldc1	$f22, GDB_FR_FPR22(\stack)
+	ldc1	$f24, GDB_FR_FPR24(\stack)
+	ldc1	$f26, GDB_FR_FPR26(\stack)
+	ldc1	$f28, GDB_FR_FPR28(\stack)
+	ldc1	$f30, GDB_FR_FPR30(\stack)
+	ctc1	\tmp, fcr31
+	.endm
+
 	.macro	fpu_restore_single thread tmp=t0
 	lw	\tmp, THREAD_FCR31(\thread)
 	lwc1	$f0,  THREAD_FPR0(\thread)
--- a/include/asm-mips/asmmacro-64.h
+++ b/include/asm-mips/asmmacro-64.h
@@ -12,6 +12,7 @@
 #include <asm/regdef.h>
 #include <asm/fpregdef.h>
 #include <asm/mipsregs.h>
+#include <asm/gdb-stub.h>
 
 	.macro	fpu_save_16even thread tmp=t0
 	cfc1	\tmp, fcr31
@@ -53,6 +54,46 @@
 	sdc1	$f31, THREAD_FPR31(\thread)
 	.endm
 
+	.macro	fpu_save_16odd_kgdb stack
+	sdc1	$f1, GDB_FR_FPR1(\stack)
+	sdc1	$f3, GDB_FR_FPR3(\stack)
+	sdc1	$f5, GDB_FR_FPR5(\stack)
+	sdc1	$f7, GDB_FR_FPR7(\stack)
+	sdc1	$f9, GDB_FR_FPR9(\stack)
+	sdc1	$f11, GDB_FR_FPR11(\stack)
+	sdc1	$f13, GDB_FR_FPR13(\stack)
+	sdc1	$f15, GDB_FR_FPR15(\stack)
+	sdc1	$f17, GDB_FR_FPR17(\stack)
+	sdc1	$f19, GDB_FR_FPR19(\stack)
+	sdc1	$f21, GDB_FR_FPR21(\stack)
+	sdc1	$f23, GDB_FR_FPR23(\stack)
+	sdc1	$f25, GDB_FR_FPR25(\stack)
+	sdc1	$f27, GDB_FR_FPR27(\stack)
+	sdc1	$f29, GDB_FR_FPR29(\stack)
+	sdc1	$f31, GDB_FR_FPR31(\stack)
+	.endm
+
+	.macro	fpu_save_16even_kgdb stack tmp = t0
+	cfc1	\tmp,  fcr31
+	sdc1	$f0, GDB_FR_FPR0(\stack)
+	sdc1	$f2, GDB_FR_FPR2(\stack)
+	sdc1	$f4, GDB_FR_FPR4(\stack)
+	sdc1	$f6, GDB_FR_FPR6(\stack)
+	sdc1	$f8, GDB_FR_FPR8(\stack)
+	sdc1	$f10, GDB_FR_FPR10(\stack)
+	sdc1	$f12, GDB_FR_FPR12(\stack)
+	sdc1	$f14, GDB_FR_FPR14(\stack)
+	sdc1	$f16, GDB_FR_FPR16(\stack)
+	sdc1	$f18, GDB_FR_FPR18(\stack)
+	sdc1	$f20, GDB_FR_FPR20(\stack)
+	sdc1	$f22, GDB_FR_FPR22(\stack)
+	sdc1	$f24, GDB_FR_FPR24(\stack)
+	sdc1	$f26, GDB_FR_FPR26(\stack)
+	sdc1	$f28, GDB_FR_FPR28(\stack)
+	sdc1	$f30, GDB_FR_FPR30(\stack)
+	sw	\tmp, GDB_FR_FSR(\stack)
+	.endm
+
 	.macro	fpu_save_double thread status tmp
 	sll	\tmp, \status, 5
 	bgez	\tmp, 2f
@@ -61,6 +102,15 @@
 	fpu_save_16even \thread \tmp
 	.endm
 
+	.macro	fpu_save_double_kgdb stack status tmp
+	sll	\tmp, \status, 5
+	bgez	\tmp, 2f
+	nop
+	fpu_save_16odd_kgdb \stack
+2:
+	fpu_save_16even_kgdb \stack \tmp
+	.endm
+
 	.macro	fpu_restore_16even thread tmp=t0
 	lw	\tmp, THREAD_FCR31(\thread)
 	ldc1	$f0,  THREAD_FPR0(\thread)
@@ -101,6 +151,46 @@
 	ldc1	$f31, THREAD_FPR31(\thread)
 	.endm
 
+	.macro	fpu_restore_16even_kgdb stack tmp = t0
+	lw	\tmp, GDB_FR_FSR(\stack)
+	ldc1	$f0,  GDB_FR_FPR0(\stack)
+	ldc1	$f2,  GDB_FR_FPR2(\stack)
+	ldc1	$f4,  GDB_FR_FPR4(\stack)
+	ldc1	$f6,  GDB_FR_FPR6(\stack)
+	ldc1	$f8,  GDB_FR_FPR8(\stack)
+	ldc1	$f10, GDB_FR_FPR10(\stack)
+	ldc1	$f12, GDB_FR_FPR12(\stack)
+	ldc1	$f14, GDB_FR_FPR14(\stack)
+	ldc1	$f16, GDB_FR_FPR16(\stack)
+	ldc1	$f18, GDB_FR_FPR18(\stack)
+	ldc1	$f20, GDB_FR_FPR20(\stack)
+	ldc1	$f22, GDB_FR_FPR22(\stack)
+	ldc1	$f24, GDB_FR_FPR24(\stack)
+	ldc1	$f26, GDB_FR_FPR26(\stack)
+	ldc1	$f28, GDB_FR_FPR28(\stack)
+	ldc1	$f30, GDB_FR_FPR30(\stack)
+	ctc1	\tmp, fcr31
+	.endm
+
+	.macro	fpu_restore_16odd_kgdb stack
+	ldc1	$f1,  GDB_FR_FPR1(\stack)
+	ldc1	$f3,  GDB_FR_FPR3(\stack)
+	ldc1	$f5,  GDB_FR_FPR5(\stack)
+	ldc1	$f7,  GDB_FR_FPR7(\stack)
+	ldc1	$f9,  GDB_FR_FPR9(\stack)
+	ldc1	$f11, GDB_FR_FPR11(\stack)
+	ldc1	$f13, GDB_FR_FPR13(\stack)
+	ldc1	$f15, GDB_FR_FPR15(\stack)
+	ldc1	$f17, GDB_FR_FPR17(\stack)
+	ldc1	$f19, GDB_FR_FPR19(\stack)
+	ldc1	$f21, GDB_FR_FPR21(\stack)
+	ldc1	$f23, GDB_FR_FPR23(\stack)
+	ldc1	$f25, GDB_FR_FPR25(\stack)
+	ldc1	$f27, GDB_FR_FPR27(\stack)
+	ldc1	$f29, GDB_FR_FPR29(\stack)
+	ldc1	$f31, GDB_FR_FPR31(\stack)
+	.endm
+
 	.macro	fpu_restore_double thread status tmp
 	sll	\tmp, \status, 5
 	bgez	\tmp, 1f				# 16 register mode?
@@ -109,6 +199,15 @@
 1:	fpu_restore_16even \thread \tmp
 	.endm
 
+	.macro	fpu_restore_double_kgdb stack status tmp
+	sll	\tmp, \status, 5
+	bgez	\tmp, 1f				# 16 register mode?
+	nop
+
+	fpu_restore_16odd_kgdb \stack
+1:	fpu_restore_16even_kgdb \stack \tmp
+	.endm
+
 	.macro	cpu_save_nonscratch thread
 	LONG_S	s0, THREAD_REG16(\thread)
 	LONG_S	s1, THREAD_REG17(\thread)

--------------050407090301090207030201--
