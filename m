Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYF2Inz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYF2Inz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 04:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYF2Inp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 04:43:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYF2Inn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 04:43:43 -0400
Date: Sun, 29 Jun 2008 10:43:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080629084318.GA28815@elte.hu>
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486539A3.3030102@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Subject: x86_64: fix non-paravirt compilation

i've put tip/x86/xen-64bit into tip/master briefly and it quickly 
triggered this crash on 64-bit x86:

Linux version 2.6.26-rc8-tip-00241-gc6c8cb2-dirty (mingo@dione)
 (gcc version 4.2.3) #12303 SMP Sun Jun 29 10:30:01 CEST 2008

Command line: root=/dev/sda6 console=ttyS0,115200 earlyprintk=serial,ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
console [earlyser0] enabled
debug: ignoring loglevel setting.
Entering add_active_range(0, 0x0, 0x9f) 0 entries of 25600 used
Entering add_active_range(0, 0x100, 0x3fff0) 1 entries of 25600 used
last_pfn = 0x3fff0 max_arch_pfn = 0x3ffffffff
init_memory_mapping
kernel direct mapping tables up to 3fff0000 @ 8000-a000
PANIC: early exception 0e rip 10:ffffffff804b24e2 error 0 cr2 ffffffffff300000
Pid: 0, comm: swapper Not tainted 2.6.26-rc8-tip-00241-gc6c8cb2-dirty #12303

Call Trace:
 [<ffffffff80efe196>] early_idt_handler+0x56/0x6a
 [<ffffffff804b24e2>] ? __memcpy_fromio+0x12/0x30
 [<ffffffff804b24d9>] ? __memcpy_fromio+0x9/0x30
 [<ffffffff80f32f27>] dmi_scan_machine+0x57/0x1b0
 [<ffffffff80f02c15>] setup_arch+0x3f5/0x5e0
 [<ffffffff80efedd5>] start_kernel+0x75/0x350
 [<ffffffff80efe289>] x86_64_start_reservations+0x89/0xa0
 [<ffffffff80efe397>] x86_64_start_kernel+0xf7/0x100

RIP 0x10

with this config:

  http://redhat.com/~mingo/misc/config-Sun_Jun_29_10_29_11_CEST_2008.bad

i've saved the merged 2.6.26-rc8-tip-00241-gc6c8cb2-dirty tree into 
tip/tmp.x86.xen-64bit.Sun_Jun_29_10 and pushed it out, so you can test 
that exact version.

	Ingo
