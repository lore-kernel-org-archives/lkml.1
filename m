Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYGBTKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYGBTKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYGBTKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:10:18 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:25020 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYGBTKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=XZfSymX5uFsq5nmdoWdzw5DsbN17RMSaIKARdjQw5lRP7F2AF5GiIEiIV/kw8U+IBi
         iV1oAyjKuFzjzQey7b76/jejeBcXPIpeX2xV6AuEKKGWcQ1zuVZgFrc+HZRE6ddtDVVH
         FhJNFd5M04Bx2WBbQmL1H4ZVO9j8TA74rTlnk=
Message-ID: <486BD19B.7040302@gmail.com>
Date: Wed, 02 Jul 2008 21:06:03 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
Subject: getcpu(2) man page
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Long ago, when I ran out of time, things stalled on incorporating a getcpu.2 man page that you
wrote ino man-pages.  There were still some open questions that I wanted to get sorted before
releasing the page.  Could you take a look at the FIXME(ak)s below please?

Cheers,

Michael

.\" This man page is Copyright (C) 2006 Andi Kleen <ak@muc.de>.
.\" Permission is granted to distribute possibly modified copies
.\" of this page provided the header is included verbatim,
.\" and in case of nontrivial modification author and date
.\" of the modification is added to the header.
.TH getcpu 2 2008-06-02 "Linux" "Linux Programmer's Manual"
.SH NAME
getcpu \- determine CPU and NUMA node on which the calling thread is running
.SH SYNOPSIS
.nf
.B #include <linux/getcpu.h>
.sp
.BI "int getcpu(unsigned *" cpu ", unsigned *" node \
", struct getcpu_cache *" tcache );
.fi
.SH DESCRIPTION
.BR getcpu ()
identifies the processor and node on which the calling
thread or process is currently
running and writes them into the integers pointed to by the
.I cpu
and
.I node
arguments.
The processor is a unique small integer identifying a CPU.
The node is a unique small identifier identifying a NUMA node.
When either
.I cpu
or
.I node
is NULL nothing is written to the respective pointer.
.I tcache
is a pointer to a
.I struct getcpu_cache.
The caller should put the cache into a thread
local variable if the process is multithreaded because the cache
cannot be shared between different threads.
.I tcache
can be NULL.
If it is not NULL
.BR getcpu ()
will use it to speed up operation.
The information inside the cache is private to the system call
and should not be accessed by the user program.
The information placed in the cache can change between kernel releases.

.\" FIXME(ak) If the following formulation is correct, I think it would
.\" be better to substitute it instead of the next sentence:
.\"     The information placed in \fIcpu\fP is only guaranteed to be
.\"     current at the time of the call: ...
This information is only a hint: unless the CPU affinity
has been fixed using
.BR sched_setaffinity (2),
the kernel might change the CPU at any time.
(Normally this does not happen
because the scheduler tries to minimize movements between CPUs to
keep caches hot, but it is possible.)
.\" FIXME(ak) Can you explain what you mean in the next sentence when
.\" you say "recover"
The caller has to properly recover from the case when
.I cpu
and
.I node
are not the current CPU and node anymore.
.\" FIXME(ak) In the following, what precisely do you mean by "advisory"?
.\" It is not really clear to me whether you mean the information
.\" may not be "true", or whether you are just reiterating the point that
.\" the CPU/node might already have changed by the time the call returns.
All information returned by
.I getcpu(2)
is just advisory and not a guarantee.

When no cache is specified
.BR getcpu ()
will be slower, but always retrieve the current state.
With a cache
.\" FIXME(ak) what does the phrase "but might query the current state
.\" only during a short implementation specific interval" mean?
it will be faster, but might query the current state only during
a short implementation specific interval.

Linux makes a best effort to make this call as fast possible. The
intention of
.I getcpu(2)
is to allow programs to make optimizations with per-CPU data
or for NUMA optimization.
.SH VERSIONS
.BR getcpu (2)
was added in 2.6.19 for x86_64 and i386.
.SH SEE ALSO
.BR mbind (2),
.BR set_mempolicy (2),
.BR sched_setaffinity (2)


