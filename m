Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYIXARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYIXARS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 20:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYIXARI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 20:17:08 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27536 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYIXARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 20:17:05 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=5MlKb6vH5mDGvGU_b_UA:9 a=EQG0dCsfXVmRGcDnXpoA:7 a=Q_Su7wDZ7RSdoHiZK-3wy3rS90IA:4 a=6P13upv5DxEA:10 a=khtglLVS-hsA:10
Message-ID: <48D98701.60406@shaw.ca>
Date: Tue, 23 Sep 2008 18:17:05 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Singaravelan Nallasellan <singaravelann@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Interrupt handler latency and Interrupt handling issues
References: <fa.VvqVAPI7JzOrmNWy4fN1kaXpY2o@ifi.uio.no>
In-Reply-To: <fa.VvqVAPI7JzOrmNWy4fN1kaXpY2o@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Singaravelan Nallasellan wrote:
> I have an issue in determining the source of the interrupt due to the
> latency to access the register. The driver needs to send an read
> request to another kernel driver. The other driver will use an
> Indirect IO read to through an IO port. It will could also potentially
> generate interrupt. It will lead to the latency issues in the
> interrupt handler.
> 
> The driver may not be able to realiably identify the source of the
> interrupt before coming out of the IRQ handler if it has to come out
> the handler within a letency period.  Because of this, The driver will
> not be able to say IRQ handled before coming out of the handler. If
> the driver says IRQ handled assuming that the interrupt belongs to it,
> it could also cause conflict with the other interrupt handler
> registered for the same interrupt.

The driver does not need to determine exactly if its device caused the 
interrupts (with some devices it's not even possible to tell for sure). 
You can always say IRQ_HANDLED if you can't tell. This doesn't affect 
whether other IRQ handlers on that interrupt will be called. The only 
downside is that the screaming IRQ detection won't work on that IRQ 
since that driver always says it handled the interrupt.

> 
> I am planning to say that IRQ handled in the Interrupt handler and
> schedule a work queue to handle the identification and handling. Does
> anybody see issues here? Are there any better mechanism to handle this
> case?
> 
> Is there any latency requirements from the kernel?
> 
> How much is the tolerable latency for the interrupt handlers?

