Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbZKGLMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbZKGLMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 06:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZKGLMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 06:12:12 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50383 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZKGLMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 06:12:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cz7Apdpgof3o0YraSBry+EjbYeeJgAtZOqxJQIC+XJXHL1KC6ykqr0zAF7b8kzfzoO
         kO4MuOJ/lLiJSUSqhchtQLdvfIFqnxQUjUvI91dqft7j5b5IElOh63iHzZ0FLwCkIGMn
         C0pY3lL/FPd0ERnOAUv7UM9xTOcjMj7RnjG8w=
MIME-Version: 1.0
In-Reply-To: <20091107000559.166710@gmx.net>
References: <20091106154911.29400@gmx.net> <20091106155937.11d95279@lxorguk.ukuu.org.uk> 
	<20091106165731.26800@gmx.net> <20091106182218.43940287@lxorguk.ukuu.org.uk> 
	<20091106200620.179910@gmx.net> <m3r5sbcl07.fsf@intrepid.localdomain> 
	<20091107000559.166710@gmx.net>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sat, 7 Nov 2009 12:11:55 +0100
Message-ID: <40101cc30911070311u56035911l5eb50ac4abb73acc@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Martin Schleier <drahemmaps@gmx.net>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 7, 2009 at 1:05 AM, Martin Schleier <drahemmaps@gmx.net> wrote:
> Sat, 07 Nov 2009 00:05:12 Krzystof Halasa
>> "Martin Schleier" <drahemmaps@gmx.net> writes:
>>On Fri, 6 Nov 2009 18:22:18 Alan Cox wrote:
>> > > If it wasn't riddled with 19 errors (not bad for only 133 lines),
>> > > I would have bothered to remove these irrelevant lines.
>> >
>> > Checkpatch is just formatting - its just an aide nothing more.
>> > It's not remotely useful to bother with them for stuff that is
>> > basically sanely formatted until such point as someone is actually
>> > sure the patch is worth going into the tree.
>> >
>> > the utility is called checkpatch and not checkstyle or
>> > checkformatting.
>> > And there's a good reason behind this decision, because it does
>> > more than just checking style.
>> >
>> > e.g:
>> > - correct use of some blackfin hi/lo macros.
>> > - if certain data structures are declared as const
>> >   (struct seq_operations/file_operations)
>> > - correct use of NR_CPUS is usually wrong
>> > - complains about in_atomic() outside core kernel code
>> > - warns about LINUX_VERSION_CODE, #if 0,
>> >   volatile or deprecated functions.
>> > - informs about needless kfree/usb_free_urb checks
>> > - etc...
>> >
>> > and I'm sure that future modifications will add more
>> >useful functionality _checks_ to many more _common pitfalls_
>> >areas.
>>
>> Did the patch in question contain such problems?
> the last point:
>  - etc... =>
>
> "WARNING: externs should be avoided in .c files
> #56: FILE: arch/x86/kernel/nopl_emu.c:13:
> +void do_invalid_op(struct pt_regs *regs, long error_code);" ?
> (or do you think that this is a formatting issue?!)
>
> a grep will give you a header file where it is defined:
> "arch/x86/include/asm/traps.h"
> dotraplinkage void do_invalid_op(struct pt_regs *, long);
>
> anyway, in case we get more followers here. I put your question back
> in context of the original response. Because this discussion-branch was
> not about arguing about nopl emulation, since - apparently - nothing
> was/is wrong with the code itself.
>
> Instead, we ended up here because of:
>
> Fri, 6 Nov 2009 15:59:37 Alan Cox wrote:
> "Secondly Ingo knows how to operate checkpatch and trivial style bits like
> that are irrelevant to meaningful discussion about code."
>
> And this is clearly not the case. It is the job of a Submitter
> (as described in Documentations/SubmittingPatches section 4)
> to check and test his patches with tools like checkpatch or sparse
> before posting them.
>
> After all this patch is going into /arch/x86 and not /drivers/staging
> and this sort of "extern declaration" is prone to break one day when
> void do_invalid_op(struct pt_regs *, long); declaration is modified.
> --
> GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
> Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
>

This one is perfect according to checkpatch.pl

The AMD Geode LX has an x86 id of 5 (i586) tought it's technically an i686:

root@alix:~# egrep '^(cpu family|model name|flags)' /proc/cpuinfo
cpu family      : 5
model name      : Geode(TM) Integrated Processor by AMD PCS
flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx
mmxext 3dnowext 3dnow

indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).
This patch adds a quirck to promote the Geode to an i686 and emulates
the NOPL in the do_invalid_op trap, so the userspace never notices.
Emulating the NOPL has minimum performance loss, emulating a NOPL
takes 0.5 usecs
and they are rarely used in x86

Signed-off-by: Matteo Croce <technoboy85@gmail.com

--- a/arch/x86/kernel/Makefile	2009-11-06 15:06:52.246223989 +0100
+++ b/arch/x86/kernel/Makefile	2009-11-06 15:07:04.294054613 +0100
@@ -89,7 +89,7 @@
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o

 obj-$(CONFIG_K8_NB)		+= k8.o
-obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
+obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o nopl_emu.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o

--- a/arch/x86/kernel/cpu/amd.c	2009-11-06 15:06:52.254223805 +0100
+++ b/arch/x86/kernel/cpu/amd.c	2009-11-06 15:07:04.294054613 +0100
@@ -138,8 +138,10 @@
 	}

 	if (c->x86_model == 10) {
-		/* AMD Geode LX is model 10 */
-		/* placeholder for any needed mods */
+		/* Geode only lacks the NOPL instruction to be i686,
+		   but we can emulate it in the exception handler
+		   and promote it to a class 6 cpu */
+		boot_cpu_data.x86 = 6;
 		return;
 	}
 }
--- a/arch/x86/kernel/entry_32.S	2009-11-06 15:06:52.258224172 +0100
+++ b/arch/x86/kernel/entry_32.S	2009-11-06 15:07:04.306230613 +0100
@@ -901,7 +901,11 @@
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
+#ifdef CONFIG_MGEODE_LX
+	pushl $do_nopl_emu
+#else
 	pushl $do_invalid_op
+#endif
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/arch/x86/kernel/nopl_emu.c	2009-11-07 11:59:17.667748571 +0100
@@ -0,0 +1,103 @@
+/*
+ *  linux/arch/x86/kernel/nopl_emu.c
+ *
+ *  Copyright (C) 2002  Willy Tarreau
+ *  Copyright (C) 2009  Matteo Croce
+ */
+
+#include <linux/linkage.h>
+#include <asm/math_emu.h>
+#include <asm/traps.h>
+
+/* This code can be used to allow the AMD Geode to hopefully correctly execute
+ * some code which was originally compiled for an i686, by emulating NOPL,
+ * the only missing i686 instruction in the CPU
+ *
+ * Willy Tarreau <willy@meta-x.org>
+ * Matteo Croce <technoboy85@gmail.com>
+ */
+
+static inline int do_1f(u8 *ip)
+{
+	int length = 3;
+	switch (*ip) {
+	case 0x84:
+		if (!ip[5])
+			length++;
+		else
+			return 0;
+	case 0x80:
+		if (!ip[4] && !ip[3])
+			length += 2;
+		else
+			return 0;
+	case 0x44:
+		if (!ip[2])
+			length++;
+		else
+			return 0;
+	case 0x40:
+		if (!ip[1])
+			length++;
+		else
+			return 0;
+	case 0x00:
+		return length;
+	}
+	return 0;
+}
+
+static inline int do_0f(u8 *ip)
+{
+	if (*ip == 0x1f)
+		return do_1f(ip + 1);
+	return 0;
+}
+
+static inline int do_66(u8 *ip)
+{
+	if (*ip == 0x90)
+		return 2;
+	if (*ip == 0x0f) {
+		int res = do_0f(ip + 1);
+		if (res)
+			return res + 1;
+		else
+			return 0;
+	}
+	return 0;
+}
+
+static inline int do_start(u8 *ip)
+{
+	if (*ip == 0x0f)
+		return do_0f(ip + 1);
+	if (*ip == 0x66)
+		return do_66(ip + 1);
+	return 0;
+}
+
+/* [do_nopl_emu] is called by exception 6 after an invalid opcode has been
+ * encountered. It will try to emulate it by doing nothing,
+ * and will send a SIGILL or SIGSEGV to the process if not possible.
+ * the NOPL can have variable length opcodes:
+
+bytes number	opcode
+	2	66 90
+	3	0f 1f 00
+	4	0f 1f 40 00
+	5	0f 1f 44 00 00
+	6	66 0f 1f 44 00 00
+	7	0f 1f 80 00 00 00 00
+	8	0f 1f 84 00 00 00 00 00
+	9	66 0f 1f 84 00 00 00 00 00
+*/
+void do_nopl_emu(struct pt_regs *regs, long error_code)
+{
+	int res = do_start((u8 *)instruction_pointer(regs));
+
+	if (res)
+		regs->ip += res;
+	else
+		do_invalid_op(regs, error_code);
+}
