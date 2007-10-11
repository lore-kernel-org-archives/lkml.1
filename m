Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbXJKIZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbXJKIZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 04:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbXJKIZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 04:25:12 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:54077 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754418AbXJKIZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 04:25:10 -0400
Date: Thu, 11 Oct 2007 10:24:54 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Philippe =?UTF-8?B?UsOpdG9ybmF6?= <philippe.retornaz@epfl.ch>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: Re: [PATCH] AVR32: Fix random segfault with preemption
Message-ID: <20071011102454.4ff0225f@dhcp-255-175.norway.atmel.com>
In-Reply-To: <200710101852.27213.philippe.retornaz@epfl.ch>
References: <200710101852.27213.philippe.retornaz@epfl.ch>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 18:52:24 -0400
Philippe Rétornaz <philippe.retornaz@epfl.ch> wrote:

> As explained on:
> http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&t=53307
> If the current process is preempted before it can copy RAR_SUP and
> RSR_SUP both register are lost and the process will segfault as soon
> as it return from the syscall since the return adress will be
> corrupted. 
> 
> This patch disable IRQ as soon as we enter the syscall path and
> reenable them when the copy is done. 
> 
> In the interrupt handlers, check if we are interrupting the srrf
> instruction, if so disable interrupts and return. The interrupt
> handler will be re-called immediatly when the interrupts are
> reenabled.

Just to make it clear: It will disable interrupts in the return
context, so interrupts will be disabled when the interrupt handler
returns.

> After some stressing workload:
> - find / > /dev/null in loop
> - top (in ssh)
> - ping -f avr32
> 
> The segfaults are not seen anymore.
> 
> Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>

Nice work. The patch looks correct as far as I can tell, so I think
I'll merge it as soon as possible, and perhaps enable CONFIG_PREEMPT in
the defconfig, to give it some more exposure.

Thanks!

Håvard
