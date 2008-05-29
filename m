Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYE2ROK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYE2ROK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYE2RN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:13:56 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:3200 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYE2RN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:13:56 -0400
Subject: Re: [Patch/RFC]: check CONFIG_GENERIC_HARDIRQS for
	request/free_irq in interrupt.h
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200805291741.13956.borntraeger@de.ibm.com>
References: <200805291741.13956.borntraeger@de.ibm.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 29 May 2008 19:04:44 +0200
Message-Id: <1212080684.16984.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 17:41 +0200, Christian Borntraeger wrote:
> I currently try to evaluate virtio_console for kvm on s390 and got
> the following problem:
> 
> virtio_console uses hvc_alloc with irq=0. That means, register_irq
> and free_irq are never called by hvc_console.c, but the linker will
> still complain about unknown references to free_irq and request_irq.
> 
> As the whole kernel/irq folder depends on CONFIG_GENERIC_HARDIRQS 
> it seems consistent to declare all functions from kernel/irq only if
> CONFIG_GENERIC_HARDIRQS is set. Otherwise we can use empty functions.
> 
> This patch does that for register_irq and free_irq. 
> 
> Comments?

Please don't. So far whenever the linker complained about the missing
register_irq/free_irq functions it has been a bug in a Kconfig file.
We should not silently accept code that requires the concept of an
irq-line when there is no such thing on a s390.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


