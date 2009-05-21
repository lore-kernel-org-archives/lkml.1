Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZEUOGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZEUOGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbZEUOGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:06:20 -0400
Received: from h155.mvista.com ([63.81.120.155]:49099 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756969AbZEUOGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:06:19 -0400
Message-ID: <4A15600A.40906@ru.mvista.com>
Date: Thu, 21 May 2009 18:07:06 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ide: ->ide_dma_clear_irq() -> ->clear_irq()
References: <200808192031.40288.bzolnier@gmail.com> <48AB478B.5040209@ru.mvista.com> <48CEDD89.5060107@ru.mvista.com>
In-Reply-To: <48CEDD89.5060107@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>> * Rename ->ide_dma_clear_irq method to ->clear_irq
>>>   and move it from ide_hwif_t to struct ide_port_ops.

>>> * Move ->waiting_for_dma check inside ->clear_irq method.

>>> * Move ->dma_base check inside ->clear_irq method.

>>> piix.c:
>>> * Add ich_port_ops and remove init_hwif_ich() wrapper.

>>> There should be no functional changes caused by this patch.

[...]

>>   It may also be worth considering turning this method into 
>> test-and-clear, so that we can get the actual IDE interrupt state on 
>> the chips that implement this...

>   Probably might add the test_irq() method to be called on 
> !hwif->waiting_for_dma. Cleraing the status at once seems impractical...

    Yet this seems what ack_intr() method is doing already...
    What it does is testing IRQ status and "acknowledging" it (the semantics 
of "acknowledge" is not clear to me, yet it seems that it's clearing the 
interrupt latch in the drivers where it's implemented). And the call site of 
ack_intr() method corresponds to where test_irq() should have been called, 
so it seems we don't need yet another method and probably didn't even need 
clear_irq() method in the first place?..
    Bart, could you clarify about how ack_intr() is supposed to work?

MBR, Sergei

