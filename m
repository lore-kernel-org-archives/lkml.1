Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0BCDoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:44:17 -0500
Received: from relay.atmel.no ([80.232.32.139]:53938 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0BCDoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:44:15 -0500
X-Greylist: delayed 1519 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 22:44:15 EST
Date: Wed, 3 Feb 2010 08:47:37 +0530
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       hskinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 4/14] avr32: use generic ptrace_resume code
Message-ID: <20100203084737.6e01247b@siona>
In-Reply-To: <20100202185857.GD3630@lst.de>
References: <20100202185755.GA3630@lst.de>
	<20100202185857.GD3630@lst.de>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010 19:58:57 +0100
Christoph Hellwig <hch@lst.de> wrote:

> Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT,
> PTRACE_KILL and PTRACE_SINGLESTEP.  This implies defining
> arch_has_single_step in <asm/ptrace.h> and implementing the
> user_enable_single_step and user_disable_single_step functions, which
> also causes the breakpoint information to be cleared on fork, which
> could be considered a bug fix.
> 
> Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL
> which it previously wasn't which is consistent with all architectures
> using the modern ptrace code.
> 
> Currently avr32 doesn't implement any code to disable single stepping
> when one of the non-syscall requests is called which seems wrong,
> but I've left it as-is for now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Sounds like you found three bugs and fixed two of them. Can you tell me
more about the last one, i.e. what should be done to disable
single-stepping?

Haavard
