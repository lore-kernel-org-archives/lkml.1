Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYKCN7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYKCN7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYKCN66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:58:58 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:59477 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbYKCN65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d+wdQTc7R3rmtQy4nVO1ZezyNaQ8s5Pg0w3++OR+u4M21/scgzxSWM3UwXEe5yHVUE
         5p0OfgU4R17h0HxAfiBdOoOTIm8rj/6s5LQ+Jy92QCqnPXJeI5p5E0r0/SVbESFGhE1q
         HZK97VSwNqz24+V/Sx4MPf2jjexw7q2hi6M0k=
Message-ID: <a5f59d880811030558v63da516dh3f46fb6a2fd7a6a5@mail.gmail.com>
Date: Mon, 3 Nov 2008 21:58:56 +0800
From: "Pengfei Hu" <hpfei.cn@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] 2.6.27: add a kernel hacking option to protect kernel memory between different modules
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <67704.1225715379@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a5f59d880811020615x297ff832kbce705d07318dfa2@mail.gmail.com>
	 <67704.1225715379@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> And your solution is to create a large slowdown, which will just make them
> look for ways to make it go faster... perhaps including even *more* stupid-crazy
> kernel thread tricks?
>

Maybe you don't like it, but it is true. My company's product use
linux but most of
programmer even don'nt knot splin lock. There are many bugs in their code. It is
nessary to avoid mistiake automaticly. My patch is just a kernel
hacking option and
it won't slowdonw kernel in release version. How do you think
CONFIG_DEBUG_PAGEALLOC,
it also slowdonw kernel. And if you ever used bounds checker or valgrind, they
slowdown even worse.

> Can you point at any bugs/failure modes that this patch would detect, but
> would *not* be found by any of the already-existing memory debugging tools?

You know the worst bug of memory allocation is dangling pointer if tow module
use one allocator. Although there are some tool can detect this bug, but all of
them works in user space. They can use in kernel.

> Is it at all sane to expect that a reasonable setting can be done for
> things like slab and vmalloc?  What happens when multiple modules allocate
> out of the same slab, or even worse, get vmalloc/kmalloc for *different*
> things on the same physical page?  It seems that unless you can separate
> memory allocations by module, this isn't going to provide a lot of help in
> finding memory allocation/usage issues.
>

I want to let every registered module use it own caches just like
general caches.
The unit of vmalloc's size is page, so it won't have any trouble. The
protection must
work on page. I know the current code of kernel doesn't need this "private page"
feature. But maybe in the future it will get some help. And this
feature is compitable
with the current "globle page". It just like kernel support
SCHED_FIFO. Do you think
SCHED_FIFO is helpful to normal linux system?
