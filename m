Return-Path: <linux-kernel-owner+w=401wt.eu-S965254AbXHINDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254AbXHINDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938727AbXHINCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:02:53 -0400
Received: from www.osadl.org ([213.239.205.134]:38795 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S938678AbXHINCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:02:52 -0400
From: =?iso-8859-15?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 2/3] UIO: Documentation
Date: Thu, 9 Aug 2007 15:02:45 +0200
User-Agent: KMail/1.9.5
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <20070718232332.GA4620@kroah.com> <9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com> <14166.1186611154@turing-police.cc.vt.edu>
In-Reply-To: <14166.1186611154@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091502.45417.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 09 August 2007 00:12 schrieb Valdis.Kletnieks@vt.edu:

> 
> If you have UIO in the kernel talking to stuff in userspace, you're going to
> have to deal with closed-source stuff at the userspace end of the pipe.

That's no UIO invention. Userspace software that uses kernel interfaces like
syscall, device files, sysfs, and so on, is by definition _not_ a derived work
of the kernel and can be distributed under any license.

If you ask a manufacturer of an industrial IO card for a Linux driver today, 
you either get nothing at all, or you get an unmaintainable and buggy piece
of crap for an ancient kernel. The alternative is a binary kernel module that 
really violates the GPL.

With UIO, you have a kernel module that is so small, that even somebody who
hasn't got the hardware can easily review it and tell if the code is OK or not.
It is easy to maintain and doesn't reveal any secrets about the hardware.
The kernel remains clean, which further improves maintenance and debugging.
People frequently use /dev/mem to access hardware from userspace, that's
nothing new. UIO really improves this, making it safer and more user friendly.
And it prevents people from inventing dirty tricks to do some sort of 
interrupt handling in user space (which is simply not possible).

Furthermore, drivers for this kind of hardware are written by programmers in
industry, who often don't have kernel experience, reviews, time for tests,
and so on. I really prefer it if they do their stuff in userspace. And they
prefer it, too, because they can use all the nice tools and libraries they're
used to.

There might be a small possibility that a manufacturer now writes a closed
source UIO driver, and would have written an open source kernel driver if
UIO didn't exist. But, honestly, I doubt that we'll find many such cases.

Thanks,
Hans

