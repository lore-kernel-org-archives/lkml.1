Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZEVTS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZEVTS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZEVTST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:18:19 -0400
Received: from h155.mvista.com ([63.81.120.155]:41818 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751463AbZEVTSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:18:18 -0400
Message-ID: <4A16FAB0.5020301@ru.mvista.com>
Date: Fri, 22 May 2009 23:19:12 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-m68k@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ->ack_intr in m68k IDE drivers  [was: Re: [PATCH 2/5] ide: ->ide_dma_clear_irq()
 -> ->clear_irq()]
References: <200808192031.40288.bzolnier@gmail.com> <48CEDD89.5060107@ru.mvista.com> <4A15600A.40906@ru.mvista.com> <200905222044.42688.bzolnier@gmail.com>
In-Reply-To: <200905222044.42688.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>>>  It may also be worth considering turning this method into 
>>>>test-and-clear, so that we can get the actual IDE interrupt state on 
>>>>the chips that implement this...

>>>  Probably might add the test_irq() method to be called on 
>>>!hwif->waiting_for_dma. Cleraing the status at once seems impractical...

>>    Yet this seems what ack_intr() method is doing already...
>>    What it does is testing IRQ status and "acknowledging" it (the semantics 
>>of "acknowledge" is not clear to me, yet it seems that it's clearing the 
>>interrupt latch in the drivers where it's implemented). And the call site of 
>>ack_intr() method corresponds to where test_irq() should have been called, 
>>so it seems we don't need yet another method and probably didn't even need 
>>clear_irq() method in the first place?..

> They have different goals -- the main purpose of ack_intr() (despite its name)
> seems to be testing whether the IRQ is ours,

    It does clear some interrupt bit if it sees that IRQ is ours too, hence 
the same.

> OTOH in clear_irq() we know that
> already and we just want to clear the pending IRQ status.

    There seems to be duplication of functionality b/w ack_intr() and 
clear_irq() now...

> So I'm not sure if unification is desirable... though some improvements are
> definitely possibly there (less confusing naming at least)...

>>    Bart, could you clarify about how ack_intr() is supposed to work?

> Good question, m68k list would be the best place to look for an answer..

    Well, I seem to have been able to infer it from the code...

MBR, Sergei
