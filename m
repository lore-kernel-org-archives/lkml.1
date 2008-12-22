Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYLVWaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYLVWaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYLVW3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:29:51 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:50058 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbYLVW3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:29:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=neHfQiXvUlIeSo6SFtr2iWfB3mTR+AwaGFrila9tEDevNqN18zyS4zLQi7iivxR0KN
         vVm0YAdz9dlT3tL67UJoLyC1hdIaqg0Vld4nXqapqdXHzkRNbHhP6L5WtumzgVB93P/z
         faGXWL7Mp7O9LlcsykNlg4OOpWghKNZUY5jas=
Message-ID: <b637ec0b0812221429m441b9493q97a7ccb82dfc0334@mail.gmail.com>
Date: Mon, 22 Dec 2008 23:29:49 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: TSC not updating after resume: Bug or Feature?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
In-Reply-To: <alpine.LFD.2.00.0812222315460.3723@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>
	 <20081222150021.GA13839@elte.hu>
	 <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>
	 <alpine.LFD.2.00.0812222056190.3723@localhost.localdomain>
	 <b637ec0b0812221239p169967aemf14b2e591779f5cd@mail.gmail.com>
	 <alpine.LFD.2.00.0812222212191.3723@localhost.localdomain>
	 <b637ec0b0812221335w54fe11ecwf05e0302bc27b5a3@mail.gmail.com>
	 <alpine.LFD.2.00.0812222238192.3723@localhost.localdomain>
	 <b637ec0b0812221412w396337embad90f599a02d3d9@mail.gmail.com>
	 <alpine.LFD.2.00.0812222315460.3723@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, it seems that you got it.

The system survived two hibernation / resume cycles without triggering
the warning and, probably the most important part, the dmesg does not
have any "jumps" before the "Force enable HPET on resume" line as
before:

[  275.647704] PM: Creating hibernation image:
[  275.648005] PM: Need to copy 177844 pages
[  275.648005] Intel machine check architecture supported.
[  275.648005] Intel machine check reporting enabled on CPU#0.
[  275.648005] Force enabled HPET at resume
[  275.648005] ACPI: Waking up from system sleep state S4
[  275.669038] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[  275.740697] pcieport-driver 0000:00:01.0: setting latency timer to 64
[  275.740781] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[  275.740786] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY

...and so on.

As i mentioned in the bug report, to be sure that the bug doesn't
trigger I have to wait at least on day and > 10 hibernation / resumee
cycles.

But with your first patch the bug triggered at the second cycle, so
I'm optimist :-)

I'll keep you informed. Many thanks in advance,
Fabio




On Mon, Dec 22, 2008 at 11:16 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Mon, 22 Dec 2008, Fabio Comolli wrote:
>
>> Won't apply:
>>
>> fcomolli@hawking:~/software/GIT-TREES/linux-2.6> patch -p1 --dry-run <
>> /home/fcomolli/0009c-tglx-debug.patch
>> patching file kernel/sched_clock.c
>> patching file kernel/time/timekeeping.c
>> Hunk #1 succeeded at 49 with fuzz 2 (offset 3 lines).
>> Hunk #2 succeeded at 100 with fuzz 2 (offset 5 lines).
>> Hunk #3 FAILED at 309.
>> 1 out of 3 hunks FAILED -- saving rejects to file kernel/time/timekeeping.c.rej
>>
>> Should I revert you previous one?
>
> Oops, yes.
>
> Thanks,
>
>        tglx
>
