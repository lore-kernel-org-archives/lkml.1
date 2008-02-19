Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYBSRiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYBSRiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYBSRiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:38:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54633 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbYBSRh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:37:59 -0500
Message-ID: <47BB13ED.90705@zytor.com>
Date: Tue, 19 Feb 2008 09:37:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Crosby <jc4.james@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Ideal Architecture for Linux
References: <146444620802190601t63ac667cpd41d834cc98d10df@mail.gmail.com>
In-Reply-To: <146444620802190601t63ac667cpd41d834cc98d10df@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Crosby wrote:
> A stack based architecture is best, it makes nested interrupts, and general
> interruptibility very easy.

If you mean stack-based register file, then that's *not* desirable; 
Linux depends on gcc which prefers a flat register file.  16 registers 
minimum.

> Two hardware stack pointers, one for kernel stack and one for user mode
> stack of each task, but maybe a third, interrupt stack.

Don't necessarily have to be hardware registers, although it speed 
things up.  Interrupt stacks are good.

> At least two corresponding processor modes, a user mode with access only
> to 'safe' instructions, and a privileged one that can do anything. But would
> additional modes for interrupt handlers and system call handlers be
> beneficial?

Not in Linux.

> I would also consider it a significant security problem if when a task enters
> the kernel, kernel data is stored on the task's user-mode stack, since the
> task could fish around beyond the end of its stack and sniff private data. (This
> is, if I understand correctly, the reason ARM system mode is unused.)
> 
> But on the other hand, if each task didn't need a separate kernel stack, then
> there could be 4k or 8k less memory use per thread.

No, it would just be in a different place.  Linux will *NOT* accommodate 
this model.

> Is it necessarily the case that the more similar to x86, the better Linux 'fits'
> the architecture?

No, the x86 is lacking quite a few key features.

Linux would prefer to have address space numbers, instructions for 
user-space memory access in kernel mode, and a larger page size (4K is 
really too small for modern multi-gigabyte machines.)

The design of the I/O infrastructure is another matter, too.

	-hpa
