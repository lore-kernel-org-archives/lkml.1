Return-Path: <linux-kernel-owner+w=401wt.eu-S937675AbXHHV2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937675AbXHHV2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763702AbXHHV2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:28:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41710 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761652AbXHHV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:28:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: "vgoyal@in.ibm.com" <vgoyal@in.ibm.com>, Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com>
	<20070808113834.GA26145@in.ibm.com>
	<46BA0651.5010708@fujitsu-siemens.com>
Date: Wed, 08 Aug 2007 15:25:53 -0600
In-Reply-To: <46BA0651.5010708@fujitsu-siemens.com> (Martin Wilck's message of
	"Wed, 08 Aug 2007 20:07:13 +0200")
Message-ID: <m1d4xxbtwe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Wilck <martin.wilck@fujitsu-siemens.com> writes:

> Vivek Goyal wrote:
>
>> Got this oops while testing your patch when I did
>> "echo c > /proc/sysrq-trigger"
>
> That's bad :-(
>
> ...
>> Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
>  [<0000000000000000>]
>>  <IRQ>  [<ffffffff8025afd0>] handle_edge_irq+0x5c/0x127
>>  [<ffffffff8020e1ae>] do_IRQ+0xf1/0x15f
>>  [<ffffffff8020c191>] ret_from_intr+0x0/0xa
>>  <EOI>  <NMI>  [<ffffffff80351ae3>] __delay+0x6/0x10
>>  [<ffffffff8021e328>] crash_nmi_callback+0x4b/0x77
>
> Obviously, it the oops occurs after the IRQs are re-enabled in
> crash_nmi_callback().
> It appears that desc->chip->mask (in mask_ack_irq(), kernel/irq/chip.c:462) was
> NULL.
> I have no idea how my patch could cause that.
>
> This proves that re-enabling IRQs in this situation is too dangerous :-(.
> I really did hundreds of dumps in different ways (echo c>/proc/sysrq-trigger,
> forcing Oops and panic(), actually hititng Alt-Sysrq) and this never happened to
> me.

This reminds me. 

There is currently an issue that no has finished converting
the lapic to the new generic irq way.  Which can have this effect.

Eric
