Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbYB2V1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbYB2V1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbYB2V1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:27:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54494 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914AbYB2V1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:27:11 -0500
Date: Fri, 29 Feb 2008 22:26:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080229212654.GL27212@elte.hu>
References: <20080228092846.GC17932@hjernemadsen.org> <20080228094000.GA2987@elte.hu> <20080228150444.GG17932@hjernemadsen.org> <47C6F4F9.90700@zytor.com> <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C873AA.6040305@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Klaus S. Madsen wrote:
>> open("/dev/mem", O_RDWR)                = 5
>> mmap2(NULL, 1282, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED|MAP_FIXED, 5, 0) = 0
>> mmap2(0xa0000, 393216, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_FIXED, 5, 0xa0) = 0xa0000
>                          ^^^^^^^^^^^^^^^^^^^^
>> close(5)                                = 0
>> ioperm(0, 0x400, 0x1)                   = 0
>> iopl(0x3)                               = 0
>> access("/sys/bus/pci", R_OK)            = 0
>> write(1, "Calling get_mode\n", 17)      = 17
>> vm86(0x1, 0xb7f14ccc, 0xb7f14830, 0xc000, 0x18b6 <unfinished ...>
>> --- SIGSEGV (Segmentation fault) @ 0 (0) ---
>> +++ killed by SIGSEGV (core dumped) +++
>
> This is the VGA BIOS being mapped, it's mapped PROT_READ|PROT_WRITE, but  
> no PROT_EXEC; if the kernel is NX-capable it *should* segfault trying to 
> execute out of this area, which is exactly what will happen when vm86 
> executes INT 10h.
>
> If we can find that mmap() in the s2ram source code and add PROT_EXEC 
> to it, it would be interesting.

Klaus, could you send your .config as well? Lets make sure that NX is 
even relevant in this context.

	Ingo
