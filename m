Return-Path: <linux-kernel-owner+w=401wt.eu-S1751049AbXCSMh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbXCSMh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXCSMh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:37:59 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:14023 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXCSMh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lur1kHs0aATB0dbgd5QbQpbTbmJVdGbJwSOixzUbdALLlW95k5JqdyfQw5++PWNkJ+vHHIownLu7Xg0BvWRCnp1vm7dz6eMEj9BLp/5HFvMnRqz+3Kt5TQT5ApFr70CVxQxcfPXd87Zmo1PshybXSvOlJGv7v7ouTlmK4YsYFZA=
Message-ID: <6eb6ed920703190537o3c4738d6l61dd946d9554b4a3@mail.gmail.com>
Date: Mon, 19 Mar 2007 20:37:57 +0800
From: "railroad seeker" <railroad.seeker@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Scheduling in interrupt and call trace
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

I am tracking a driver bug in arm linux when I got a scheduling in
interrupt context
panic.

I traced into kernel schedule() function, and found that "schedulingin
interrupt" is a
check point when the process scheduler is invoked, and the callstack
reveals that
the scheduler is invoked due to semaphore down().

After that, the program counter must located in BUG(), that is something like
"(void *)0 = 0" if we really do scheduling in interrupt contxt, and
should cause
the kernel to panic. However, what i got is that the latest program
counter is located within the do_IRQ() context when the kernel was
crashed . But it
seems that the stack trace is a kernel stack of process context since
the bottom of the stack is ret_from_syscall. (I have not enabled the
frame pointer when compiling the kernel, instead, I back traced by
manually inspect each 32 bit value
from the output of objdump) , and I think that the latest PC should
point to the next instruction of "(void *) 0 = 0".

Is there any possibility with which we got this incorrect information,
 or I have
misunderstanding about "kernel system to interrupt context switch?

Thanks.
