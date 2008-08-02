Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYHBXdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYHBXdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 19:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYHBXdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 19:33:01 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:42655 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYHBXdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:33:00 -0400
Date: Sun, 3 Aug 2008 00:47:25 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdhci: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter -
	disabling IRQ
Message-ID: <20080802224725.GA6574@hardeman.nu>
Mail-Followup-To: Pierre Ossman <drzeus-list@drzeus.cx>,
	linux-kernel@vger.kernel.org
References: <20080624181656.GB14243@hardeman.nu> <20080710083457.7887d363@mjolnir.drzeus.cx> <20080711164706.GA8943@hardeman.nu> <20080719015531.6c8a1981@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080719015531.6c8a1981@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 01:55:31AM +0200, Pierre Ossman wrote:
>On Fri, 11 Jul 2008 18:47:06 +0200 David Härdeman <david@hardeman.nu> wrote:
>> On Thu, Jul 10, 2008 at 08:34:57AM +0200, Pierre Ossman wrote:
>> >And can you give me a complete
>> >dmesg dump. The sdhci hardware might not be the culprit, but just a
>> >trigger in that it enables that interrupt line.
>> 
>> Attached below....and /proc/interrupts says:
>> 
>
>I see that you have an iwl4965. I got this precise problem when I
>toggled the rfkill switch on my laptop. It is fixed in 2.6.26 though.
>Could you try upgrading the kernel and see if it's the same bug?

Unfortunately the problem is still present with 2.6.26 (Debian package 
linux-image-2.6.26-1-amd64):

[  640.407901] irq 19: nobody cared (try booting with the "irqpoll" option)
[  640.407906] Pid: 0, comm: swapper Not tainted 2.6.26-1-amd64 #1
[  640.407908] 
[  640.407909] Call Trace:
[  640.407910]  <IRQ>  [<ffffffff8026c46b>] __report_bad_irq+0x30/0x72
[  640.407937]  [<ffffffff8026c6aa>] note_interrupt+0x1fd/0x23b
[  640.407945]  [<ffffffff8026cf33>] handle_fasteoi_irq+0xa5/0xc8
[  640.407951]  [<ffffffff8020f590>] do_IRQ+0x6d/0xd9
[  640.407956]  [<ffffffff8020c43d>] ret_from_intr+0x0/0x19
[  640.407958]  <EOI>  [<ffffffff8021e480>] hpet_legacy_next_event+0x0/0x34
[  640.407974]  [<ffffffffa002f46e>] :processor:acpi_idle_enter_simple+0x18d/0x1ff
[  640.407983]  [<ffffffff803a704c>] cpuidle_idle_call+0x7a/0xb2
[  640.407986]  [<ffffffff803a6fd2>] cpuidle_idle_call+0x0/0xb2
[  640.407989]  [<ffffffff8020ac79>] cpu_idle+0x89/0xb3
[  640.408003] 
[  640.408004] handlers:
[  640.408005] [<ffffffffa012e9ab>] (sdhci_irq+0x0/0x5de [sdhci])
[  640.408010] Disabling IRQ #19

-- 
David Härdeman
