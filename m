Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYBIGVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYBIGVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 01:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYBIGUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 01:20:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYBIGUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 01:20:10 -0500
Date: Sat, 9 Feb 2008 07:19:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc0 (#2)
Message-ID: <20080209061936.GA16849@elte.hu>
References: <200802080145.16774.lenb@kernel.org> <20080209061718.GA14200@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209061718.GA14200@elte.hu>
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


(Carlos Cc:-ed too)

* Ingo Molnar <mingo@elte.hu> wrote:

> * Len Brown <lenb@kernel.org> wrote:
> 
> > Len Brown (6):
> >       ACPI: add newline to printk
> >       ACPI: build WMI on X86 only
> >       acer-wmi, tc1100-wmi: select ACPI_WMI
> 
> hm, this new WMI code caused a bootup crash in the overnight x86.git 
> tests:
> 
> initcall 0x40cffbd0 ran for 0 msecs: msi_init+0x0/0x150()
> Calling initcall 0x40cffd20: tc1100_init+0x0/0x70()
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<404b96a2>] find_guid+0x132/0x150
> *pde = 00000000 
> Oops: 0000 [#1] SMP 
> 
> Pid: 1, comm: swapper Not tainted (2.6.24 #34)
> EIP: 0060:[<404b96a2>] EFLAGS: 00010247 CPU: 1
> EIP is at find_guid+0x132/0x150
> EAX: 05a572d4 EBX: 5f81af54 ECX: 00000000 EDX: ffffffff
> ESI: 00000000 EDI: 5f81af54 EBP: 5f81af80 ESP: 5f81af48
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process swapper (pid: 1, ti=5f81a000 task=5f815410 task.ti=5f81a000)
> Stack: 00000000 5f81af74 00000005 c364ac71 495a36db 39b49484 05a572d4 71ac64c3 
>        5a49db36 39b49484 05a572d4 00000000 00000000 ffffffed 5f81af88 404b96cf 
>        5f81af94 40cffd33 00000000 5f81afe0 40cdb5d3 2c7b1366 00000001 00000000 
> Call Trace:
>  [<404b96cf>] ? wmi_has_guid+0xf/0x20
>  [<40cffd33>] ? tc1100_init+0x13/0x70
>  [<40cdb5d3>] ? kernel_init+0x123/0x2f0
>  [<40cdb4b0>] ? kernel_init+0x0/0x2f0
>  [<401053d7>] ? kernel_thread_helper+0x7/0x10
>  =======================
> Code: 0c 41 8d 7d d4 eb 24 8d 46 08 b9 10 00 00 00 89 fa e8 e3 88 f6 ff 85 c0 75 0f b0 01 83 7d c8 00 74 19 8b 55 c8 89 32 eb 12 89 de <8b> 1e 0f 18 03 90 81 fe 90 c1 0c 41 75 ce 31 c0 83 c4 2c 5b 5e 
> EIP: [<404b96a2>] find_guid+0x132/0x150 SS:ESP 0068:5f81af48
> ---[ end trace 5d95b7a12e9c31b7 ]---
> Kernel panic - not syncing: Attempted to kill init!
> Press any key to enter the menu
> 
> config and crashlog attached.
