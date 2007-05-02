Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbXEBL4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbXEBL4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbXEBL4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:56:53 -0400
Received: from mail.suse.de ([195.135.220.2]:50887 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132AbXEBL4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:56:52 -0400
To: Michel Lespinasse <walken@zoy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
References: <20070501130715.GB29131@zoy.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 May 2007 14:54:29 +0200
In-Reply-To: <20070501130715.GB29131@zoy.org>
Message-ID: <p73irbbxu62.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@zoy.org> writes:
> 
> running with report_lost_ticks, I see the following:
> 
> May  1 12:58:57 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:58:59 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:59:01 server kernel: time.c: Lost 25 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:59:03 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)

This means some code disabled interrupts using a spinlock for far too long.
Can you add a dump_stack() in arch/x86_64/kernel/time.c:handle_lost_ticks()? That should 
tell the culprit

-Andi
