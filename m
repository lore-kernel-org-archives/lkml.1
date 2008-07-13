Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYGMNek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYGMNek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 09:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYGMNeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 09:34:15 -0400
Received: from mail4.aster.pl ([212.76.33.58]:15996 "EHLO mail4.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbYGMNeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 09:34:11 -0400
From: "Jakub W. Jozwicki" <jozwicki@aster.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2.6.25.10 1/2] libata: fix locking for kmap_atomic
Date: Sun, 13 Jul 2008 15:30:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, jgarzik@redhat.com, mingo@elte.hu,
       tglx@timesys.com
References: <200807130127.36706.jozwicki@aster.pl> <20080713112543.2dc9d6f7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080713112543.2dc9d6f7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807131530.03402.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday, 13 of July 2008 12:25:43 Alan Cox napisał(a):
> On Sun, 13 Jul 2008 01:27:36 +0200
>
> "Jakub W. Jozwicki" <jozwicki@aster.pl> wrote:
> > Change locking surrounding kmap_atomic from local_irqsave to
> > local_irqsave_nort. This fixes issues with PREEMPT_RT.
> >
> > Signed-off-by:  Jakub Jozwicki <jozwicki@aster.pl>
>
> The right way to fix this is to use a bounce buffer. I sent Jeff patches
> to do that a couple of times. I'm not sure what has happened to them
> since ? So NAK this, we should apply the patch to actually fix the bug
> instead.
>
> Jeff ?
>
> Alan

Sent patch was for:

[   16.787021] BUG: sleeping function called from invalid context IRQ-14(5730) 
at arch/x86/mm/highmem_32.c:8
[   16.787021] in_atomic():0 [00000000], irqs_disabled():1
[   16.787021] Pid: 5730, comm: IRQ-14 Not tainted 2.6.25.10-rtXXX #12
[   16.787021]  [<c0120fc4>] __might_sleep+0xf1/0xf8
[   16.787021]  [<c011c035>] kmap+0x47/0x5a
[   16.787021]  [<c03442b2>] ata_scsi_rbuf_get+0x23/0x31
[   16.787021]  [<c0345975>] atapi_qc_complete+0x252/0x2c5
[   16.787021]  [<c012edee>] ? irq_exit+0x7b/0x7e
[   16.787021]  [<c0109727>] ? do_IRQ+0x6e/0x87
[   16.787021]  [<c033d041>] __ata_qc_complete+0x8e/0x93
[   16.787021]  [<c033ddfb>] ata_qc_complete+0x182/0x188
[   16.787021]  [<c033e188>] ata_hsm_qc_complete+0xa1/0xa5
[   16.787021]  [<c033e8fd>] ata_hsm_move+0x5dd/0x628
[   16.787021]  [<c0342f76>] ata_interrupt+0x14e/0x1cb
[   16.787021]  [<c015c72c>] handle_IRQ_event+0x4e/0xd1
[   16.787021]  [<c015d266>] do_irqd+0x126/0x224
[   16.787021]  [<c015d140>] ? do_irqd+0x0/0x224
[   16.787021]  [<c013ae9d>] kthread+0x3b/0x62
[   16.787021]  [<c013ae62>] ? kthread+0x0/0x62
[   16.787021]  [<c0108287>] kernel_thread_helper+0x7/0x10
[   16.787021]  =======================

