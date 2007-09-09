Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbXIIQvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbXIIQvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 12:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbXIIQvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 12:51:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56904 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701AbXIIQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 12:51:15 -0400
Date: Sun, 9 Sep 2007 17:49:35 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Dennis Lubert <plasmahh@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tsc timer related problems/questions
Message-ID: <20070909174935.7c00bbb7@laptopd505.fenrus.org>
In-Reply-To: <1189355506.6255.60.camel@speedy.projectiwear.org>
References: <1189355506.6255.60.camel@speedy.projectiwear.org>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Sep 2007 18:31:45 +0200
Dennis Lubert <plasmahh@gmx.net> wrote:

Hi,

> 
> [105771.523771] BUG: soft lockup detected on CPU#1!
> [105771.527869]
> [105771.527871] Call Trace:
> [105771.536079]  <IRQ>  [<ffffffff802619cc>] _spin_lock+0x9/0xb
> [105771.540294]  [<ffffffff802a6f9d>] softlockup_tick+0xd2/0xe7
> [105771.544359]  [<ffffffff8024bcbb>] run_local_timers+0x13/0x15
> [105771.548541]  [<ffffffff80289fc1>] update_process_times+0x4c/0x79
> [105771.552737]  [<ffffffff80270327>] smp_local_timer_interrupt
> +0x34/0x54
> [105771.556934]  [<ffffffff80270834>]
> smp_apic_timer_interrupt+0x51/0x68 [105771.561022]
> [<ffffffff80268121>] default_idle+0x0/0x42 [105771.565199]
> [<ffffffff8025cce6>] apic_timer_interrupt+0x66/0x70 [105771.569386]
> <EOI>  [<ffffffff8026814e>] default_idle+0x2d/0x42 [105771.573597]
> [<ffffffff80247929>] enter_idle+0x22/0x24 [105771.577665]
> [<ffffffff80247a92>] cpu_idle+0x5a/0x79 [105771.581838]
> [<ffffffff806bc5f7>] start_secondary+0x474/0x483
> 
> Question: Is this a known bug already or should further investigation
> take place?

this needs further investigation but note that this one can have many
different causes; this kind of oops trace often is also found for
certain types of BIOS bugs. (which makes it really painful to debug)

> 
> - Using Kernels from 2.6.21 on (random sampled) we experience that the
> TSC isn't used per default anymore (we usually set the nopmtimer
> option at boot for a while now). Looking briefly at the 2.6.23-rc5
> code shows that in the function where the check is done whether the
> tsc is stable the only code path where a "is stable" result could be
> returned is one where the vendor of the CPU is detected as Intel.
> Instead a much slower timesource (10ms instead of a few us
> resolution, same for getting the time at all) is used which is
> totally unusable for us (Within 10ms so much things happen).

Please consider enabling the HPET in your bios; while it's not as fast
as the tsc, it does provide the accuracy you want.
> 
> Question: Why are only Intel CPUs considered as stable? Could there be
> implemented a more sophisticated heuristic, that actually does some
> tests for tsc stability?

on AMD multi-socket systems, afaik the tsc is not synchronized between
packages. On Intel the tsc is derived from the FSB which is shared
between the packages.


HPET is central to the system and solves all the issues, but is a tad
slower to access than the tsc.
