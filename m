Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZHPNTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZHPNTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZHPNTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:19:08 -0400
Received: from www.tglx.de ([62.245.132.106]:60774 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZHPNTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:19:07 -0400
Date: Sun, 16 Aug 2009 15:19:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Buesch <mb@bu3sch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Threaded interrupt handlers broken?
In-Reply-To: <200908161153.14081.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.0908161516140.2782@localhost.localdomain>
References: <200908161153.14081.mb@bu3sch.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009, Michael Buesch wrote:

> Hi,
> 

> I was trying to use threaded interrupt handlers, but the code always
> crashes within irq_thread() with a "BUG: spinlock bad magic
> 00000000".  The spinlock that's not properly initialized is from the
> wait_for_threads waitqueue.
>
> It crashes on line 526 (see below).  The initialization of the
> waitqueue struct seems to depend on whether the IRQ is shared or
> not. I don't know if that's correct, but I patched it to
> unconditionally initialize the struct. That did not help.

Hmm. The waitqueue is initialized when the first handler is set up. In
that case shared == 0. When the second handler is installed we do not
initialize it again as it is already initialized and even might have
waiters queued. I'll have a look.

Thanks,

	tglx
