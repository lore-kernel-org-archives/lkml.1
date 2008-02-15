Return-Path: <linux-kernel-owner+w=401wt.eu-S1763183AbYBOUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763183AbYBOUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbYBOUZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:25:18 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:23930 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378AbYBOUZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:25:15 -0500
Date: Fri, 15 Feb 2008 12:23:36 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080215202336.GE26034@mail.oracle.com>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mika Penttila <mika.penttila@kolumbus.fi>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org> <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B3F2DC.8080707@goop.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 06:50:52PM +1100, Jeremy Fitzhardinge wrote:
>> 	I'm seeing the same problem, with no messages at all from xen
>> other than "domain crashed, restart disabled" in xend.log.  I got a
>> different commit in my bisect, 0947b2f31ca1ea1211d3cde2dbd8fcec579ef395
>> (i386 boot: replace boot_io    remap with enhanced bt_ioremap - enhance
>> bt_ioremap).  I started from yesterday's
>> 96b5a46e2a72dc1829370c87053e0cd558d58bc0 (WMI: initialize
>> wmi_blocks.list even if ACPI is disabled) and a known good
>> 9b73e76f3cf63379dcf45fcd4f112f5812418d0a (Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6).
>
> Is the domain ending up in the crashed state?  Do you get a register  
> dump with xm dmesg?  That would be very useful in determining what went  
> wrong.  You may need to compile Xen with debug=y in Config.mk.

	I didn't know xm dmesg existed :-)  Regarding debug=y, I'm using
a prepackaged dom0 set.  Here's what I find in xm dmesg:

Joel

(XEN) mm.c:1825:d109 Bad type (saw 0000000028000001 != exp 00000000e0000000) for mfn 3a2f0f (pfn f0)
(XEN) mm.c:649:d109 Error getting mfn 3a2f0f (pfn f0) from L1 entry 00000003a2f0f063 for dom109
(XEN) mm.c:1825:d109 Bad type (saw 0000000028000001 != exp 00000000e0000000) for mfn 3a2f0f (pfn f0)
(XEN) mm.c:649:d109 Error getting mfn 3a2f0f (pfn f0) from L1 entry 00000003a2f0f063 for dom109
(XEN) mm.c:3331:d109 ptwr_emulate: could not get_page_from_l1e()
(XEN) Unhandled page fault in domain 109 on VCPU 0 (ec=0003)
(XEN) Pagetable walk from 00000000c01687f0:
(XEN)  L4[0x000] = 00000003a2933027 00000000000006cc
(XEN)  L3[0x003] = 000000039afea027 0000000000000005
(XEN)  L2[0x000] = 000000039bfb7067 0000000000001048 
(XEN)  L1[0x168] = 00000003a2e97061 0000000000000168
(XEN) domain_crash_sync called from entry.S
(XEN) Domain 109 (vcpu#0) crashed on cpu#2:
(XEN) ----[ Xen-3.1.3-rc3  x86_64  debug=n  Not tainted ]----
(XEN) CPU:    2
(XEN) RIP:    e019:[<00000000c04040bd>]
(XEN) RFLAGS: 0000000000000282   CONTEXT: guest
(XEN) rax: 00000000c01687f0   rbx: 00000000f52fe000   rcx: 00000000a2f0f063
(XEN) rdx: 0000000000000003   rsi: 0000000000000000   rdi: 00000000a2f0f063
(XEN) rbp: 0000000000000003   rsp: 00000000c06daefc   r8:  0000000000000000
(XEN) r9:  0000000000000000   r10: 0000000000000000   r11: 0000000000000000
(XEN) r12: 0000000000000000   r13: 0000000000000000   r14: 0000000000000000
(XEN) r15: 0000000000000000   cr0: 000000008005003b   cr4: 00000000000006f0
(XEN) cr3: 000000039afe2000   cr2: 00000000c01687f0
(XEN) ds: e021   es: e021   fs: e021   gs: e021   ss: e021   cs: e019
(XEN) Guest stack trace from esp=c06daefc:
(XEN)   00000003 c04040bd 0001e019 00010082 c01687f0 f52fe000 80000000 a2f0f063
(XEN)   000f0000 c01687f0 c0417ab6 a2f0f063 00000003 000000f0 f52fe000 00000010
(XEN)   000004ff 000f0000 000004ff c06eee29 00000063 80000000 000f0000 c06dafc8
(XEN)   c06ca400 0069a000 00000000 c06f9d82 00000000 f57fd000 f57fd000 f57fd000
(XEN)   c0005d60 c06dafc8 c06ca400 0069a000 00000000 c06e70d4 c06d7680 c1043000
(XEN)   007c9000 00000000 0069a000 c1043000 c06dafe4 00000000 00000000 c06e05fd
(XEN)   c0602000 c06529f8 dfbffdff c0701940 c1043000 c06dafe4 00000000 00000000
(XEN)   c06e5f54 00000000 178bc1f1 00000001 03020800 00020f12 f5800000 00000000
(XEN)   c1043000 c06e05c3 c06e05cb c06e05d3 c040288f c040299a c0403270 c06e6141
(XEN)   c0403652 c0403709 c0403831 c0403a56 c0403a6d c0403a86 c0403b67 c04042c9
(XEN)   c0404492 c04045da c040467a c06e622f c06e6238 c04052c5 c04052f7 c0405325
(XEN)   c0405410 c06e6272 c06e62ee c06e6341 c05f23f3 c05f25d0 c04060eb c04063ed
(XEN)   c04064cf c040652b c0406719 c0406877 c0406fcc c0407046 c0407120 c04075cb
(XEN)   c04075e9 c040762b c040765f c040772c c0407755 c0407804 c0408c32 c0408cd3
(XEN)   c05fa9ad c05faa20 c05faabe c05fad01 c06e6843 c06e6853 c0409b23 c0409c6d
(XEN)   c06e6921 c06e692a c040a4f1 c040b5a2 c040b5b0 c040b627 c040b635 c06e7ff4
(XEN)   c06e8007 c040b8bf c040b8ee c06e8340 c06e8349 c040bcb0 c040bd26 c040c9a4
(XEN)   c040cca2 c040ccaa c040cd11 c040cd47 c040cd50 c040d026 c040d02e c040d278
(XEN)   c040d280 c040d297 c040d29f c040d2c4 c040ddad c040de24 c040de33 c040de67
(XEN)   c040dea1 c040deaa c040deb3 c05f2a94 c05f2bfb c05f2c4a c05f2c65 c05f2ddc

-- 

Life's Little Instruction Book #24

	"Drink champagne for no reason at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
