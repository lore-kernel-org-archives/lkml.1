Return-Path: <linux-kernel-owner+w=401wt.eu-S1030459AbXCVKt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459AbXCVKt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030461AbXCVKt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:49:27 -0400
Received: from www.osadl.org ([213.239.205.134]:51238 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030459AbXCVKt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:49:26 -0400
Subject: Re: [patch] setup_boot_APIC_clock() irq-enable fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070322093119.GA19394@elte.hu>
References: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com>
	 <20070322093119.GA19394@elte.hu>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 11:56:41 +0100
Message-Id: <1174561001.10840.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 10:31 +0100, Ingo Molnar wrote:
> Subject: [patch] setup_boot_APIC_clock() irq-enable fix
> From: Ingo Molnar <mingo@elte.hu>
> 
> latest -git triggers an irqtrace/lockdep warning of a leaked
> irqs-off condition:
> 
>   BUG: at kernel/fork.c:1033 copy_process()
> 
> after some debugging it turns out that commit ca1b940c accidentally left 
> interrupts disabled - which trickled down all the way to the first time 
> we fork a kernel thread and triggered the warning.
> 
> the fix is to re-enable interrupts in the 'else' branch of 
> setup_boot_APIC_clock()'s pmtimers calibration path.
> 
> Reported-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Thomas Gleixner <tglx@brown.paperbag.linutronix.de>



