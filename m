Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbYESTk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbYESTk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbYESTkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:40:49 -0400
Received: from smtp.innovsys.com ([66.115.232.196]:40029 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756717AbYESTks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:40:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Oops with PREEMPT-RT on 2.6.25.4
Date: Mon, 19 May 2008 14:41:10 -0500
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B04690162@ismail.innsys.innovsys.com>
In-Reply-To: <4831D527.2020907@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Oops with PREEMPT-RT on 2.6.25.4
Thread-Index: Aci55pfoo+SYTszaQxalPQEz2ZcemwAATgFg
References: <DCEAAC0833DD314AB0B58112AD99B93B0469010C@ismail.innsys.innovsys.com> <4831D527.2020907@freescale.com>
From: "Rune Torgersen" <runet@innovsys.com>
To: "Scott Wood" <scottwood@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <linux-ide@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
> Rune Torgersen wrote:
>> Hi
>> I get the following oops when trying to boot a arch/powerpc kernel
>> with preempt-rt installed (v2.6.25.4-rt1)
>> The board is using a Freescale 8280 as the main CPU and a Silicon
>> Image SII3124 SATA controller. The oops seems to happen on
>> fileaccess right after init starts.
> [snip]
>> NIP [c0249618] rt_spin_lock_slowlock+0x9c/0x200
>> LR [c02495ec] rt_spin_lock_slowlock+0x70/0x200
>> Call Trace:
>> [ef29d600] [c02495ec] rt_spin_lock_slowlock+0x70/0x200 (unreliable)
>> [ef29d670] [c00277d0] lock_timer_base+0x2c/0x64
>> [ef29d690] [c00285e8] del_timer+0x2c/0x78
>> [ef29d6b0] [c019d108] scsi_delete_timer+0x1c/0x3c
>> [ef29d6d0] [c01992d0] scsi_done+0x18/0x4c
>> [ef29d6f0] [c01b19dc] ata_scsi_qc_complete+0x364/0x380
>> [ef29d720] [c01a8708] __ata_qc_complete+0xd8/0xec
>> [ef29d740] [c01b011c] ata_qc_complete_multiple+0xc4/0xec
>> [ef29d760] [c01bcaf4] sil24_interrupt+0x46c/0x52c
>> [ef29d7a0] [c0048954] handle_IRQ_event+0x64/0x100
>> [ef29d7d0] [c0048b30] __do_IRQ+0x140/0x1bc
>> [ef29d7f0] [c00166c4] apmax_int_irq_demux+0x8c/0xb0
>> [ef29d810] [c0006448] do_IRQ+0x68/0xa8
>> [ef29d820] [c0010388] ret_from_except+0x0/0x14
>> --- Exception: 501 at __spin_unlock_irqrestore+0x28/0x4c
>>     LR = __spin_unlock_irqrestore+0x20/0x4c
>> [ef29d8f0] [c0249600] rt_spin_lock_slowlock+0x84/0x200
>> [ef29d960] [c00277d0] lock_timer_base+0x2c/0x64
> 
> You're recursively entering lock_timer_base, which does a
> spin_lock_irqsave().  Either interrupts are enabled when they should
> not be, or an interrupt was supposed to be threaded that isn't.

Sort of figured. How do I figure out which one, and how to fix it?
I've never gotten any -rt patchsets to work on this CPU, and it always
seems to be related to the disk driver.
I've tried since 2.6.16 ppc.... (2.6.16, 2.6.18 on ppc, 2.6.24 and 25 on
powerpc)

Even though this is a custom board, I'm pretty sure I can get it to fail
on a pq2fads board with the same disk controller.

