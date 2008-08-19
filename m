Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYHSWWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYHSWWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYHSWWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:22:10 -0400
Received: from homer.mvista.com ([63.81.120.155]:17050 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746AbYHSWWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:22:09 -0400
Message-ID: <48AB478B.5040209@ru.mvista.com>
Date: Wed, 20 Aug 2008 02:22:03 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ide: ->ide_dma_clear_irq() -> ->clear_irq()
References: <200808192031.40288.bzolnier@gmail.com>
In-Reply-To: <200808192031.40288.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Rename ->ide_dma_clear_irq method to ->clear_irq
>   and move it from ide_hwif_t to struct ide_port_ops.
>
> * Move ->waiting_for_dma check inside ->clear_irq method.
>
> * Move ->dma_base check inside ->clear_irq method.
>
> piix.c:
> * Add ich_port_ops and remove init_hwif_ich() wrapper.
>
> There should be no functional changes caused by this patch.
>   

   Good. I think it's worth implementing this method in at least 
cmd64x.c which actually reads the IDE interrupt latch bits (independent 
from the DMA interrupt status) in the dma_test_irq() methods but never 
clears them, so the latches may reflect a non-current state of the IDE 
interrupt...
   It may also be worth considering turning this method into 
test-and-clear, so that we can get the actual IDE interrupt state on the 
chips that implement this...

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


