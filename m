Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYBSOBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYBSOBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYBSOBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:01:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:21927 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYBSOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:01:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=W2SDKkpEdNz4ajLwBw+9w6lNHCX7xAv323SWP61jrCnZoSbNWfr+o+i7qWlsGoJt+mCv7mHyaYWjEnmMEtrBw/YzS2Ne6QkCSkpfMuLJ22HoXq+HqeWwEz1d0US+NJTm0/c3/NdZzlxh3FKckKFftRyhnlVsKRKQaCs+55jy5oM=
Message-ID: <146444620802190601t63ac667cpd41d834cc98d10df@mail.gmail.com>
Date: Tue, 19 Feb 2008 14:01:21 +0000
From: "James Crosby" <jc4.james@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Ideal Architecture for Linux
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the point of view of one about to try to port the Linux kernel to a new
architecture:

I have recently been examining some of the existing ports of Linux to
architectures like various ARMs, SuperH, MIPS, m68k and nios2, and I
have realised that there are hardware features that are completely unused
(ARM system mode), and hardware features (kernel stack pointer in the
Motorola Coldfire port) that are completely absent, and emulated in
software.

Well aware that Linux was designed around the x86 architecture, and then
only at a later date were things restructured to make porting easier, and
with this in mind;
I am wondering what would be the best theoretical architecture to run Linux
on.

Clearly asking any 'best' question makes little sense without some kind of
benchmarks, so the things that I have in mind are:

System call (kernel entry/exit) overhead
Ease of saving and restoring a thread's context
Interrupt latency
Security
Memory requirements


Some of my own, quite conventional, thoughts are:

A stack based architecture is best, it makes nested interrupts, and general
interruptibility very easy.

Two hardware stack pointers, one for kernel stack and one for user mode
stack of each task, but maybe a third, interrupt stack.

At least two corresponding processor modes, a user mode with access only
to 'safe' instructions, and a privileged one that can do anything. But would
additional modes for interrupt handlers and system call handlers be
beneficial?

I would also consider it a significant security problem if when a task enters
the kernel, kernel data is stored on the task's user-mode stack, since the
task could fish around beyond the end of its stack and sniff private data. (This
is, if I understand correctly, the reason ARM system mode is unused.)

But on the other hand, if each task didn't need a separate kernel stack, then
there could be 4k or 8k less memory use per thread.

Is it necessarily the case that the more similar to x86, the better Linux 'fits'
the architecture?



I apologise if theoretical questions of this nature are not appropriate, and
appreciate any redirection to anywhere where they might be more so.

-- 
James Crosby
