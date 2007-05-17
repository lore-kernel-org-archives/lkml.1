Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbXEQXd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbXEQXd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbXEQXds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:33:48 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbXEQXdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:33:47 -0400
Message-ID: <464CE653.4020006@zytor.com>
Date: Thu, 17 May 2007 16:33:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Philipp Kohlbecher <pk031698@uni-greifswald.de>
CC: Dave Jones <davej@codemonkey.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, linux-assembly@vger.kernel.org
Subject: Re: [PATCH 2.6.21.1] i386: save registers before intra-privilege
 syscall
References: <20070517220638.GA6532@localhost.localdomain> <464CD44A.5000307@zytor.com> <464CE4CA.8000704@uni-greifswald.de>
In-Reply-To: <464CE4CA.8000704@uni-greifswald.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Kohlbecher wrote:
> 
> I don't know of any problems this causes. The kernel needs to be aware
> of the fact that the xss and esp fields of the pt_regs struct may
> contain wrong values anyway, as hardware interrupts arriving while the
> CPU is in kernel mode would also lead to this condition.
> The file include/asm-i386/processor.h contains a comment to that effect
> (lines 483-492).
> With kernel_execve we can predict this, however, and account for it.
> (This may be superfluous, but I don't think it hurts and it might
> prevent future errors.)
> 

... and it may *cause* future errors by making it harder to find bugs, too.

In other words, your patch doesn't actually fix anything, it *masks*
potential bugs which would also be triggered by interrupts in kernel
mode.  This is bad.

You realize you just make a distinction between synchronous and
asynchronous events, such that your patch means that only asynchronous
events would catch the bugs you mask.  This makes bug hunting much harder.

If anything it would be better to poison those fields so that we can
smoke out anything that trusts them.

	-hpa
