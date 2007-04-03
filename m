Return-Path: <linux-kernel-owner+w=401wt.eu-S966021AbXDCRaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966021AbXDCRaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966044AbXDCRaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:30:25 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4795 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966021AbXDCRaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:30:23 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 03 Apr 2007 17:30:16.0966 (UTC) FILETIME=[BEBAEA60:01C77615]
Content-class: urn:content-classes:message
Subject: Re: getting processor numbers
Date: Tue, 3 Apr 2007 13:30:16 -0400
Message-ID: <Pine.LNX.4.61.0704031427210.32278@chaos.analogic.com>
In-Reply-To: <461286D6.2040407@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: getting processor numbers
thread-index: Acd2Fb7CMMRZMODyS1ebULe9qxcTRg==
References: <461286D6.2040407@redhat.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Ulrich Drepper" <drepper@redhat.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 3 Apr 2007, Ulrich Drepper wrote:

> More and more code depends on knowing the number of processors in the
> system to efficiently scale the code.  E.g., in OpenMP it is used by
> default to determine how many threads to create.  Creating more threads
> than there are processors/cores doesn't make sense.
>
> glibc for a long time provides functionality to retrieve the number
> through sysconf() and this is what fortunately most programs use.  The
> problem is that we are currently using /proc/cpuinfo since this is all
> there was available at that time.  Creating /proc/cpuinfo takes the
> kernel quite a long time, unfortunately (I think Jakub said it is mainly
> the interrupt information).
>
> The alternative today is to use /sys/devices/system/cpu and count the
> number of cpu* directories in it.  This is somewhat faster.  But there
> would be another possibility: simply stat /sys/devices/system/cpu and
> use st_nlink - 2.
>
> This last step unfortunately it made impossible by recent changes:
>
>  http://article.gmane.org/gmane.linux.kernel/413178
>
> I would like to propose changing that patch, move the sched_*
> pseudo-files in some other directly and permanently ban putting any new
> file into /sys/devices/system/cpu.
>
> To get some numbers, you can try
>
>  http://people.redhat.com/drepper/nproc-timing.c
>
> The numbers I see on x86-64:
>
> cpuinfo 10145810 cycles for 100 accesses
> readdir /sys 3113870 cycles for 100 accesses
> stat /sys 741070 cycles for 100 accesses
>
> Note that for the first two methods I skipped the actual parsing part.
> This means in the real solution the gap between those two and the simple
> stat() call is even bigger.
>
> -- 
> ÿÿ Ulrich Drepper ÿÿ Red Hat, Inc. ÿÿ 444 Castro St ÿÿ Mountain View, CA ÿÿ
>
>

Shouldn't it just be another system call? 223 is currently unused. You
could fill that up with __NR_nr_cpus. The value already exists in
the kernel.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.65 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
